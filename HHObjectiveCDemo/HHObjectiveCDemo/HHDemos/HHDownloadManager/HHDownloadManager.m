//
//  HHDownloadManager.m
//  HHDownloadManager
//
//  Created by Michael on 2019/8/15.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHDownloadManager.h"

///下载的文件的名字，使用url最后的路径
#define HHFileName(URL) [URL lastPathComponent]

///下载文件的总大小，在开始下载时 保存到.plist中
#define HHFilesTotalLengthPlistPath [self.saveFilesDirectory stringByAppendingPathComponent:@"HHFilesTotalLength.plist"]

@interface HHDownloadManager()<NSURLSessionDelegate,NSURLSessionDataDelegate>
@end
@implementation HHDownloadManager
#pragma mark lazy load
- (NSString *)saveFilesDirectory
{
    //下载目录 区分不同用户
    _saveFilesDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",NSStringFromClass([self class]),@"userID"]];
    NSString *downloadDirectory = _saveFilesDirectory;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:downloadDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _saveFilesDirectory;
}

- (NSMutableDictionary *)downloadModelsDic {
    if (!_downloadModelsDic) {
        self.downloadModelsDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _downloadModelsDic;
}
- (NSMutableArray<HHDownloadModel *> *)downloadingModels {
    if (!_downloadingModels) {
        self.downloadingModels = [NSMutableArray arrayWithCapacity:0];
    }
    return _downloadingModels;
}
- (NSMutableArray<HHDownloadModel *> *)waitingModels {
    if (!_waitingModels) {
        self.waitingModels = [NSMutableArray arrayWithCapacity:0];
    }
    return _waitingModels;
}

+ (instancetype)sharedManager {
    static HHDownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
    });
    return downloadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.maxConcurrentCount = -1;
    }
    return self;
}

- (HHDownloadModel *)downloadURLString:(NSString *)URLString destPath:(NSString *)destPath
{
    NSURL *URL = [NSURL URLWithString:URLString];

    if (!URL) {
        return nil;
    }
    
    //已经下载完毕
    if ([self isDownloadCompletedOfURLString:URLString]) { // if this URL has been downloaded
//                if (self.completion) {
//                    self.completion(YES, [self fileFullPathOfURL:URL], nil);
//                }
        return nil;
    }
    
    //已经添加在下载的字典中
    if ([self isAddDownloadOfURLString:URLString]) {
        HHDownloadModel *downloadModel = self.downloadModelsDic[HHFileName(URL)];
        return downloadModel;
    }
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    // Range
    // bytes=x-y ==  x byte ~ y byte
    // bytes=x-  ==  x byte ~ end
    // bytes=-y  ==  head ~ y byte
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:URL];
    //    requestM.timeoutInterval = -1;
    [requestM setValue:[NSString stringWithFormat:@"bytes=%ld-", (long)[self hasDownloadedLength:URL]] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:requestM];
    dataTask.taskDescription = HHFileName(URL);
    
    HHDownloadModel *downloadModel = [[HHDownloadModel alloc] init];
    downloadModel.dataTask = dataTask;
    downloadModel.outputStream = [NSOutputStream outputStreamToFileAtPath:[self fileFullPathOfURL:URL] append:YES];
    downloadModel.URLString = URLString;
    downloadModel.URL = URL;
    downloadModel.destPath = destPath;
    
    self.downloadModelsDic[dataTask.taskDescription] = downloadModel;
    
    HHDownloadState downloadState;
    //判断当前下载个数
    if ([self canResumeDownload]) {
        [self.downloadingModels addObject:downloadModel];
        [dataTask resume];
        downloadState = HHDownloadStateRunning;
    } else {
        [self.waitingModels addObject:downloadModel];
        downloadState = HHDownloadStateWaiting;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        downloadModel.downloadState = downloadState;
        if (downloadModel.state) {
            downloadModel.state(downloadState);
        }
    });
    return downloadModel;
}

