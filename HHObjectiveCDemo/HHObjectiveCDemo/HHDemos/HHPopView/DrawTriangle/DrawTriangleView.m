//
//  DrawTriangleView.m
//  HHDrawDemo
//
//  Created by Michael on 2019/12/5.
//  Copyright © 2019 michael. All rights reserved.
//

#import "DrawTriangleView.h"
#import "DrawTrianglePath.h"

@implementation DrawTriangleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CAShapeLayer *shapeLayer = [DrawTrianglePath hh_maskLayerWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height) cornerRadius:6 backgroundColor:[UIColor redColor] arrowWidth:30 arrowHeight:30 arrowPosition:50];
    [self.layer addSublayer:shapeLayer];

}


@end
