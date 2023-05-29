//
//  HHUtil.h
//  UtilDemo
//
//  Created by Michael on 2020/6/18.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHUtil : NSObject

/// 保持小数位，不足可以补小数点或者0.
/// @param value <#stringNumber description#>
/// @param decimalDigits 保留的小数位数
/// @param autoAddZero 是否需要自动补0
+ (NSString*)returnDecimalDigitsFormatter:(NSNumber *)value
                            decimalDigits:(NSInteger)decimalDigits
                              autoAddZero:(BOOL)autoAddZero;

/// 保留小数
+ (NSString *)reserveDecimalWithNumberString:(NSString *)stringNumber
                               decimalDigits:(NSInteger)decimalDigits
                                 autoAddZero:(BOOL)autoAddZero;

//超过万的数，显示为xxxx万
+ (NSString *)transformCountString:(NSString *)countString;

//NSNumber格式化转换为NSString添加千位分隔符
+ (NSString *)amountAddingCommas:(NSString *)amount;

///某年某月有多少日
+ (NSInteger)daysWithMonthInThisYear:(NSInteger)year withMonth:(NSInteger)month;

#pragma mark - 加阴影
- (void)dropShadowWithView:(UIView *)view
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                     color:(UIColor *)color
                   opacity:(CGFloat)opacity;

#pragma mark - 播放时长
+ (NSString *)formatDuration:(NSInteger)seconds;
@end

NS_ASSUME_NONNULL_END
