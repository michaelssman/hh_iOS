//
//  TestViewController.m
//  HHCategorysDemo
//
//  Created by Michael on 2020/4/3.
//  Copyright © 2020 michael. All rights reserved.
//

#import "TestViewController.h"
#import <SCM-Swift.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextView *t = [[UITextView alloc]initWithFrame:CGRectMake(0, 500, 200, 100)];
    t.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:t];
    [self addResizeForKeyboardObserver];
    [self addDismissKeyboard];
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(t.frame)- 1, UIScreen.mainScreen.bounds.size.width, 2)];
    lineV.backgroundColor = [UIColor redColor];
    [self.view addSubview:lineV];
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
