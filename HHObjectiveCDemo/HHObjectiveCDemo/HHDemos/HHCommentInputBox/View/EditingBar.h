//
//  EditingBar.h
//  ExcellentArtProject
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCM-Swift.h>
@interface EditingBar : UIToolbar
@property (nonatomic, copy) void (^sendContent)(NSString * content);
@property (nonatomic, strong)HHGrowingTextV *editView;
@property (nonatomic, strong)UIButton *inputViewButton;
- (instancetype)initWithModeSwitchButton;
@end
