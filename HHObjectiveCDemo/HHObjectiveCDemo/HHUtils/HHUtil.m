//
//  HHUtil.m
//  UtilDemo
//
//  Created by Michael on 2020/6/18.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHUtil.h"

@implementation HHUtil

//保持小数点后decimalDigits位，不足补小数点或者0.
+ (NSString*)returnDecimalDigitsFormatter:(NSNumber *)value decimalDigits:(NSInteger)decimalDigits autoAddZero:(BOOL)autoAddZero {
    //小数位为0 保留整数
    if (decimalDigits == 0) {
        return [NSString stringWithFormat:@"%d",value.intValue];
    }
    //四舍五入 保留小数
    NSDecimalNumberHandler *decimalNumberHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:decimalDigits raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *aDN = [[NSDecimalNumber alloc]initWithDouble:[value doubleValue]];
    NSDecimalNumber *resultDN = [aDN decimalNumberByRoundingAccordingToBehavior:decimalNumberHandler];
    return resultDN.stringValue;
    return [HHUtil reserveDecimalWithNumberString:resultDN.stringValue decimalDigits:decimalDigits autoAddZero:autoAddZero];
}
#pragma mark - 保留小数
+ (NSString *)reserveDecimalWithNumberString:(NSString *)stringNumber
                         decimalDigits:(NSInteger)decimalDigits
                           autoAddZero:(BOOL)autoAddZero {
    //防止传入Number类型
    stringNumber = [NSString stringWithFormat:@"%@",stringNumber];
    //没有小数点
    if([stringNumber rangeOfString:@"."].location == NSNotFound) {
        if (autoAddZero) {
            //自动补0
            NSString *string_comp=[NSString stringWithFormat:@"%@.",stringNumber];
            for (int i = 0; i < decimalDigits; i++) {
                string_comp = [string_comp stringByAppendingString:@"0"];
            }
            return string_comp;
        } else {
            //不需要自动补0
            return stringNumber;
        }
    }
    else
    {
        NSArray *arrays= [stringNumber componentsSeparatedByString:@"."];
        NSString *s_f= [arrays objectAtIndex:0];
        NSString *s_e = [arrays objectAtIndex:1];
        if(s_e.length < decimalDigits) {
            //补0
            if (autoAddZero) {
                while (s_e.length < decimalDigits) {
                    s_e = [s_e stringByAppendingString:@"0"];
                }
            }
        }
        NSString* string_combine=[NSString stringWithFormat:@"%@.%@",s_f,s_e];
        return string_combine;
    }
}

+ (NSString *)transformCountString:(NSString *)countString {
    double countValue = [countString doubleValue];
    if (countValue > 10000 || countValue < -10000) {
        return [NSString stringWithFormat:@"%f万元",countValue / 10000];
    } else {
        return [NSString stringWithFormat:@"%@元",countString];
    }
}


//利用NSDecimalNumber处理精度丢失问题
//也可以去除小数点后没有意义的数字0。例：100.000000就变成100
+ (NSString *)reviseString:(NSString *)str {
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (NSString *)amountAddingCommas:(NSString *)amount {
    NSString *amountString = [NSString stringWithFormat:@"%@",amount];
    //NSNumber格式化转换为NSString添加千位分隔符
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:[NSDecimalNumber decimalNumberWithString:amountString]];
    return numberString;
}

+ (NSInteger)daysWithMonthInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld",year,month];
    NSDate *date = [formatter dateFromString:dateStr];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
    
}


#pragma mark 设置阴影方法
+ (void)dropShadowWithView:(UIView *)view
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity {
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, view.bounds);
    view.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = offset;
    view.layer.shadowRadius = radius;
    view.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    view.clipsToBounds = NO;
}

#pragma mark - 使用CAGradientLayer实现颜色渐变
/**
 注：
 1. `gradientLayer.frame`要写在`[self.contentView.layer addSublayer:gradientLayer];`的后面。否则frame不对。
 2. 建议使用insertSubView和insertSublayer来替代addSubview与addSublayer
    目的：
    1. 更好的控制试图的层级关系
    2. 减少遇到一些特殊情况出现bug的几率
 3. 边框颜色渐变，底层加一个View，底层View设置渐变色。底层VIew的cornerRadius要设置在最后。
 */
+ (void)setupGradient:(UIView *)view {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.8].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.position = CGPointMake(0, 0);
    // gradientLayer.locations = @[@(0.25),@(0.75)];
        // [self.contentView.layer addSublayer:gradientLayer];
    [view.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.frame = view.bounds;
}
#pragma mark - view设置圆角
+ (void)setupCorner:(UIView *)view {
    /**
     - UIBezierPath设置路径
     - CAShapeLayer的路径是上面的UIBezierPath
     - view的layer的mask是CAShapeLayer
     */
    CGRect rect = view.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    view.layer.masksToBounds = YES;
    view.layer.mask = maskLayer;
}
+ (void)setCornerWithLeftTopCorner:(CGFloat)leftTop
                    rightTopCorner:(CGFloat)rigtTop
                  bottomLeftCorner:(CGFloat)bottemLeft
                 bottomRightCorner:(CGFloat)bottemRight
                              view:(UIView *)view
                             frame:(CGRect)frame {
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    [maskPath moveToPoint:CGPointMake(bottemRight, height)]; //左下角
    [maskPath addLineToPoint:CGPointMake(width - bottemRight, height)];//下边直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(width, height- bottemRight) controlPoint:CGPointMake(width, height)]; //右下角的圆弧
    [maskPath addLineToPoint:CGPointMake(width, rigtTop)]; //右边直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(width - rigtTop, 0) controlPoint:CGPointMake(width, 0)]; //右上角圆弧
    [maskPath addLineToPoint:CGPointMake(leftTop, 0)]; //顶部直线
    
    [maskPath addQuadCurveToPoint:CGPointMake(0, leftTop) controlPoint:CGPointMake(0, 0)]; //左上角圆弧
    [maskPath addLineToPoint:CGPointMake(0, height - bottemLeft)]; //左边直线
    [maskPath addQuadCurveToPoint:CGPointMake(bottemLeft, height) controlPoint:CGPointMake(0, height)]; //左下角圆弧

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - 播放时长
+ (NSString *)formatDuration:(NSInteger)seconds {
    if (seconds < 60) {
        return [NSString stringWithFormat:@"%ld秒",(long)seconds];
    }
    else if (seconds < 60 * 60) {
        return [NSString stringWithFormat:@"%ld分%ld秒",seconds / 60, seconds % 60];
    } else {
        return [NSString stringWithFormat:@"%ld时%ld分%ld秒",seconds / 60 / 60,  seconds / 60 % 60, seconds % 60];
    }
}

@end
