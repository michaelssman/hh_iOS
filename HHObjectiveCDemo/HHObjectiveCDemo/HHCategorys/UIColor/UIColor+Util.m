//
//  UIColor+Util.m
//  HHCategorysDemo
//
//  Created by Michael on 2020/3/30.
//  Copyright © 2020 michael. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

#pragma mark - Hex
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

#pragma mark - HexString
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger) length
{
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    
    if ([colorString hasPrefix:@"0X"]){
        colorString = [colorString substringFromIndex:2];
        return [UIColor colorWithHexString:colorString];
    }
    
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
        {
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
        }
            break;
            
        case 4: // #ARGB
        {
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
        }
            break;
            
        case 6: // #RRGGBB
        {
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
        }
            break;
            
        case 8: // #AARRGGBB
        {
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
        }
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


/// 适配暗黑模式颜色   传入的UIColor对象
/// @param lightColor 普通模式颜色
/// @param darkColor 暗黑模式颜色
+ (UIColor *)colorWithLightColor:(UIColor *)lightColor
                       darkColor:(UIColor *)darkColor
{
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return lightColor;
            } else {
                return darkColor;
            }
        }];
    } else {
        return lightColor ? lightColor : (darkColor ? darkColor : [UIColor clearColor]);
    }
}

/// 适配暗黑模式颜色   颜色传入的是16进制字符串
/// @param lightColorString 普通模式颜色
/// @param darkColorString 暗黑模式颜色
+ (UIColor *)colorWithLightColorString:(NSString *)lightColorString
                       darkColorString:(NSString *)darkColorString
{
    return [UIColor colorWithLightColor:[UIColor colorWithHexString:lightColorString] darkColor:[UIColor colorWithHexString:darkColorString]];
}


#pragma mark - theme colors
+ (UIColor *)themeColor
{
    return [UIColor colorWithHex:0x38bdfe];
}

+ (UIColor *)backgroundColor {
    return [UIColor colorWithHex:0xebebeb];
}

+ (UIColor *)lightBackgroundColor {
    return [UIColor colorWithHex:0xf9f9f9];
}

+ (UIColor *)darkContentTextColor {
    return [UIColor colorWithHex:0x404548];
}

+ (UIColor *)lightContentTextColor {
    return [UIColor colorWithHex:0x918f8f];
}

+ (UIColor *)borderColor {
    return [UIColor colorWithHex:0xc7c7cc];
}

+ (UIColor *)specialColor {
    return [UIColor colorWithHex:0xe65ab5];
}

+ (UIColor *)randomColor {
    CGFloat red = arc4random() % 256 / 255.0;
    CGFloat green = arc4random() % 256 / 255.0;
    CGFloat blue = arc4random() % 256 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
