//
//  EditingBar.m
//  ExcellentArtProject
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EditingBar.h"

@implementation EditingBar
- (instancetype)initWithModeSwitchButton {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        ///iOS11适配UIToolbar无法点击问题
        [self layoutIfNeeded];

        [self addBorder];
        [self setLayoutWithModeSwitchButton];
    }
    return self;
}
- (void)setLayoutWithModeSwitchButton {
    _inputViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_inputViewButton setTitle:@"发送" forState:UIControlStateNormal];

    [_inputViewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_inputViewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _inputViewButton.enabled = NO;
    
    _editView = [[HHGrowingTextV alloc]initWithPlaceholder:@"写评论"];
    _editView.returnKeyType = UIReturnKeySend;
    _editView.layer.masksToBounds = YES;
    _editView.layer.cornerRadius = 5.0;
    
//    _editView.textColor = [UIColor blueColor];
    [self addSubview:_editView];
    [self addSubview:_inputViewButton];
    for (UIView *view in self.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSDictionary *views = NSDictionaryOfVariableBindings(_inputViewButton, _editView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_editView]-8-[_inputViewButton(55)]-10-|"
                                                                 options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_inputViewButton]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_editView]-5-|" options:0 metrics:nil views:views]];
}

/**
 添加上下的边框
 */
- (void)addBorder
{
    UIView *upperBorder = [UIView new];
    upperBorder.backgroundColor = [UIColor cyanColor];
    upperBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:upperBorder];
    
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = [UIColor cyanColor];
    bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomBorder];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(upperBorder, bottomBorder);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[upperBorder]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upperBorder(0.5)]->=0-[bottomBorder(0.5)]|"
                                                                 options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                 metrics:nil views:views]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
