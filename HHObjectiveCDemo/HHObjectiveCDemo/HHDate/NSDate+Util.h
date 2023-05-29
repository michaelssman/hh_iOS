//
//  NSDate+Util.h
//  yyt-teacher
//
//  Created by ebsinori on 16/7/19.
//  Copyright © 2016年 ebsinori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

+ (NSString *)dateWithTimeInterval0:(NSTimeInterval)secs;

/**
 根据时间戳 转换日期格式

 @param secs 后台返回的时间戳
 @return 日期
 */
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)secs;

- (NSString *)formattedDescription;

- (NSString *)conversationTimeDescription;
@end
