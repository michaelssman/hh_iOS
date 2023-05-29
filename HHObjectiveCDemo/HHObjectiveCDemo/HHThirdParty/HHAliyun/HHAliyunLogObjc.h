//
//  HHAliyunLogObjc.h
//  LemonCloud
//
//  Created by Michael on 2019/2/13.
//  Copyright © 2019 sunny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark 日志上传需要的配置信息
@interface HHAliyunLogInfoModel : NSObject
@property (nonatomic, copy)NSString *accessKeyId;
@property (nonatomic, copy)NSString *accessKeySecret;
@property (nonatomic, copy)NSString *endPoint;
@property (nonatomic, copy)NSString *expiration;
@property (nonatomic, copy)NSString *logStoreName;
@property (nonatomic, copy)NSString *projectName;
@property (nonatomic, copy)NSString *securityToken;
@property (nonatomic, copy)NSString *logLevel;
@end

@interface HHAliyunLogObjc : NSObject

+ (nonnull instancetype)sharedTool;

/// 请求需要的配置信息
- (void)requestNet:(void (^)(BOOL succeed))block;

/// 初始化
- (void)initClient;

/**
 int errorType;      // 日志类别   1:异常日志   2:调试日志
 
 String logTime;     // 记录日志时间
 
 String logData;             // log内容
 
 String URL;                 // 请求URL
 
 String Method;              // 请求方式
 
 String header;              // 请求头
 
 String UserAgent;           // UA
 
 String jsonBody;            // 请求jsonBody
 
 String params;              // 请求参数
 
 String requestTime;         // 请求时间
 
 String callBackData;        // 返回数据
 
 String exceptionData;       // 异常数据
 
 String topic;               // 主题信息
 
 String appInfo;             // app版本信息
 
 String phoneBrand;           // 手机品牌
 
 String phoneModel;           // 手机型号
 
 String androidSystemVersion;    // Android系统
 
 String androidSDK;              // AndroidSDK
 */
- (void)addAliyunLogData:(NSString *)logData
               errorType:(NSString *)errorType
                     URL:(NSString *)URL
                  Method:(NSString *)Method
                  header:(NSString *)header
                jsonBody:(NSString *)jsonBody
                  params:(NSString *)params
            callBackData:(NSString *)callBackData
           exceptionData:(NSString *)exceptionData;
@end

NS_ASSUME_NONNULL_END
