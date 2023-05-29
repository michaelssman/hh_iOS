//
//  UIView+Util.h
//  HHCategorysDemo
//
//  Created by Michael on 2020/5/20.
//  Copyright © 2020 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Util)
///添加阴影
- (void)setShadowWithRadius:(CGFloat)radius
                     shadow:(BOOL)shadow
                    opacity:(CGFloat)opacity;
@end

NS_ASSUME_NONNULL_END
