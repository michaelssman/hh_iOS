//
//  PinggaiView.m
//  DrawingRound
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PinggaiView.h"
#import "Masonry.h"
#import "UIColor+Util.h"
#import "UIButton+ImagePosition.h"
#define WEAKSELF                        __weak __typeof(self) weakSelf = self;

static const int totalPage = 4;
static const int pageBtnTag = 100;
static const int functionTag = 200;
static const int drawingViewTag = 300;
@interface PinggaiView ()<UIScrollViewDelegate>
{
    NSInteger _currentIndex;
}
@property (nonatomic, strong)UIButton *playBtn;
@property (nonatomic, strong)UISlider *progressSlider;
@property (nonatomic, strong)UIButton *commentBtn;
@property (nonatomic, strong)UIButton *correntBtn;
@end
@implementation PinggaiView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        [self addContentView];
        [self addPageButton];
        [self addFunctionButton];
    }
    return self;
}
//添加内容视图
- (void)addContentView {
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor colorWithHex:0xffffda];
    //设置scrollView按页滚动
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
 
    self.progressSlider = [[UISlider alloc]init];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"icon_timeline"] forState:UIControlStateNormal];
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"icon_Play_Button"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"icon_Pause_Button"] forState:UIControlStateSelected];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setTitle:@"评语" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor colorWithHex:0x404548] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"icon_comment_sel"] forState:UIControlStateSelected];
    [self.commentBtn setImagePosition:ImagePositionTop spacing:0];
    
    self.correntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.correntBtn setTitle:@"批改" forState:UIControlStateNormal];
    [self.correntBtn setTitle:@"预览" forState:UIControlStateSelected];
    [self.correntBtn setTitleColor:[UIColor colorWithHex:0x404548] forState:UIControlStateNormal];
    [self.correntBtn setTitleColor:[UIColor colorWithHex:0x404548] forState:UIControlStateSelected];
    [self.correntBtn setImage:[UIImage imageNamed:@"icon_correct"] forState:UIControlStateNormal];
    [self.correntBtn setImage:[UIImage imageNamed:@"icon_preview"] forState:UIControlStateSelected];
    [self.correntBtn setImagePosition:ImagePositionTop spacing:0];
    [self.correntBtn addTarget:self action:@selector(handleCorrentAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [self addSubview:self.scrollView];
    [self addSubview:self.progressSlider];
    [self addSubview:self.playBtn];
    [self addSubview:self.commentBtn];
    [self addSubview:self.correntBtn];
    [self setUpConstraints];

    
    //设置scrollView的contentSize属性
    self.scrollView.contentSize = CGSizeMake(totalPage * self.bounds.size.width, 0);
    //将图片添加到scrollView上
    for (int i = 0; i < totalPage; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"opern.jpeg"]];
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(i * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        imageView.userInteractionEnabled = YES;
        DrawingView *drawingV = [[DrawingView alloc]initWithFrame:imageView.bounds];
        drawingV.tag = i + drawingViewTag;
        [imageView addSubview:drawingV];
        WEAKSELF
        drawingV.hiddenFunctionBtn = ^ {
            for (int index = 0; index < 3; index ++) {
                [weakSelf viewWithTag:index + functionTag].hidden = YES;
            }
        };
        drawingV.showFunctionBtn = ^ {
            for (int index = 0; index < 3; index ++) {
                [weakSelf viewWithTag:index + functionTag].hidden = NO;
            }
        };
    }
}
- (void)setUpConstraints {
    WEAKSELF
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(-60);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.progressSlider.mas_bottom).offset(10);
    }];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.progressSlider.mas_bottom).offset(5);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(90, 60));
    }];
    [self.correntBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.commentBtn);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(90, 60));
    }];
}

/**
 添加页面左右切换按钮
 */
- (void)addPageButton {
    for (int index = 0; index < 2; index ++) {
        UIButton *pageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:pageBtn];
        pageBtn.tag = index + pageBtnTag;
        if (index == 0) {
            [pageBtn setImage:[UIImage imageNamed:@"icon_left_arrow"] forState:UIControlStateNormal];
            [pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.centerY.equalTo(self);
            }];
            pageBtn.hidden = YES;
        } else {
            [pageBtn setImage:[UIImage imageNamed:@"icon_right_arrow"] forState:UIControlStateNormal];
            [pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.centerY.equalTo(self);
            }];
            pageBtn.hidden = NO;
        }
        [pageBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark Btn-Action
- (void)changePage:(UIButton *)sender {
    //翻页  如果之前有选中的批注, 则取消选中.
    DrawingView *drawV = [self.scrollView viewWithTag:_currentIndex + drawingViewTag];
    [drawV cancelEdit];
    if (sender.tag == 0 + pageBtnTag) {
        [self.scrollView setContentOffset:CGPointMake((-- _currentIndex) * self.bounds.size.width, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake((++ _currentIndex) * self.bounds.size.width, 0) animated:YES];
    }
    [self controlPageBtn];
}
#pragma mark addFunctionBtn
- (void)addFunctionButton {
    CGFloat edge = 70, pad = 15, btnY = 500, btnWidth = (self.bounds.size.width - 2 * edge - 2 * pad) / 3.0;
    for (int index = 0; index < 3; index ++) {
        UIButton *founctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:founctionBtn];
        founctionBtn.frame = CGRectMake(edge + index * (btnWidth + pad), btnY, btnWidth, 30);
        founctionBtn.backgroundColor = [UIColor blackColor];
        founctionBtn.layer.masksToBounds = YES;
        founctionBtn.layer.cornerRadius = 4.0;
        founctionBtn.tag = index + functionTag;
        switch (index) {
            case 0: {
                [founctionBtn setTitle:@"文字" forState:UIControlStateNormal];
                break;
            }
            case 1: {
                [founctionBtn setTitle:@"语音" forState:UIControlStateNormal];
                break;
            }
            case 2: {
                [founctionBtn setTitle:@"删除" forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
        founctionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [founctionBtn addTarget:self action:@selector(handleFounctionAction:) forControlEvents:UIControlEventTouchUpInside];
        founctionBtn.hidden = YES;
    }
}
- (void)handleFounctionAction:(UIButton *)sender {
    switch (sender.tag - functionTag) {
        case 0: {
            NSLog(@"显示一个弹窗");
            break;
        }
        case 1: {
            NSLog(@"显示一个弹窗");
            break;
        }
        case 2: {
            DrawingView *drawingV = [self.scrollView viewWithTag:_currentIndex + drawingViewTag];
            [drawingV deleteMark];
            break;
        }
        default:
            break;
    }
}
#pragma mark ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //获取scrollView的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取当前偏移的图片个数
    NSInteger count = offsetX / self.bounds.size.width;
    _currentIndex = count;
    [self controlPageBtn];
}

/**
 控制页面切换按钮的显示
 */
- (void)controlPageBtn {
    if (_currentIndex ==0) {
        [self viewWithTag:0 + pageBtnTag].hidden = YES;
    } else {
        [self viewWithTag:0 + pageBtnTag].hidden = NO;
    }
    if (_currentIndex == (totalPage - 1)) {
        [self viewWithTag:1 + pageBtnTag].hidden = YES;
    } else {
        [self viewWithTag:1 + pageBtnTag].hidden = NO;
    }
}
/**
 切换模式

 @param sender 状态按钮
 */
- (void)handleCorrentAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MsgChangeCorrectMode object:nil];
    if (sender.isSelected) {
        self.scrollView.scrollEnabled = NO;
    } else {
        self.scrollView.scrollEnabled = YES;
    }
    sender.selected = !sender.selected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
