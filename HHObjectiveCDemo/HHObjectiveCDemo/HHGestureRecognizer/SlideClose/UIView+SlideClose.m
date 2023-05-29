//
//  UIView+SlideClose.m
//  GestureRemoveController
//
//  Created by FN-116 on 2021/11/5.
//  Copyright © 2021 michael. All rights reserved.
//

#import "UIView+SlideClose.h"
#import <objc/runtime.h>
#import "UIView+Util.h"

@implementation UIView (SlideClose)

#pragma mark - setter getter
static char gestureResponseDirectionKey;
- (void)setGestureResponseDirection:(GestureResponseDirection)gestureResponseDirection {
    objc_setAssociatedObject(self, &gestureResponseDirectionKey, @(gestureResponseDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (GestureResponseDirection)gestureResponseDirection {
    return [objc_getAssociatedObject(self, &gestureResponseDirectionKey) integerValue];
}
static char operationTypeKey;
- (void)setOperationType:(OperationType)operationType {
    objc_setAssociatedObject(self, &operationTypeKey, @(operationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (OperationType)operationType {
    return [objc_getAssociatedObject(self, &operationTypeKey) integerValue];
}

#pragma mark -
- (void)addGR {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    [self addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    self.operationType = OperationTypeNone;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
    if (self.gestureResponseDirection == GestureResponseAll) {
        //可以上下左右滑动
        switch (self.operationType) {
            case OperationTypeNone:
                if (translation.x < 0 || translation.y < 0) {
                    return NO;  //禁掉往左边滑动效果!
                } else {
                    return YES;
                }
            case OperationTypeX:
                return YES;
            case OperationTypeY:
                return YES;
        }
    } else if (self.gestureResponseDirection == GestureResponseVertical) {
        //只能上下滑出
        if (translation.y > 0 && (fabs(translation.y) > fabs(translation.x))) {
            return YES;
        } else {
            return NO;
        }
    } else if (self.gestureResponseDirection == GestureResponseHorizontal) {
        //只能左滑滑出
        if (translation.x > 0 && (fabs(translation.x) > fabs(translation.y))) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}
#pragma mark (四)  拖拽
- (void)dragging:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self];

    /*
     locationInView:获取到的是手指点击屏幕实时的坐标点；
     
     translationInView：获取到的是手指移动后，在相对坐标中的偏移量
     */
    
    //2.拿到在x方向上移动的距离
    switch (self.operationType) {
        case OperationTypeNone:
            if (translation.x < 0 && translation.y < 0) return;  //禁掉往左边滑动效果!
        case OperationTypeX:
            if (translation.x < 0) return;  //禁掉往左边滑动效果!
        case OperationTypeY:
            if (translation.y < 0) return;  //禁掉往左边滑动效果!
        default:
            break;
    }
    
    
    
    switch (sender.state) {
        case UIGestureRecognizerStateChanged: {
            //判断是调节音量, 亮度, 进度.
            if (self.operationType == OperationTypeNone) {
                if (translation.x > translation.y) {
                    self.operationType = OperationTypeX;
                    [self changeFrameWithOffset:translation.x];
                } else {
                    self.operationType = OperationTypeY;
                    [self changeFrameWithOffset:translation.y];
                }
            }
            else {
                switch (self.operationType) {
                    case OperationTypeX: {
                        [self changeFrameWithOffset:translation.x];
                        break;
                    }
                    case OperationTypeY: {
                        [self changeFrameWithOffset:translation.y];
                        break;
                    }
                    case OperationTypeNone: {
                        break;
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self endState];
            self.operationType = OperationTypeNone;
            break;
        }
        default:
            break;
    }
}
- (void)changeFrameWithOffset:(CGFloat)offset {
    // 移动view
    if (self.operationType == OperationTypeX) {
        self.transform = CGAffineTransformMakeTranslation(offset, 0);
    } else {
        self.transform = CGAffineTransformMakeTranslation(0, offset);
    }
}

- (void)endState {
    switch (self.operationType) {
        case OperationTypeX: {
            // 决定pop还是还原
            CGFloat x = self.frame.origin.x;
            if (x >= 55) {
                [UIView animateWithDuration:0.25 animations:^{
                    //3.1如果宽度超过屏幕一半宽度就让控制器先挪到最右边去(或者最下边)
                    self.transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
                } completion:^(BOOL finished) {
                    [self dismissViewController];
                }];
                
            }
            else {  //3.3如果没超过屏幕一半就回到原来位置
                [UIView animateWithDuration:0.25 animations:^{
                    self.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
        case OperationTypeY: {
            // 决定pop还是还原
            CGFloat y = self.frame.origin.y;
            if (y >= 55) {
                [UIView animateWithDuration:0.25 animations:^{
                    //3.1如果宽度超过屏幕一半宽度就让控制器先挪到最右边去(或者最下边)
                    self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
                } completion:^(BOOL finished) {
                    [self dismissViewController];
                }];
                
            } else {  //3.3如果没超过屏幕一半就回到原来位置
                [UIView animateWithDuration:0.25 animations:^{
                    self.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
        case OperationTypeNone:
            break;
        default:
            break;
    }
}

#pragma mark - 移除不需要的控件和图片
- (void)dismissViewController {
    [self.viewController.navigationController dismissViewControllerAnimated:NO completion:nil];   //销毁控制器
//    self.transform = CGAffineTransformIdentity; //让导航控制器从右边回到原来位置
}
@end
