//
//  TestViewController.m
//  GestureRemoveController
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "SlideCloseTestViewController.h"
#import "UIView+SlideClose.h"
@interface SlideCloseTestViewController ()

@end

@implementation SlideCloseTestViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addGR];
    self.view.gestureResponseDirection = GestureResponseAll;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
