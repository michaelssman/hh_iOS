//
//  BulletView.h
//  CommentDemo
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MoveStatus) {
    Start,
    Enter,
    End
};
@interface BulletView : UIView
@property (nonatomic, assign)int trajectory; //弹道
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);//弹幕状态回调
//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;
//开始动画
- (void)startAnimation;
//结束动画
- (void)stopAnimation;
@end
