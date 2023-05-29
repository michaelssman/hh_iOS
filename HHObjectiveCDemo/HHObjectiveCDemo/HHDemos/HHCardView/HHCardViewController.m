//
//  ViewController.m
//  CardDemo
//
//  Created by Michael on 2020/9/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHCardViewController.h"
#import "HHCardView.h"
#import "HHCardCell.h"
#import <UIImageView+WebCache.h>
@interface HHCardViewController () <HHCardViewDelegate, HHCardViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) HHCardView *cardView;
@end

@implementation HHCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = @[@"https://p3.ssl.qhimgs1.com/sdr/_240_/t01a953fddcc94f4dc3.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t01819bdb0de9908b48.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t01ec04ff930c0b2ac1.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t01200857b803790d9e.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t010cb7fe30f404ff4c.jpg",
                       @"https://p5.ssl.qhimgs1.com/sdr/_240_/t01f67879e43a856f25.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t010c35e1d763532272.jpg",
                       @"https://p3.ssl.qhimgs1.com/sdr/_240_/t0187d3c97144b4cabd.jpg",
                       @"https://p5.ssl.qhimgs1.com/sdr/_240_/t014dc32129074ffbb5.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t019dcf4f4681cd38b1.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t018ff7e5cd8e0a4de6.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t0189b2c9871f2746b8.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t01c39b7658637f4df8.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t013aec0e3872d3165a.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t01126b01e636b3fc2b.jpg",
                       @"https://p5.ssl.qhimgs1.com/sdr/_240_/t01de0703da8e705fd5.jpg",
                       @"https://p5.ssl.qhimgs1.com/sdr/_240_/t017b01dea70676b4e5.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t0101f46ad7411cfcc2.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t01f6f2a8001c347f01.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t01d8556717803a53c4.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t011a8f11bc9736bb46.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t011a8f11bc9736bb46.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t0136cce212f39c0c84.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t01a0f54eca9c8ef1ca.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t014a8e7e676a13e6be.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t01ef126967f3a37e81.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t01694a88f647192ca1.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t01ec5a88d2a002416c.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t01601f38cd0e02591c.jpg",
                       @"https://p2.ssl.qhimgs1.com/sdr/_240_/t01a66fbf73c88c8c42.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t015e62a887c99b23b6.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t01b7ccc6734f0d21c4.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t0102c08ed720afe294.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t01bd1110469dfc5136.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t0144f9e3831ed34600.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t016a8ebe4758aab44b.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t017051a92705a8814b.jpg",
                       @"https://p3.ssl.qhimgs1.com/sdr/_240_/t0158aa282dbbff39f3.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t013fb7bf9b1388e154.jpg",
                       @"https://p3.ssl.qhimgs1.com/sdr/_240_/t0135b77d7a047c68ad.jpg",
                       @"https://p3.ssl.qhimgs1.com/sdr/_240_/t01d9602ca044cb3b8d.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t015892dc5140dff884.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t0138db16ca54001eeb.jpg",
                       @"https://p0.ssl.qhimgs1.com/sdr/_240_/t013e10667988ef41ae.png",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t018c915f4d64ba22eb.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t01e0e8d302e75767d7.jpg",
                       @"https://p1.ssl.qhimgs1.com/sdr/_240_/t01ff9aa28597a1dcdb.jpg",
                       @"https://p3.ssl.qhimgs1.com/sdr/_240_/t01062f2cac1c07d903.jpg",
                       @"https://p5.ssl.qhimgs1.com/sdr/_240_/t01d79cc1dff7176875.jpg",
                       @"https://p5.ssl.qhimgs1.com/sdr/_240_/t0194833b73fec0b495.jpg"];
    
    //cardView
    self.cardView = [[HHCardView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 400)];
    self.cardView.delegate = self;
    self.cardView.dataSource = self;
    [self.view addSubview:self.cardView];


    [self.cardView reloadData];
}

#pragma mark - HHCardViewDelegate
- (NSInteger)numberOfItemViewsInCardView:(HHCardView *)cardView {
    return self.dataArray.count;
}

- (HHCardCell *)cardView:(HHCardView *)cardView itemViewAtIndex:(NSInteger)index {
    HHCardCell *cell = [[HHCardCell alloc] initWithFrame:cardView.bounds];
    //可以再优化
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:cell.bounds];
    imgV.clipsToBounds = YES;
    imgV.layer.borderColor = [UIColor lightTextColor].CGColor;
    imgV.layer.borderWidth = 1;
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:imgV];
    [imgV sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index]]];
    return cell;
}

//加载更多
- (void)cardViewNeedMoreData:(HHCardView *)cardView {}

// cell点击
- (void)cardView:(HHCardView *)cardView didClickItemAtIndex:(NSInteger)index { }


@end
