//
//  BottomBarViewController.h
//  ExcellentArtProject
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingBar.h"
@interface BottomBarViewController : UIViewController
@property (nonatomic, strong) EditingBar *editingBar;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;

- (instancetype)initWithModeSwitchButton;
- (void)sendContent;

/**
 更新输入框的高度
 */
- (void)updateInputBarHeight;
- (void)hideEmojiPageView;
@end
