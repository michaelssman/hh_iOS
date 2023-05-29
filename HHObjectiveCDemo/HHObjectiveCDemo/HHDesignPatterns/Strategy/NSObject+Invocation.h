//
//  NSObject+Invocation.h
//  HHDesignPatterns
//
//  Created by Michael on 2020/8/25.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Invocation)
- (id)invocationWithSelector:(SEL)selector;
- (id)invocationWithSelector:(SEL)selector withObjects:(NSArray* __nullable)objects;
@end

NS_ASSUME_NONNULL_END
