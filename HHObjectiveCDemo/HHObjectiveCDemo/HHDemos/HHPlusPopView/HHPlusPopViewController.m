//
//  ViewController.m
//  HHPlusPopViewDemo
//
//  Created by Michael on 2018/8/3.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHPlusPopViewController.h"
#import "HHPlusPopView.h"
@interface HHPlusPopViewController ()

@end

@implementation HHPlusPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.center = self.view.center;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click {
   HHPlusPopView *v = [HHPlusPopView showWithImages:@[@"text",@"image",@"camera",@"image",@"camera",@"image",@"camera",@"image",@"camera",@"image",@"camera",@"image",@"camera"] titles:@[@"文字", @"图片", @"拍摄", @"图片", @"拍摄", @"图片", @"拍摄", @"图片", @"拍摄", @"图片", @"拍摄", @"图片", @"拍摄"] selectBlock:^(NSInteger index) {
        NSLog(@"index:%zi", index);
    }];
    [v show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
