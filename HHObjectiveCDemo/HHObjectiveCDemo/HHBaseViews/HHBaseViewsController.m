//
//  HHBaseViewsController.m
//  HHBaseViews
//
//  Created by Michael on 2018/12/11.
//  Copyright © 2018 michael. All rights reserved.
//

#import "HHBaseViewsController.h"
#import "HHTextField.h"

@interface HHBaseViewsController ()
@end

@implementation HHBaseViewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //允许输入两位小数
    HHTextField *tf = [[HHTextField alloc]init];
    tf.frame = CGRectMake(50, 100, 300, 77);
    tf.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tf];
    
}

@end
