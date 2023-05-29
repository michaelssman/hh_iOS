//
//  HHKeyBoardViewController.m
//  HHKeyboard
//
//  Created by Michael on 2020/1/7.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHKeyBoardViewController.h"
#import "KeyboardWithTextView.h"
@interface HHKeyBoardViewController ()

@end

@implementation HHKeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    KeyboardWithTextView *kbV = [[KeyboardWithTextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:kbV];
}


@end
