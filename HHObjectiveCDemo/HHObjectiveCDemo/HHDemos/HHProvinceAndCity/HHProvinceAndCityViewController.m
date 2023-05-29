//
//  ViewController.m
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHProvinceAndCityViewController.h"
#import "HHAddressView.h"
@interface HHProvinceAndCityViewController ()

@end

@implementation HHProvinceAndCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HHAddressView *v = [[HHAddressView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 500, self.view.frame.size.width, 500)];
    [self.view addSubview:v];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    HHAddressView *v = [[HHAddressView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 500, self.view.frame.size.width, 500)];
//    [v show];
}
@end
