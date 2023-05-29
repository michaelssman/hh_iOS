//
//  NSObject+Util.m
//  HHCategorysDemo
//
//  Created by Michael on 2021/1/13.
//  Copyright © 2021 michael. All rights reserved.
//

#import "NSObject+Util.h"

@implementation NSObject (Util)

#pragma mark - json
/// 字典（数组）对象转json字符串
- (NSString *)getJSONString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (error == nil) {
            NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return jsonString;
        } else {
            NSLog(@"Json write error: %@ \n", [error description]);
        }
    }
    return nil;
}

/// JSON字符串转化为字典
+ (id)getObjectFromJSONString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return jsonObj;
}

@end
