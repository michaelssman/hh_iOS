//
//  HHTextField.m
//  HHBaseViews
//
//  Created by Michael on 2020/7/1.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHTextField.h"

@implementation HHTextField
- (instancetype)init
{
    self = [super init];
    if (self) {
        //1、设置代理
        self.delegate = self;
//        [self addAction];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //1、设置代理
        self.delegate = self;
//        [self addAction];
    }
    return self;
}


#pragma mark - delegate
/// <#Description#>
/// @param textField 输入框，打印textField.text显示的内容是输入字符之前的内容。新输入的字符还没有存储在textField.text中。
/// @param range 表示新插入的字符的位置，即光标所在的位置。
/// @param string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //根据string判断是否是删除
    if (string.length == 0) {
        //删除
        
        //全部删除，删除最后一个字符时range为{0, 1}
        if (range.location == 0 && range.length == 1) {
            //
        }
    }
    
    
    UITextRange *selectedRange = textField.markedTextRange;
    if (selectedRange == nil) {
        /*
         高亮状态的字符串为空，也就是输入数字字母的情况。
         这是一般的情况。
         */
    } else {
        //有输入的拼音 还没有选定的情况。
        NSString *newText = [textField textInRange:selectedRange];
        if (newText.length > 0) {
            if ([self judgeInputIsChinese:string]) {
                //
                //获取搜索的内容
                NSMutableString *searchString = [NSMutableString stringWithString:textField.text];
                if ([string isEqualToString:@""]) {
                    //这是删除字符
                    [searchString replaceCharactersInRange:range withString:string];
                } else {
                    //插入字符
                    [searchString replaceCharactersInRange:NSMakeRange(range.location, newText.length) withString:@""];
                    [searchString insertString:string atIndex:range.location];
                }
            }
        }
    }
    
    
    
//    NSLog(@"===%@",string);
    NSLog(@"===%@",NSStringFromRange(range));
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField
{
    UITextRange *rang = textField.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
    }
}

#pragma mark - 判断输入字符是否为汉字
- (BOOL)judgeInputIsChinese:(NSString *)textStr{
    
    NSString *regex = @"(^[\u4e00-\u9fa5]+$)";
    //谓词
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:textStr];
    
    return isMatch;
    
}

#pragma mark - 输入内容
- (void)addAction
{
    //输入框内容改变
    [self addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void)editingChanged:(UITextField *)sender
{
    UITextRange *rang = sender.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
    }
    NSLog(@"---%@",sender.text);
}

// 设置光标位置   设置光标位置要在becomeFirstResponder之后，变成第一响应者之后设置光标位置才管用。
- (void)setSelectedP
{
    NSRange range = NSMakeRange(self.text.length - 1, 0);
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument] offset:range.location];
    UITextPosition *end = [self  positionFromPosition:start offset:range.length];
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
