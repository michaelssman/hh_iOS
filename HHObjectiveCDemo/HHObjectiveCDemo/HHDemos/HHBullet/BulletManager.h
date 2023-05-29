//
//  BulletManager.h
//  CommentDemo
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
@interface BulletManager : NSObject

@property (nonatomic, copy) void (^generateViewBlock)(BulletView *view);

//弹幕开始执行
- (void)start;

//弹幕停止执行
- (void)stop;
@end
