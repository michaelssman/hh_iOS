//
//  Person.h
//  HHRuntime
//
//  Created by Michael on 2020/9/10.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
- (void)runTo:(NSString *)string;
+ (void)runTo_C:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
