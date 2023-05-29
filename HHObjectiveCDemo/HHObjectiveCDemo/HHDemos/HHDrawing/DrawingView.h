//
//  DrawingView.h
//  DrawingRound
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MsgChangeCorrectMode @"changeMode"

@interface DrawingView : UIView
// public properties
@property (nonatomic, strong)NSMutableArray *dataSource;
///取消选中批注, 隐藏功能按钮.
@property (nonatomic, copy)void (^hiddenFunctionBtn)(void);
///设置选中批注, 显示功能按钮.
@property (nonatomic, copy)void (^showFunctionBtn)(void);
- (void)cancelEdit;
- (void)deleteMark;
@end
