//
//  TextFieldViewController.m
//  HHCategorysDemo
//
//  Created by Michael on 2020/6/1.
//  Copyright © 2020 michael. All rights reserved.
//

#import "TextFieldViewController.h"
#import "UITextField+Util.h"
@interface TextFieldViewController ()<UITextFieldDelegate>

@end

@implementation TextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(20, 200, 200, 90)];
    tf.backgroundColor = [UIColor redColor];
    [self.view addSubview:tf];
    tf.text = @"¥fdsfgd";
    [tf becomeFirstResponder];
    tf.delegate = self;
}

///设置光标位置，需要在textField变成响应者之后，不然不管用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setSelectedRange:NSMakeRange(1, 0)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
