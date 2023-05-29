//
//  HHDownloadManager.h
//  HHDownloadManager
//
//  Created by Michael on 2019/8/15.
//  Copyright © 2019 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHDownloadManager : NSObject

+ (instancetype)sharedManager;

///下载文件保存的目录，默认为…/Library/cache /HHDownloadManager。
@property (nonatomic, copy) NSString *saveFilesDirectory;

///最多下载的任务数，默认-1不限制个数。
@property (nonatomic, assign) NSInteger maxConcurrentCount;

///正在下载中的models
@property (nonatomic, strong) NSMutableArray <HHDownloadModel *> *downloadingModels;
///等待下载的数组models
@property (nonatomic, strong) NSMutableArray <HHDownloadModel *> *waitingModels;

///包括所有的正在下载中的models和等待下载的models
@property (nonatomic, strong) NSMutableDictionary *downloadModelsDic;


/// 下载
/// @param URLString 下载地址
/// @param destPath 下载保存本地路径
- (HHDownloadModel *)downloadURLString:(NSString *)URLString
                              destPath:(NSString * _Nullable)destPath;

/// 是否已经下载完毕 （下载完成）
- (BOOL)isDownloadCompletedOfURLString:(NSString *)URLString;
/// 已经添加在下载的字典中 （下载中或等待下载）
- (BOOL)isAddDownloadOfURLString:(NSString *)URLString;

/// <#Description#>
/// @param urlString 文件下载地址
- (HHDownloadModel *)downloadState:(NSString *)urlString;

///全部文件暂停下载
- (void)suspendAll;

#pragma mark - 删除文件
- (BOOL)deleteFileWithUrlString:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