#pragma mark - NSURLSessionDataDelegate
///网络请求成功, 开始下载.
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    HHDownloadModel *downloadModel = self.downloadModelsDic[dataTask.taskDescription];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel openOutputStream];
    
    // response.expectedContentLength == [HTTPResponse.allHeaderFields[@"Content-Length"] integerValue]
    // response.expectedContentLength + [self hasDownloadedLength:downloadModel.URL] == [[HTTPResponse.allHeaderFields[@"Content-Range"] componentsSeparatedByString:@"/"].lastObject integerValue]
    NSInteger totalLength = (long)response.expectedContentLength + [self hasDownloadedLength:downloadModel.URL];
    downloadModel.totalLength = totalLength;
    
    NSMutableDictionary *filesTotalLengthDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:HHFilesTotalLengthPlistPath] ?: [NSMutableDictionary dictionary];
    filesTotalLengthDictionary[HHFileName(downloadModel.URL)] = @(totalLength);
    [filesTotalLengthDictionary writeToFile:HHFilesTotalLengthPlistPath atomically:YES];
    
    completionHandler(NSURLSessionResponseAllow);
}
///正在接受数据, 写入文件并且更新UI进度
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    HHDownloadModel *downloadModel = self.downloadModelsDic[dataTask.taskDescription];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel.outputStream write:data.bytes maxLength:data.length];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadModel.progress) {
            NSUInteger receivedSize = [self hasDownloadedLength:downloadModel.URL];
            NSUInteger expectedSize = downloadModel.totalLength;
            if (expectedSize == 0) {
                return;
            }
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            downloadModel.progress(receivedSize, expectedSize, progress);
        }
    });
}
///下载完毕, 下载完成.
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    //    if (error && (error.code == -1005 ||error.code == -1009)) {
    //        [self suspendAllDownloads];
    //    }
    if (error && error.code == -999) { // cancel task
        return;
    }
    
    HHDownloadModel *downloadModel = self.downloadModelsDic[task.taskDescription];
    if (!downloadModel) {
        return;
    }
    
    [downloadModel closeOutputStream];
    
    [self.downloadModelsDic removeObjectForKey:task.taskDescription];
    [self.downloadingModels removeObject:downloadModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isDownloadCompletedOfURLString:downloadModel.URLString]) {
            NSString *destPath = downloadModel.destPath;
            NSString *fullPath = [self fileFullPathOfURL:downloadModel.URL];
            if (destPath) {
                NSError *error;
                if (![[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:destPath error:&error]) {
                    NSLog(@"moveItemAtPath error: %@", error);
                }
            }
            downloadModel.downloadState = HHDownloadStateCompleted;
            if (downloadModel.state) {
                downloadModel.state(HHDownloadStateCompleted);
            }
            if (downloadModel.completion) {
                downloadModel.completion(YES, destPath ?: fullPath, error);
            }
        } else {
            downloadModel.downloadState = HHDownloadStateFailed;
            if (downloadModel.state) {
                downloadModel.state(HHDownloadStateFailed);
            }
            if (downloadModel.completion) {
                downloadModel.completion(NO, nil, error);
            }
        }
    });
    
    [self resumeFirstWillResume];
}

#pragma mark - 文件下载状态
- (HHDownloadModel *)downloadState:(NSString *)urlString
{
    HHDownloadModel *model = [[HHDownloadModel alloc]init];
    if ([self isDownloadCompletedOfURLString:urlString]) {
        model.downloadState = HHDownloadStateCompleted;
    }
    else if([self isAddDownloadOfURLString:urlString]) {
        NSURL *URL = [NSURL URLWithString:urlString];
        model = self.downloadModelsDic[HHFileName(URL)];
    }
    return model;
}

#pragma mark - 让第一个等待下载的文件开始下载
- (void)resumeFirstWillResume
{
    if (self.waitingModels.count) {
        HHDownloadModel *downloadModel = self.waitingModels.firstObject;
        [downloadModel.dataTask resume];
        [self.downloadingModels addObject:downloadModel];
        [self.waitingModels addObject:downloadModel];
    }
}

#pragma mark - 已下载文件大小
- (NSInteger)hasDownloadedLength:(NSURL *)URL {
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self fileFullPathOfURL:URL] error:nil];
    if (!fileAttributes) {
        return 0;
    }
    return [fileAttributes[NSFileSize] integerValue];
}

#pragma mark - Assist Methods
#pragma mark - 是否可以下载
- (BOOL)canResumeDownload {
    if (self.maxConcurrentCount == -1) {
        return YES;
    }
    if (self.downloadingModels.count >= self.maxConcurrentCount) {
        return NO;
    }
    return YES;
}

#pragma mark - 下载文件总大小
- (NSInteger)totalLengthWithURL:(NSURL *)URL {
    NSDictionary *filesTotalLenthDic = [NSDictionary dictionaryWithContentsOfFile:HHFilesTotalLengthPlistPath];
    if (!filesTotalLenthDic) {
        return 0;
    }
    if (!filesTotalLenthDic[HHFileName(URL)]) {
        return 0;
    }
    return [filesTotalLenthDic[HHFileName(URL)] integerValue];
}

#pragma mark - Public Methods
#pragma mark - 文件已经下载完成
- (BOOL)isDownloadCompletedOfURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    NSInteger totalLength = [self totalLengthWithURL:URL];
    if (totalLength != 0) {
        if (totalLength == [self hasDownloadedLength:URL]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 文件已经添加在下载中或等待下载中
- (BOOL)isAddDownloadOfURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];

    HHDownloadModel *downloadModel = self.downloadModelsDic[HHFileName(URL)];
    if (downloadModel) { // if the download model of this URL has been added in downloadModelsDic
        return YES;
    }
    return NO;
}

#pragma mark - Files
///下载的文件所在的本地完整路径
- (NSString *)fileFullPathOfURL:(NSURL *)URL {
    return [self.saveFilesDirectory stringByAppendingPathComponent:HHFileName(URL)];
}

#pragma mark - 暂停所有的任务
- (void)suspendAll
{
    [self.downloadingModels enumerateObjectsUsingBlock:^(HHDownloadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.dataTask suspend];
        [self.waitingModels addObject:obj];
    }];
    [self.downloadingModels removeAllObjects];
}

#pragma mark - 删除文件
- (BOOL)deleteFileWithUrlString:(NSString *)urlString
{
    NSString *filePath = [self fileFullPathOfURL:[NSURL URLWithString:urlString]];
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    if (result) {
        NSURL *URL = [NSURL URLWithString:urlString];
        HHDownloadModel *downloadModel = self.downloadModelsDic[HHFileName(URL)];
        if (downloadModel) { // if the download model of this URL has been added in downloadModelsDic
            [self.downloadModelsDic removeObjectForKey:HHFileName(URL)];
            [self.downloadingModels removeObject:downloadModel];
            [self.waitingModels removeObject:downloadModel];
        }

    }
    return result;
}

@end
