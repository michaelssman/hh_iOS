//
//  DateUtil.m
//  HHDate
//
//  Created by FN-116 on 2021/12/13.
//

#import "DateUtil.h"

@implementation DateUtil
- (void)dateDemo {
    //获取当前时间的对象（0时区的时间）
    NSDate *currentDate1 = [NSDate date];
    NSLog(@"%@",currentDate1);
    //以当前时间为基准获得昨天该时候的时间
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
    NSLog(@"%@",yesterday);
    //方法2
    NSDate *yesterday2 = [NSDate dateWithTimeInterval:-24*3600 sinceDate:currentDate1];
    NSLog(@"%@",yesterday2);
    //以2001.1.1时间为基准获得当前 的时间
    //获取从2001.1.1到当前时间的时间间隔（时间很短暂，要珍惜自己的每一分每一秒）
    NSTimeInterval timeinterval = [currentDate1 timeIntervalSinceReferenceDate];
    NSLog(@"%f",timeinterval);
    NSDate *currentDate2 = [NSDate dateWithTimeIntervalSinceReferenceDate:timeinterval];
    NSLog(@"%@",currentDate2);
    //以1970.1.1为时间基准获得当前的时间
    NSTimeInterval timeinterval1 = [currentDate1 timeIntervalSince1970];
    NSDate *currentDate3 = [NSDate dateWithTimeIntervalSince1970:timeinterval1];
    NSLog(@"%@",currentDate3);
    //以当前时间为准创建一个昨天的时间和明天的时间
    NSDate *yesterday3 = [NSDate dateWithTimeIntervalSinceNow:-24*3600];
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    NSLog(@"%@   %@",yesterday3,tomorrow);
    //1:以给定的时间为基准获取两个时间的时间间隔
    NSTimeInterval timeinterval2 = [yesterday3 timeIntervalSinceDate:tomorrow];
    NSLog(@"%f",timeinterval2);
    //2：比较两个时间是否相等
   BOOL orEqual = [yesterday3 isEqual:tomorrow];
    NSLog(@"%d",orEqual);
    //3:获取两个日期中比较早的
    NSDate *earlier = [yesterday3 earlierDate:tomorrow];
    NSLog(@"%@",earlier);
    //4:获取两个日期比较晚的
    NSDate *later = [yesterday3 laterDate:tomorrow];
    NSLog(@"%@",later);
    //5:比较两个日期对象
    NSComparisonResult result = [yesterday3 compare:tomorrow];
    NSLog(@"%ld",result);
    //NSDate转换成NSString
    //创建日期对象
    NSDate *currentDate = [NSDate date];
//1：创建日期转换器对象
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    //2:设置转换的时区
    [formatters setTimeZone:[NSTimeZone defaultTimeZone]];
    //3:指定日期转换的格式
    [formatters setDateFormat:@"yyyy年MMMMD日 E aHH:mm:ss"];
    /*
     日期转换的格式：
     M:表示月份，只显示月的数字
     MM：表示月份，如果月份数字不足两位，剩余位置用0补齐
     MMM：即会显示当月数字，还会在数字的后面加一个“月”字
     MMMM:会以中文显示月份，比如：九月
     d:表示当月第几天
     D：表示该年第几天
     E：表示当前时间是周几
     a:表示上下午
     hh:12小时进制的时间（小时）
     HH:24小时进制的时间（小时）
     mm:表示分钟
     ss:表示秒
     yyyy:表示年
     */
    //4:进行格式转换
    NSString *dateStr = [formatters stringFromDate:currentDate];
    NSLog(@"%@",dateStr);
    //NNString转换成NSDate(将NSString转换成NSDate的时候，转换格式必须跟NSString的格式一一对应，否则转换失败）
    NSString *sourceStr = @"2015年9月22日 上午11点12分35秒";
    //1:创建格式转换器
    NSDateFormatter *formatterD = [[NSDateFormatter alloc]init];
    //2:设置转换的时区
    [formatterD setTimeZone:[NSTimeZone defaultTimeZone]];
    //3:设置日期转换格式
    [formatterD setDateFormat:@"yyyy年M月d日 ahh点mm分ss秒"];
    //4:将NSString转换成NSDate
    NSDate *dates = [formatterD dateFromString:sourceStr];
    NSLog(@"%@",dates);
    //@"2015年09月22日 周二 上午11：27：38"，转换成NSDate类型的数据
    NSString *stri = @"2015年09月22日 周二 上午11:27:38";
    NSDateFormatter *nsFormat = [[NSDateFormatter alloc]init];
    [nsFormat setTimeZone:[NSTimeZone defaultTimeZone]];
    [nsFormat setDateFormat:@"yyyy年MM月d日 E ahh:mm:ss"];
    NSDate *dat = [nsFormat dateFromString:stri];
    NSLog(@"%@",dat);
}

#pragma mark - 获取时间戳
- (NSString *)timestamp {
    NSString *timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];//时间戳
    return timestamp;
}

@end
