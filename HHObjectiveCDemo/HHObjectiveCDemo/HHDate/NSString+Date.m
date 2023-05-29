//
//  NSString+Date.m
//  HHCategorysDemo
//
//  Created by Michael on 2020/4/22.
//  Copyright © 2020 michael. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
- (NSString *)formattedDescription
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    
    NSDate *date = [[NSDate alloc] init];
    if (![self containsString:@"-"] || ![self containsString:@":"]) // 时间戳
    {
        NSTimeInterval timeInterval = [self doubleValue] / 1000;
       date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    else
    {
        date = [dateFormatter dateFromString:self];
    }
    
    NSTimeInterval oneMin = 60;
    NSTimeInterval oneTh = 60 * 60;
    NSTimeInterval oneDay = 60 * 60 * 24;
    
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date];
    
    if (timeInterval < oneDay)
    {
        if (timeInterval < oneMin)
        {
            return @"刚刚";
        }
        else if (timeInterval < oneTh)
        {
            return [NSString stringWithFormat:@"%d分钟前", (int)(timeInterval / oneMin)];
        }
        else
        {
            return [NSString stringWithFormat:@"%d小时前", (int)(timeInterval / oneTh)];
        }
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearStr = [dateFormatter stringFromDate:date];
        NSString *nowYear = [dateFormatter stringFromDate:[NSDate date]];
        
        if ([yearStr isEqualToString:nowYear]) { //同一年
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            return [dateFormatter stringFromDate:date];
        }else{ //以前
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            return [dateFormatter stringFromDate:date];
        }
    }
}
@end
