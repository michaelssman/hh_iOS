//
//  KeyboardWithTextView.m
//  HHKeyboard
//
//  Created by Michael on 2021/2/25.
//  Copyright © 2021 michael. All rights reserved.
//

#import "KeyboardWithTextView.h"

@implementation KeyboardWithTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textField];
        self.kbV = [[HHKeyBoardView alloc]initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, collectionViewH)];
        self.kbV.delegate = self;
        [self addSubview:self.kbV];
    }
    return self;
}

- (UITextField *)textField
{
    if (!_textField) {
        self.textField = [[UITextField alloc]init];
        self.textField.backgroundColor = [UIColor lightGrayColor];
        //设置inputView 防止键盘弹出
        self.textField.inputView = [UIView new];
        self.textField.font = [UIFont systemFontOfSize:24];
        self.textField.textColor = [UIColor blackColor];
        self.textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(0, 130, 300, 50);
}

- (void)didSelectSureButton:(HHKeyBoardView *)keyBoardView
{
    
}
- (void)didSelectDeleteButton:(HHKeyBoardView *)keyBoardView
{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
