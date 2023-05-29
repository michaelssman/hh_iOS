//
//  PdfBottomView.m
//  PdfLooker
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PdfBottomView.h"
#import <SCM-Swift.h>
@implementation PdfBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBottomView];
        [self setUpFilpPageView];
    }
    return self;
}
#pragma mark bottomView
- (void)createBottomView {
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithHex:0xffffff];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(PdfBottomHeight);
    }];
    WEAKSELF
    self.catalogueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.catalogueBtn setTitle:@"目录" forState:UIControlStateNormal];
    [self.catalogueBtn setImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
    [self.catalogueBtn setImage:[UIImage imageNamed:@"icon_list_sel"] forState:UIControlStateHighlighted];
    [self.catalogueBtn setTitleColor:[UIColor colorWithHex:0x404548] forState:UIControlStateNormal];
    [self.catalogueBtn setTitleColor:[UIColor themeColor] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.catalogueBtn];
    [self.catalogueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(0);
    }];
    
    UILabel *lineLab = [[UILabel alloc]init];
    lineLab.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [self.bottomView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.catalogueBtn.mas_right).offset(0);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(4);
        make.centerY.equalTo(weakSelf.bottomView);
    }];
    
    self.pageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pageBtn setTitle:@"翻页" forState:UIControlStateNormal];
    [self.pageBtn setImage:[UIImage imageNamed:@"icon_page_turn"] forState:UIControlStateNormal];
    [self.pageBtn setImage:[UIImage imageNamed:@"icon_page_turn_sel"] forState:UIControlStateSelected];
    [self.pageBtn setTitleColor:[UIColor colorWithHex:0x404548] forState:UIControlStateNormal];
    [self.pageBtn setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
    [self.pageBtn addTarget:self action:@selector(handleFilpPage) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.pageBtn];
    [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLab.mas_right).offset(0);
        make.right.bottom.top.mas_equalTo(0);
        make.width.equalTo(weakSelf.catalogueBtn);
    }];

}
#pragma mark
- (void)setUpFilpPageView {
    self.flipPageView = [[UIView alloc]initWithFrame:CGRectMake(0, PdfFlipPageHeight + PdfBottomHeight, SCREEN_WIDTH, PdfFlipPageHeight)];
    self.flipPageView.backgroundColor = [UIColor colorWithHex:0xffffff];
    [self addSubview:self.flipPageView];
    
    WEAKSELF
    self.pageLab = [[UILabel alloc] initWithTextColor:[UIColor colorWithHex:404548] fontSize:28];
    [self.flipPageView addSubview:self.pageLab];
    [self.pageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.flipPageView);
        make.top.mas_equalTo(10);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"pdf_icon_left_arrow"] forState:UIControlStateNormal];
    [self.flipPageView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"pdf_icon_right_arrow"] forState:UIControlStateNormal];
    [self.flipPageView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    self.pageSlider = [[UISlider alloc]init];
    self.pageSlider.minimumTrackTintColor = [UIColor themeColor];
    self.pageSlider.maximumTrackTintColor = [UIColor colorWithHex:0xd2d2d2];
    self.pageSlider.thumbTintColor = [UIColor themeColor];
    [self.flipPageView addSubview:self.pageSlider];
    [self.pageSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerX.equalTo(weakSelf.flipPageView);
        make.bottom.mas_equalTo(-10);
    }];
}
///
- (void)handleFilpPage {
    if (self.pageBtn.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.flipPageView.frame = CGRectMake(0, PdfFlipPageHeight + PdfBottomHeight, SCREEN_WIDTH, PdfFlipPageHeight);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.flipPageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, PdfFlipPageHeight);
        }];
    }
    self.pageBtn.selected = !self.pageBtn.selected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
