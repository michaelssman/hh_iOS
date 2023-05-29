//
//  PageJumpUtil.h
//  PageJumpDemo
//
//  Created by Michael on 2021/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageJumpUtil : NSObject
+ (void)pushViewController:(NSString *)vcString
                 propertys:(NSDictionary *)propertys;
@end

NS_ASSUME_NONNULL_END
