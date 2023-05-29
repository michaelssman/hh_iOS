//
//  oss_ios_demo.m
//  oss_ios_demo
//
//  Created by Michael on 9/16/15.
//  Copyright (c) 2015 michael. All rights reserved.
//

#import "AliyunOSS.h"
#import <AliyunOSSiOS/OSSService.h>

#define WEAKSELF                        __weak __typeof(self) weakSelf = self;

//NSString * const endPoint = @"http://oss-cn-beijing.aliyuncs.com";
//NSString * const multipartUploadKey = @"multipartUploadObject";

OSSClient * client;

@interface AliyunOSS ()
{
    NSMutableArray *filePaths;
}
@property (nonatomic, strong)NSArray *objects;
@property (nonatomic, strong)NSArray *keys;
@property (nonatomic, assign)NSUInteger currentIndex;
@end
@implementation AliyunOSS
- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentIndex = 0;
        // 打开调试log
        [OSSLog enableLog];
        /// 初始化sdk 一次性代码 整个程序运行过程 只加载运行一次, 再创建对象也没用
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//        });
        [self initOSSClient];
        //            [self requestData];
    }
    return self;
}
#pragma mark 从服务器请求需要的信息
- (void)requestData:(void(^)(OSSFederationToken *stsToken))block {
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", YYTAPI_HTTPS_PREFIX, YYTAPI_GET_OSS_TOKEN]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    //设置请求头
    [request setValue:@"bearer QItbBH4bBAVwrAjfEZ1Z4iN9MMahgvuW1RcJkbQ-r12mZXAIU5W57V7-NNaEgID_6kl9VXcaGvtHmffrb8d_nySiMTTPx6jrGGUOqVyySuKMKBSdGUh45mFp6-Gum5h3Roq-DO02UfhOVgWcRvllGXOdpDdIUx-GTfDw2EutVZfvZRIEDI6vVihkpFiZjk_k4WH8OML96Lc-D0-8-8Va4Q" forHTTPHeaderField:@"Authorization"];
    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [tcs setError:error];
                                                        return;
                                                    }
                                                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                    NSDictionary *dataDic = result[@"data"];
                                                    NSData *resultData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
                                                    [tcs setResult:resultData];
                                                }];
    [sessionTask resume];
    [tcs.task waitUntilFinished];
    if (tcs.task.error) {
        NSLog(@"get oss token error");
        //处理出错情况
//        return nil;
        block(nil);
    } else {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                options:kNilOptions
                                                                  error:nil];
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = [object objectForKey:@"accessKeyId"];
        token.tSecretKey = [object objectForKey:@"accessKeySecret"];
        token.tToken = [object objectForKey:@"securityToken"];
        token.expirationTimeInGMTFormat = [object objectForKey:@"expiration"];
        block(token);
//        return token;
    }
}
- (void)initOSSClient {
    //自动管理
//    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
//        return [self requestData];
//    }];
    
    //手动管理
    [self requestData:^(OSSFederationToken *stsToken) {
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc]initWithAccessKeyId:stsToken.tAccessKey secretKeyId:stsToken.tSecretKey securityToken:stsToken.tToken];
        
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 2;
        conf.timeoutIntervalForRequest = 30;
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        
        client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    }];
//    OSSFederationToken *stsToken = [self requestData];
}

- (void)uploadObjectsAsync:(NSArray *)objects keys:(NSArray *)keys {
    if (objects.count > 0 && keys.count > 0) {
        self.objects = objects;
        self.keys = keys;
        self.currentIndex = 0;
        [self uploadObjectAsync:objects[0] key:keys[0]];
    } else {
        if (self.uploadCompleted) {
            self.uploadCompleted();
        }
    }
}

- (void)uploadObjectAsync:(id)object key:(NSString *)key {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = OSS_bucketName;
    put.objectKey = key;
    
    if ([object isKindOfClass:[NSData class]]) {
        put.uploadingData = object;
    } else if ([object isKindOfClass:[NSString class]]) {
        put.uploadingFileURL = [NSURL fileURLWithPath:object];
    } else {
        NSLog(@"%@",UPLOAD_FILE_ERROR);
        return;
    }
    WEAKSELF
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        float progress = 1.0 * totalByteSent / totalBytesExpectedToSend;
        if (weakSelf.objects && weakSelf.objects.count > 1) {
            progress = progress / weakSelf.objects.count + 1.0 * self.currentIndex / weakSelf.objects.count;
        }
        NSLog(@"上传进度---%.4f", progress);
        
        if (self.hud) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud.progress = progress;
            });
        }
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object %lu success!", (unsigned long)self.currentIndex);
            if (weakSelf.objects && self.currentIndex < weakSelf.objects.count - 1) {
                self.currentIndex = self.currentIndex + 1;
                [self uploadObjectAsync:weakSelf.objects[self.currentIndex] key:weakSelf.keys[self.currentIndex]];
            } else {
                NSLog(@"upload completed!");
                if (self.uploadCompleted) {
                    self.uploadCompleted();
                }
            }
        } else {
            NSLog(@"upload object %lu failed, error: %@" ,(unsigned long)self.currentIndex, task.error);
            if (self.uploadFailed) {
                self.uploadFailed();
            }
        }
        return nil;
    }];
}
#pragma mark 下载
- (void)downloadObjectsAsyncWithKeys:(NSArray *)keys {
    filePaths = [NSMutableArray arrayWithCapacity:0];
    self.keys = keys;
    self.currentIndex = 0;
    [self downloadObjectWithKey:keys[0]];
}
- (void)downloadObjectWithKey:(NSString *)key {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = OSS_bucketName;
    request.objectKey = key;
    
    NSString * docDir = [AliyunOSS getDownLoadingDocumentDirectory];
    request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:key]];
    [filePaths addObject:[docDir stringByAppendingPathComponent:key]];
    
    WEAKSELF
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        float progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite / weakSelf.keys.count + 1.0 * self.currentIndex / weakSelf.keys.count;
        if (self.hud) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud.progress = progress;
            });
        }
    };
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            //            OSSGetObjectResult * getResult = task.result;
            //            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
            if (self.currentIndex < weakSelf.keys.count - 1) {
                ++self.currentIndex;
                [self downloadObjectWithKey:weakSelf.keys[self.currentIndex]];
            } else {
                if (self.downloadCompleted) {
                    self.downloadCompleted(filePaths);
                }
            }
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
            if (self.downloadFailed) {
                self.downloadFailed();
            }
        }
        return nil;
    }];
}

// get local file dir which is readwrite able
+ (NSString *)getDownLoadingDocumentDirectory {
    NSString * documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * downloadPath = [documentsDirectory stringByAppendingPathComponent:@"优艺通下载"];
    NSLog(@"%@",downloadPath);
    return downloadPath;
}
+ (NSString *)generateUploadKeyWithModule:(NSString *)module suffix:(NSString *)suffix {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *folder = [dateFormatter stringFromDate:now];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileNamePrefix = [dateFormatter stringFromDate:now];
    
    return [NSString stringWithFormat:@"%@/%@/%@_%d_%d.%@", module, folder, fileNamePrefix, 23, arc4random() % 1000, suffix];
}
@end
