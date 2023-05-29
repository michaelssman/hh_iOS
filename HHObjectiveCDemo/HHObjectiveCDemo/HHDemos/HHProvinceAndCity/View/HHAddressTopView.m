//
//  HHAddressTopView.m
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHAddressTopView.h"
@interface HHAddressTopView()
@property (nonatomic, strong)UILabel *titleLab;
@end
@implementation HHAddressTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.titleLab = [[UILabel alloc]initWithFrame:self.bounds];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.text = @"请选择所在地区";
        [self addSubview:self.titleLab];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
