//
//  NSString+Base64.h
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2022/1/6.
//  Base64编码

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Base64)
// Base64编码方法
- (NSString *)base64EncodingString;

// Base64解码方法
- (NSString *)base64DecodingString;
@end

NS_ASSUME_NONNULL_END
