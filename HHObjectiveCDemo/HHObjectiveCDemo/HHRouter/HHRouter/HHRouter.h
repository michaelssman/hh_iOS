//
//  HHRouter.h
//  HHRouter
//
//  Created by Michael on 2020/7/14.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// target-action 两个参数来确定target和action NSDictionary para
@interface HHRouter : NSObject

+ (instancetype)sharedInstance;

//使用openUrl调用 urlStr可以带参数
//要使用http:// 因为切割的时候用的http裁剪的
// http://Index/home?name=zhangsan&pws=123 就是调用OCTarget_Index类的action_home方法。
- (id)openUrl:(NSString *)urlStr;

// 返回值id
// 外部调用，通过target和action来唯一确认一个类里面的方法
- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
              param:(NSDictionary *)para;


//还可以写回调

@end

NS_ASSUME_NONNULL_END
