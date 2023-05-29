//
//  PdfTopNavBarView.m
//  PdfLooker
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PdfNavBarView.h"
#import <SCM-Swift.h>
@implementation PdfNavBarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor themeColor];
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        self.titleLab = [[UILabel alloc] initWithTextColor:[UIColor colorWithHex:0xffffff] fontSize:34];

        [self addSubview:self.backBtn];
        [self addSubview:self.titleLab];
        
        [self setUpConstraints];
    }
    return self;
}
- (void)setUpConstraints {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
