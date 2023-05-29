//
//  UIView+Util.m
//  HHCategorysDemo
//
//  Created by Michael on 2020/5/20.
//  Copyright © 2020 michael. All rights reserved.
//

#import "UIView+Util.h"
#import <objc/runtime.h>

@implementation UIView (Util)

///添加阴影
- (void)setShadowWithRadius:(CGFloat)radius
                     shadow:(BOOL)shadow
                    opacity:(CGFloat)opacity
{
    self.layer.cornerRadius = radius;
    if (shadow) {
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = opacity;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 1;
        self.layer.shouldRasterize = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:radius] CGPath];
    }
    self.layer.masksToBounds = !shadow;
}

@end
