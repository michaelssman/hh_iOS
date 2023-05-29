//
//  NSString+Base64.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2022/1/6.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)
// Base64编码方法
- (NSString *)base64EncodingString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];;
}

// Base64解码方法
- (NSString *)base64DecodingString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
