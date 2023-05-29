//
//  NSString+Adaptive.m
//  HHObjectiveCDemo
//
//  Created by ebsinori on 16/7/27.
//  Copyright © 2016年 ebsinori. All rights reserved.
//

#import "NSString+Adaptive.h"

@implementation NSString (Adaptive)

- (CGFloat)heightWithMaxWidth:(CGFloat)maxWidth fontSize:(CGFloat)fontSize {
   return [self heightWithMaxWidth:maxWidth fontSize:fontSize bold:NO];
}

- (CGFloat)heightWithMaxWidth:(CGFloat)maxWidth fontSize:(CGFloat)fontSize bold:(BOOL)bold {
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [self heightWithMaxWidth:maxWidth attributes:attributes];
}

- (CGFloat)heightWithMaxWidth:(CGFloat)maxWidth
                   attributes:(NSDictionary *)attributes
{
    return [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size.height;
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize bold:(BOOL)bold {
    if (bold) {
        return [self sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}];
    } else {
        return [self sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
    }
}

#pragma mark - NSString转换成HEX（十六进制）
- (unsigned long)stringToHex {
    NSString *str = self;
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    unsigned long red = strtoul([str UTF8String],0,16);
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    unsigned long red1 = strtoul([self UTF8String],0,0);
    NSLog(@"转换完的数字为：%lx",red);
    return red;
}

@end
