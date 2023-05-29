//
//  HHPopBackgroundView.m
//  HHBaseViews
//
//  Created by Michael on 2020/6/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHPopBackgroundView.h"
#import "DrawTrianglePath.h"

@implementation HHPopBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CAShapeLayer *shapeLayer = [DrawTrianglePath hh_maskLayerWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height) cornerRadius:6 backgroundColor:[UIColor redColor] arrowWidth:30 arrowHeight:30 arrowPosition:50];
    [self.layer addSublayer:shapeLayer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
