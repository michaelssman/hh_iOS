//
//  UILabel+Util.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2018/2/26.
//  Copyright © 2018年 sunny. All rights reserved.
//

#import "UILabel+Util.h"

@implementation UILabel (Util)

#pragma mark - ShowDifferentStyles
- (void)setSpecialText:(NSString *)text
                 color:(UIColor *)color
                  font:(UIFont *)font
{
    //传数字需要转换
    text = [NSString stringWithFormat:@"%@",text];
    //如果不包含指定的字符串，直接return
    if (![self.text containsString:text]) {
        return;
    }
    
    NSRange range = [self.text rangeOfString:text];
    
    [self setSpecialTextWithRange:range color:color font:font];
}

-(void)setSpecialTextWithRange:(NSRange)range
                         color:(UIColor *)color
                          font:(UIFont *)font
{
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //设置字号
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    //    //设置中划线
    //    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 12)];
    
    self.attributedText = attributedString;
}

#pragma mark - 字间距
- (void)setWordSpace:(float)space
{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}
- (void)setLineSpace:(float)lineSpace
           wordSpace:(float)wordSpace
{
    NSString *labelText = self.text;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

- (void)setFontName:(NSString *)fontName
               size:(CGFloat)size
{
    NSString *labelText = self.text;
    
    //如果为nil 则不处理
    if (!labelText) {
        return;
    }
    
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC" size: 16]} range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    //下面这行加上的话， 在label多行显示的时候，自适应的尺寸会有问题。
    //    [self sizeToFit];
}

#pragma mark - TextAttachment添加附件
- (void)setTextAttachment:(UILabel *)label
{
    //创建一个小标签的Label
    CGFloat tagLabW = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].width;
    CGFloat tagH = 16;
    CGFloat space = 10;
    label.frame = CGRectMake(0, 0, tagLabW, tagH);
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tagLabW + space, tagH)];
    [bgView addSubview:label];
    //调用方法，转化成Image
    UIImage *image = [self imageWithUIView:bgView];
    
    //创建Image的富文本格式
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    //self.font.descender
    attach.bounds = CGRectMake(0, self.font.descender, tagLabW + space, tagH);
    attach.image = image;
    //添加到富文本对象里
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    //创建  NSMutableAttributedString 富文本对象
    NSMutableAttributedString *maTitleString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [maTitleString insertAttributedString:imageStr atIndex:0];//加入文字前面
    //[maTitleString appendAttributedString:imageStr];//加入文字后面
    //[maTitleString insertAttributedString:imageStr atIndex:4];//加入文字第4的位置

    self.attributedText = maTitleString;
}

//view转成image
- (UIImage*) imageWithUIView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
//    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

@end
