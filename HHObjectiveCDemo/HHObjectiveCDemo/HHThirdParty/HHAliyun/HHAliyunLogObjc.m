//
//  HHAliyunLogObjc.m
//  LemonCloud
//
//  Created by Michael on 2019/2/13.
//  Copyright © 2019 sunny. All rights reserved.
//

#import "HHAliyunLogObjc.h"
#import <AliyunLogObjc.h>
#import <sys/utsname.h>
//#import "HHFMDBHeader.h"
//#define kLogTableName   @"logTableName03121504"

@implementation HHAliyunLogInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

@interface HHAliyunLogObjc()
@property (nonatomic, strong)LogClient *client;
@property (nonatomic, strong)RawLogGroup *logGroup;
@property (nonatomic, strong)HHAliyunLogInfoModel *logInfoModel;

///存储数据库的数据类型
//@property (nonatomic, strong)NSDictionary *dicOrModel;
@end
@implementation HHAliyunLogObjc

///存储数据库的数据类型
//- (NSDictionary *)dicOrModel {
//    if (!_dicOrModel) {
//        self.dicOrModel = @{@"errorType":SQL_TEXT,@"logTime":SQL_TEXT,@"logData":SQL_TEXT,@"URL":SQL_TEXT,@"Method":SQL_TEXT,@"header":SQL_TEXT,@"UserAgent":SQL_TEXT,@"jsonBody":SQL_TEXT,@"params":SQL_TEXT,@"callBackData":SQL_TEXT,@"exceptionData":SQL_TEXT,@"phoneBrand":SQL_TEXT,@"phoneModel":SQL_TEXT,@"topic":SQL_TEXT};
//    }
//    return _dicOrModel;
//}

+ (nonnull instancetype)sharedTool {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [[FMDBTool sharedTool] createTableWithTableName:kLogTableName dicOrModel:self.dicOrModel excludeName:nil];
    }
    return self;
}
#pragma mark    添加日志
- (void)addAliyunLogData:(NSString *)logData
               errorType:(NSString *)errorType
                     URL:(NSString *)URL
                  Method:(NSString *)Method
                  header:(NSString *)header
                jsonBody:(NSString *)jsonBody
                  params:(NSString *)params
            callBackData:(NSString *)callBackData
           exceptionData:(NSString *)exceptionData {
//    if (logData) {
//        NSString *userPhone = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentUserName];
//        if (!userPhone) {
//            userPhone = @"未登录";
//        }
//
//    [[FMDBTool sharedTool] insertWithTableName:kLogTableName dataSource:@{@"errorType":errorType,@"logTime":[FuData chinaDate],@"logData":logData,@"URL":URL,@"Method":Method,@"header":header,@"UserAgent":[NSString stringWithFormat:@"lemonapp/%@/DeviceID:%@/", [FuData versionNumber], [[NSUserDefaults standardUserDefaults] objectForKey:@"LMPHONEUUID"]],@"jsonBody":jsonBody,@"params":params,@"callBackData":callBackData,@"exceptionData":exceptionData,@"phoneBrand":@"苹果",@"phoneModel":[self iphoneType],@"topic":userPhone} useTransaction:NO dicOrModel:self.dicOrModel];
//    }
}
- (void)commitAliyunLog {
    if (!self.client || !self.logGroup) {
        return;
    }
    NSString *logLevel = self.logInfoModel.logLevel ? self.logInfoModel.logLevel : @"2";
    NSString *sqlString = [NSString stringWithFormat:@"errorType < %@",logLevel];
//    NSArray *logs = [[FMDBTool sharedTool] selectTable:kLogTableName dicOrModel:self.dicOrModel whereFormat:sqlString, nil];

    //上传的日志
    NSArray *logs;
    for (NSDictionary *dic in logs) {
        RawLog *log1 = [[RawLog alloc] init];
        for (NSString *key in dic.allKeys) {
            [log1 PutContent:dic[key] withKey:key];
        }
        [self.logGroup PutLog:log1];
    }
    [self.client PostLog:self.logGroup logStoreName:self.logInfoModel.logStoreName call:^(NSURLResponse* _Nullable response,NSError* _Nullable error) {
        if (error != nil) {
        }
    }];
    
    ///删除上传的日志
//    [[FMDBTool sharedTool] deleteTable:kLogTableName whereFormat:sqlString, nil];
    ///删除旧日志
//    NSString *oldDate = [self oldLogDate];
//    [[FMDBTool sharedTool] deleteTable:kLogTableName whereFormat:[NSString stringWithFormat:@"logTime < %@",oldDate], nil];
}

- (NSString *)oldLogDate
{
    
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval = seconds + 8 * 3600 - 24 * 3600 * 7;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    NSString *string = [[NSString alloc] initWithFormat:@"%@",date];
    return string;
}

#pragma mark   设置信息
- (void)initClient {
    // Use JSON
    // AliSLSProtobufSerializer - Protobuf serializer is available now
    LogClient *client = [[LogClient alloc] initWithApp: self.logInfoModel.endPoint accessKeyID:self.logInfoModel.accessKeyId accessKeySecret:self.logInfoModel.accessKeySecret projectName:self.logInfoModel.projectName serializeType: AliSLSJSONSerializer];
    [client SetToken:self.logInfoModel.securityToken];
    //app设备信息
    NSString *topic = [NSString stringWithFormat:@"这里写APP名称/这里写APP版本"];
    NSString *source = [NSString stringWithFormat:@"%@ iOS %@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]];
    RawLogGroup *logGroup = [[RawLogGroup alloc] initWithTopic: [NSString stringWithFormat:@"%@ user:这里写用户名",topic] andSource:source];
    self.client = client;
    self.logGroup = logGroup;
    [self commitAliyunLog];
}

//.手机类型：iPhone 6
- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    return platform;
    
}

#pragma mark 请求上传日志需要的配置信息
- (void)requestNet:(void (^)(BOOL succeed))block
{
    
}
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString * access_token =[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
//    if (access_token) {
//        NSString * temp = [NSString stringWithFormat:@"Bearer %@",access_token];
//        [manager.requestSerializer setValue:temp forHTTPHeaderField:@"Authorization"];
//    }
//    [manager GET:[NSString stringWithFormat:@"%@/api/common/LogTocken",kTestURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([responseObject[@"code"] isEqual:@(1000)]) {
//            NSDictionary *dataDic = responseObject[@"data"];
//            self.accessKeyId = dataDic[@"accessKeyId"];
//            self.accessKeySecret = dataDic[@"accessKeySecret"];
//            self.endPoint = dataDic[@"endPoint"];
//            self.expiration = dataDic[@"expiration"];
//            self.logStoreName = dataDic[@"logStoreName"];
//            self.projectName = dataDic[@"projectName"];
//            self.securityToken = dataDic[@"securityToken"];
//            self.logLevel = [NSString stringWithFormat:@"%d",[dataDic[@"logLevel"] intValue] + 1];
//            block(YES);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//}

@end
