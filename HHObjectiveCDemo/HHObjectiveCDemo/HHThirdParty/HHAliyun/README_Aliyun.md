# HHOSSDemo
封装阿里云OSS图片上传


### 日志上传
`pod 'AliyunSlsObjc', '~> 1.1.7'`使用`pod install` 不管用 报错：
```
[!] /bin/bash -c 
set -e
protoc -I "./AliyunLogObjc" --objc_out="./AliyunLogObjc/serde" "./AliyunLogObjc/sls.proto"

/bin/bash: line 2: protoc: command not found
```
解决方法
Install grpc and protobuf：`brew install grpc protobuf`

### 阿里云日志
##### 第一步`pod`
```
pod 'AliyunSlsObjc', '~> 1.1.6'
```
##### 导入头文件`#import <AliyunSlsObjc/AliyunLogObjc/AliyunLogObjc.h>`
##### 上传日志
```
/**
提交日志
1.client:client要SetToken
2.有日志数组RawLogGroup，把每一条日志RawLog都存到数组中，最后一起提交。
RalLog可以设置key和content，设置不同的键和对应的值。
在阿里云后台看到RawLogGroup里面包括：
__source__
__topic__
__tag__:__client_ip__
__tag__:__receive_time__
RawLog不同的键值
*/
- (void)commitAliyunLog {
// Use JSON
// AliSLSProtobufSerializer - Protobuf serializer is available now
LogClient *client = [[LogClient alloc] initWithApp: self.endPoint accessKeyID:self.accessKeyId accessKeySecret:self.accessKeySecret projectName:self.projectName serializeType: AliSLSJSONSerializer];
[client SetToken:self.securityToken];

//自定义 app名和app版本
NSString *topic = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey]];
//自定义  手机型号和系统版本号
NSString *source = [NSString stringWithFormat:@"%@ iOS %@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]];
RawLogGroup *logGroup = [[RawLogGroup alloc] initWithTopic: topic andSource:source];

RawLog *log1 = [[RawLog alloc] init];
[log1 PutContent: <#CustomValue1#> withKey: <#CustomKey1#>];
[log1 PutContent: <#CustomValue2#> withKey: <#CustomKey2#>];
[log1 PutContent: <#CustomValue3#> withKey: <#CustomKey3#>];
...

[logGroup PutLog:log1];
[client PostLog:logGroup logStoreName:self.logStoreName call:^(NSURLResponse* _Nullable response,NSError* _Nullable error) {
if (error != nil) {
}
}];
}
```
