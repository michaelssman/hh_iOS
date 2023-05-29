//
//  oss_ios_demo.h
//  oss_ios_demo
//
//  Created by Michael on 9/16/15.
//  Copyright (c) 2015 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YYTAPI_HTTPS_PREFIX             @"http://toutiaoapitest.ningmengyun.com/"
#define YYTAPI_GET_OSS_TOKEN            @"api/common/AliyunStsForApp"

#define OSS_EndPoint                    @"http://oss-cn-beijing.aliyuncs.com"
#define OSS_bucketName                  @"toutiao-pictures"
#define UPLOAD_FILE_ERROR               @"上传文件格式错误"

@interface AliyunOSS : NSObject
@property (nonatomic, strong)MBProgressHUD *hud;

@property (nonatomic, copy)void (^uploadCompleted)(void);
@property (nonatomic, copy)void (^uploadFailed)(void);

@property (nonatomic, copy)void (^downloadCompleted)(NSArray *filePaths);
@property (nonatomic, copy)void (^downloadFailed)(void);

// 异步上传
- (void)uploadObjectAsync:(id)object key:(NSString *)key;
- (void)uploadObjectsAsync:(NSArray *)objects keys:(NSArray *)keys;

// 异步下载
- (void)downloadObjectsAsyncWithKeys:(NSArray *)keys;


+ (NSString *)generateUploadKeyWithModule:(NSString *)module suffix:(NSString *)suffix;
@end
