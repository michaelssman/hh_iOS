//
//  NSString+Adaptive.h
//  HHObjectiveCDemo
//
//  Created by ebsinori on 16/7/27.
//  Copyright © 2016年 ebsinori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Adaptive)

- (CGFloat)heightWithMaxWidth:(CGFloat)maxWidth
                     fontSize:(CGFloat)fontSize;

- (CGFloat)heightWithMaxWidth:(CGFloat)maxWidth
                     fontSize:(CGFloat)fontSize
                         bold:(BOOL)bold;

- (CGFloat)heightWithMaxWidth:(CGFloat)maxWidth
                   attributes:(NSDictionary *)attributes;

/**
 获取字符串宽度

 @param fontSize <#fontSize description#>
 @param bold <#bold description#>
 @return <#return value description#>
 */
- (CGSize)sizeWithFontSize:(CGFloat)fontSize
                      bold:(BOOL)bold;

#pragma mark - NSString转换成HEX（十六进制）
- (unsigned long)stringToHex;
@end
