//
//  UIColor+Util.h
//  HHCategorysDemo
//
//  Created by Michael on 2020/3/30.
//  Copyright © 2020 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

/// 适配暗黑模式颜色   传入的UIColor对象
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor
                       darkColor:(UIColor *)darkColor;

/// 适配暗黑模式颜色   颜色传入的是16进制字符串
/// @param lightColorString 普通模式颜色
/// @param darkColorString 暗黑模式颜色
+ (UIColor *)colorWithLightColorString:(NSString *)lightColorString
                       darkColorString:(NSString *)darkColorString;



+ (UIColor *)themeColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)lightBackgroundColor;
+ (UIColor *)darkContentTextColor;
+ (UIColor *)lightContentTextColor;
+ (UIColor *)borderColor;
+ (UIColor *)specialColor;

+ (UIColor *)randomColor;
@end

NS_ASSUME_NONNULL_END
