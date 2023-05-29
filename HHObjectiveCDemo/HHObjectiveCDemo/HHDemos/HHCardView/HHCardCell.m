//
//  HHCardCell.m
//  CardDemo
//
//  Created by Michael on 2020/9/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHCardCell.h"

@interface HHCardCell()
@property (nonatomic, assign)CGPoint originalCenter;
@property (nonatomic, assign)CGFloat currentAngle;
@property (nonatomic, assign)BOOL isLeft;
@end

@implementation HHCardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
        //添加滑动手势
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];

        [self configLayer];
        
    }
    return self;
}

- (void)configLayer {
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
}

#pragma mark - 滑动
- (void)panAction:(UIPanGestureRecognizer *)panGest {
    if (panGest.state == UIGestureRecognizerStateChanged) {
        CGPoint movePoint = [panGest translationInView:self];
        _isLeft = (movePoint.x < 0);
        NSLog(@"movePoint: %f",movePoint.x);
        
        self.center = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);
        
        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 4.0;
        _currentAngle = angle;
        
        self.transform = CGAffineTransformMakeRotation(angle);
        
        [panGest setTranslation:CGPointZero inView:self];
        
    } else if (panGest.state == UIGestureRecognizerStateEnded) {
        
        CGPoint vel = [panGest velocityInView:self];
        if (vel.x > 800 || vel.x < - 800) {
            [self remove];
            return ;
        }
        if (self.frame.origin.x + self.frame.size.width > 150 && self.frame.origin.x < self.frame.size.width - 150) {
            [UIView animateWithDuration:0.5 animations:^{
                self.center = self.originalCenter;
                self.transform = CGAffineTransformMakeRotation(0);
            }];
        } else {
            [self remove];
        }
    }
}

- (void)remove {
    [UIView animateWithDuration:0.3 animations:^{
        // right
        if (!self.isLeft) {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + self.currentAngle * self.frame.size.height);
        }
        // left
        else {
            self.center = CGPointMake(- 1000, self.center.y - self.currentAngle * self.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(cardCellViewDidRemoveFromSuperView:)]) {
                [self.delegate cardCellViewDidRemoveFromSuperView:self];
            }
        }
    }];
    
}

- (void)removeWithLeft:(BOOL)left {
    [UIView animateWithDuration:0.5 animations:^{
        // right
        if (!left) {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + self.currentAngle * self.frame.size.height + (self.currentAngle == 0 ? 100 : 0));
        } else { // left
            self.center = CGPointMake(- 1000, self.center.y - self.currentAngle * self.frame.size.height + (self.currentAngle == 0 ? 100 : 0));
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(cardCellViewDidRemoveFromSuperView:)]) {
                [self.delegate cardCellViewDidRemoveFromSuperView:self];
            }
        }
    }];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
