//
//  DrawingViewController.m
//  Drawing
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DrawingViewController.h"
#import "PinggaiView.h"
@interface DrawingViewController ()
@property (nonatomic, strong)PinggaiView *PinggaiV;
@end

@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PinggaiV = [[PinggaiView alloc]initWithFrame:self.view.bounds];
    self.PinggaiV.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:self.PinggaiV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
