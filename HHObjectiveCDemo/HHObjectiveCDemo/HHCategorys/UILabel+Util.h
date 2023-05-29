//
//  UILabel+Util.h
//  HHObjectiveCDemo
//
//  Created by Michael on 2018/2/26.
//  Copyright © 2018年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Util)

#pragma mark - ShowDifferentStyles
/**
 label中特殊字符显示不同的样式

 @param text 特殊字符
 @param color 特殊字符的字体颜色
 @param font 特殊字符的字体大小
 */
-(void)setSpecialText:(NSString *)text
                color:(UIColor *)color
                 font:(UIFont *)font;

-(void)setSpecialTextWithRange:(NSRange)range
                         color:(UIColor *)color
                          font:(UIFont *)font;

/// 设置字间距
/// @param space 字间距
- (void)setWordSpace:(float)space;

/// 设置行间距 字间距
/// @param lineSpace 行间距
/// @param wordSpace 字间距
- (void)setLineSpace:(float)lineSpace
           wordSpace:(float)wordSpace;

/// 设置字体
- (void)setFontName:(NSString *)fontName
               size:(CGFloat)size;

#pragma mark - TextAttachment添加附件
- (void)setTextAttachment:(UILabel *)label;

@end
