//
//  HHUtilViewController.m
//  UtilDemo
//
//  Created by Michael on 2020/6/12.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHUtilViewController.h"
#import "HHUtil.h"
@interface HHUtilViewController ()

@end

@implementation HHUtilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //金额不足万的时候，应该以元为单位；金额超过万的时候，以万为单位
    NSString *countString = @"10002";
    NSLog(@"%@",[HHUtil transformCountString:countString]);
    
    NSLog(@"%@",[HHUtil returnDecimalDigitsFormatter:countString decimalDigits:2 autoAddZero:YES]);

    double countDouble = [countString doubleValue];//10001.885
    float countFloat = [countString floatValue];//10001.8848
    CGFloat countFloat1 = [countString floatValue];//10001.884765625
    //所以用double.
    
    NSLog(@"%ld",[HHUtil daysWithMonthInThisYear:2020 withMonth:2]);
    NSLog(@"hhh:%@",[HHUtil formatDuration:36]);
    NSLog(@"hhh:%@",[HHUtil formatDuration:89]);
    NSLog(@"hhh:%@",[HHUtil formatDuration:(60*60*4+60*35+46)]);
}

@end
