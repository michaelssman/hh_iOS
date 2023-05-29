//
//  HHRouter+Utils.h
//  HHRouter
//
//  Created by michael on 2021/5/18.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHRouter.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HHRouter (Utils)

- (UIViewController *)hhRouter_newsViewControllerWithParams:(NSDictionary *)dict
                                                  callBlock:(void (^)(NSString *str))callBlock;

@end

NS_ASSUME_NONNULL_END
