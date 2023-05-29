//
//  UIView+SlideClose.h
//  GestureRemoveController
//
//  Created by FN-116 on 2021/11/5.
//  Copyright © 2021 michael. All rights reserved.
//  给view添加滑动手势

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GestureResponseDirection) {
    GestureResponseNone = 0,
    GestureResponseHorizontal,
    GestureResponseVertical,
    GestureResponseAll
};
typedef NS_ENUM(NSInteger, OperationType) {
    OperationTypeNone = 0,///开始的时候 默认的无状态
    OperationTypeX,
    OperationTypeY
};
NS_ASSUME_NONNULL_BEGIN
@interface UIView (SlideClose)<UIGestureRecognizerDelegate>
@property (nonatomic, assign)GestureResponseDirection gestureResponseDirection;
@property (nonatomic, assign)OperationType operationType;
- (void)addGR;
@end

NS_ASSUME_NONNULL_END
