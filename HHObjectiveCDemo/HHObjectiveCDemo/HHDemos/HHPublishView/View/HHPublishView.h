//
//  HHPublishView.h
//  HHPublishDemo
//
//  Created by Michael on 2018/8/6.
//  Copyright © 2018年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCM-Swift.h>
#define kToolBarHeight  50
#define kSelectPicHeight  80

@interface HHPublishView : UIScrollView
@property (nonatomic, strong)HHPlaceHolderTV *textView;
@property (nonatomic, strong)UIImageView *imgV;
@property (nonatomic, assign)CGFloat imgHeight;
- (void)reloadDataWithImage:(UIImage *)image;
@property (nonatomic, copy)void (^addSPV)(void);
@property (nonatomic, assign)CGFloat keyboardHeight;

/// 是否是编辑引起的滑动，是的话就不回收键盘。
@property (nonatomic, assign)BOOL isEditingScroll;

/**
 初始时给定初始内容 需要设置高度
 */
- (void)setUpFrame;
@end
