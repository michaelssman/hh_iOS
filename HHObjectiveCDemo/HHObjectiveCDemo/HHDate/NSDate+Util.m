//
//  NSDate+Util.m
//  yyt-teacher
//
//  Created by ebsinori on 16/7/19.
//  Copyright © 2016年 ebsinori. All rights reserved.
//

#import "NSDate+Util.h"

/**
 HH 24小时    hh 12小时
 */
@implementation NSDate (Util)

#pragma mark  根据时间戳 转换日期格式
+ (NSString *)dateWithTimeInterval0:(NSTimeInterval)secs {
    //判断秒或毫秒 10位或13位
    if ((1 < secs / pow(10, 12)) && (secs / pow(10, 12) < 10)) {
        secs /= 1000;
    }
    
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatters stringFromDate:[NSDate dateWithTimeIntervalSince1970:secs]];
}

+ (NSString *)dateWithTimeInterval:(NSTimeInterval)secs {
    //判断秒或毫秒 10位或13位
    if ((1 < secs / pow(10, 12)) && (secs / pow(10, 12) < 10)) {
        secs /= 1000;
    }
    
    return [[NSDate dateWithTimeIntervalSince1970:secs] formattedDescription];
}

- (NSString *)formattedDescription
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) { //1分钟内
        return @"刚刚";
    } else if (timeInterval < 3600) { //1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)timeInterval / 60];
    } else if(timeInterval <= 3600 * 24){ //两天内
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([theDay isEqualToString:currentDay]) { //当天
            return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:self]];
        }else{ //昨天
            return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:self]];
        }
    } else {
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearStr = [dateFormatter stringFromDate:self];
        NSString *nowYear = [dateFormatter stringFromDate:[NSDate date]];
        
        if ([yearStr isEqualToString:nowYear]) { //同一年
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            return [dateFormatter stringFromDate:self];
        }else{ //以前
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            return [dateFormatter stringFromDate:self];
        }
    }
}

- (NSString *)conversationTimeDescription {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval <= 3600 * 24){ //两天内
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([theDay isEqualToString:currentDay]) { //当天
            return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
        }else{ //昨天
            return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:self]];
        }
    } else {
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearStr = [dateFormatter stringFromDate:self];
        NSString *nowYear = [dateFormatter stringFromDate:[NSDate date]];
        
        if ([yearStr isEqualToString:nowYear]) { //同一年
            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            return [dateFormatter stringFromDate:self];
        }else{ //以前
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            return [dateFormatter stringFromDate:self];
        }
    }
}
@end
