//
//  HHDownloadModel.h
//  HHDownloadManager
//
//  Created by Michael on 2019/8/15.
//  Copyright © 2019 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HHDownloadState) {
    ///等待下载，用于添加到等待下载的队列中
    HHDownloadStateWaiting,
    ///开始下载，在正在下载的队列中
    HHDownloadStateRunning,
    HHDownloadStateSuspended,
    HHDownloadStateCanceled,
    HHDownloadStateCompleted,
    ///下载失败
    HHDownloadStateFailed,
    HHDownloadStateLocalSuspended
};

NS_ASSUME_NONNULL_BEGIN

@interface HHDownloadModel : NSObject

@property (nonatomic, strong) NSOutputStream *outputStream; // write datas to the file

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) NSInteger totalLength;

/// 保存路径
@property (nonatomic, copy) NSString *destPath;

@property (nonatomic, assign) HHDownloadState downloadState;



@property (nonatomic, copy) void (^state)(HHDownloadState state);

///每个下载任务的下载进度的回调
@property (nonatomic, copy) void (^progress)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);

///下载完成的回调
@property (nonatomic, copy) void (^completion)(BOOL isSuccess,  NSString * _Nullable filePath, NSError *error);

- (void)openOutputStream;

- (void)closeOutputStream;

@end

NS_ASSUME_NONNULL_END
