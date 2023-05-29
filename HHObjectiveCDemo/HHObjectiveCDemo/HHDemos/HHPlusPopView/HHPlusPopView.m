//
//  HHPlusPopView.m
//  HHPlusPopViewDemo
//
//  Created by Michael on 2018/8/3.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHPlusPopView.h"
#import <SCM-Swift.h>

static NSTimeInterval kAnimationDuration = 0.3;

@interface HHPlusPopView() <UIScrollViewDelegate>

@property (nonatomic,   copy) NSArray *imageNames;
@property (nonatomic,   copy) NSArray *titles;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic,   copy) void (^selectBlock)(NSInteger index);
@property (nonatomic, assign) NSInteger currentPage;

/// 每一页有几列  默认三列
@property (nonatomic, assign)NSInteger columnCount;
/// 每一页有几行  默认两行
@property (nonatomic, assign)NSInteger rowCount;
@end
@implementation HHPlusPopView

+ (instancetype)showWithImages:(NSArray *)imgs
                        titles:(NSArray *)titles
                   selectBlock:(void (^)(NSInteger))selectBlock
{
    return [HHPlusPopView showWithImages:imgs titles:titles columnCount:3 rowCount:2 selectBlock:selectBlock];
}

+ (instancetype)showWithImages:(NSArray *)imgs
                        titles:(NSArray *)titles
                   columnCount:(NSInteger)columnCount
                      rowCount:(NSInteger)rowCount
                   selectBlock:(void (^)(NSInteger index))selectBlock
{
    HHPlusPopView *bg = [[HHPlusPopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_SAFE_BOTTOM_MARGIN)];
    bg.rowCount = rowCount;
    bg.columnCount = columnCount;
    bg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    [[UIApplication sharedApplication].keyWindow addSubview:bg];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = bg.bounds;
    //     effectView.alpha = 0.8;
    [bg addSubview:effectView];
    
    [bg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:bg action:@selector(close)]];
    bg.imageNames = imgs.copy;
    bg.titles = titles.copy;
    bg.selectBlock = [selectBlock copy];
    
    [bg setupMainView];
    [bg setupItem];
    [bg setupBottomView];
    return bg;
}

- (void)setupMainView {
    CGFloat scrollViewHeight = [UIScreen mainScreen].bounds.size.height * 0.47;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - scrollViewHeight - TAB_BAR_SAFE_BOTTOM_MARGIN, self.frame.size.width, scrollViewHeight)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.delegate = self;
    NSInteger pages = (self.titles.count - 1) / (self.columnCount * self.rowCount) + 1;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pages, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(self.frame.size.width / 2 - 10, self.bounds.size.height - 49 - 20 - 20, 20, 20);//指定位置大小
    pageControl.numberOfPages = pages;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    pageControl.hidesForSinglePage = YES;
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}

- (void)setupItem {
    //顶部距离
    CGFloat vMargin = 70;
    CGFloat vSpacing = 20;
    CGFloat xMargin = 35;
    CGFloat itemWidth = (self.scrollView.frame.size.width - xMargin * 2) / self.columnCount;
    CGFloat itemHeight = 107.5;
    NSInteger row = 0;
    NSInteger loc = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < self.imageNames.count; i ++) {
        //第几行    % self.rowCount 为了翻页
        row = i / self.columnCount % self.rowCount;
        //第几列
        loc = i % self.columnCount ;
        //当前button在第几页
        NSInteger page = i / (self.columnCount * self.rowCount);
        //求x坐标
        x = xMargin + itemWidth * loc + page * self.scrollView.frame.size.width;
        //已经不在第一页了
        if (page > 0) {
            y = vMargin + (itemHeight + vSpacing) * row;
        } else {
            y = self.scrollView.frame.size.height + (itemHeight + vSpacing) * row;
        }
        HHButton *button = [HHButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setImage:[UIImage imageNamed:self.imageNames[i]] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeCenter];
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        button.imageRect = CGRectMake(10, 0, itemWidth - 10 * 2, itemHeight - 30);
        button.titleRect = CGRectMake(0, CGRectGetMaxY(button.imageRect) + 10, itemWidth, 20);
        [self.scrollView addSubview:button];
        
        //必须设置frame，下面的只是动画效果，并且是根据这个初始frame做动画
        button.frame = CGRectMake(x, y, itemWidth, itemHeight);
        
        //个数为1页
        if (i < self.columnCount * self.rowCount) {
            [UIView animateWithDuration:kAnimationDuration
                                  delay:i * 0.03
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.04
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                button.frame  = CGRectMake(xMargin + itemWidth * loc, vMargin + (itemHeight + vSpacing) * row, itemWidth, itemHeight);
            }
                             completion:^(BOOL finished) {
            }];
        }
        [items addObject:button];
    }
    self.items = [NSArray arrayWithArray:items];
}

- (void)setupBottomView {
    CGFloat bottomViewHeight = 49;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - bottomViewHeight - TAB_BAR_SAFE_BOTTOM_MARGIN, self.bounds.size.width, bottomViewHeight)];
    [self addSubview:bottomView];
    
    UIImageView *shutImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    self.shutImgView = shutImgView;
    shutImgView.image = [UIImage imageNamed:@"×"];
    shutImgView.center = CGPointMake(bottomView.bounds.size.width * 0.5, bottomView.bounds.size.height * 0.5);
    [bottomView addSubview:shutImgView];
}

- (void)show
{
    [self showBottomView];
}

- (void)showBottomView
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.shutImgView.transform = CGAffineTransformMakeRotation(45 / 180.0 * M_PI);
    }];
}

#pragma mark - event response
- (void)selectClick:(HHButton *)button {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (self.selectBlock) {
        self.selectBlock(button.tag);
    }
}

- (void)close {
    CGFloat dy = CGRectGetHeight(self.frame) + 70;
    NSInteger count = 0;
    if (self.imageNames.count / (self.columnCount * self.rowCount) > self.currentPage) {
        count = self.columnCount * self.rowCount; // 当前要具有 self.columnCount * self.rowCount 个按钮;
    } else {
        count = self.imageNames.count % (self.columnCount * self.rowCount); // 最后一页的按钮个数
    }
    
    CGFloat delay = 0.03;
    [UIView animateWithDuration:kAnimationDuration + delay * count - 0.01 animations:^{
        self.shutImgView.transform = CGAffineTransformMakeRotation(0);
        ///先背景色消失
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        self.shutImgView.hidden =YES;
        self.pageControl.hidden = YES;
    }];
    
    
    
    for (int i = 0; i < count; i ++) {
        HHButton *button = [self viewWithTag:self.currentPage * (self.columnCount * self.rowCount)  + i];
        CGFloat width = CGRectGetWidth(button.frame);
        CGFloat buttonX = button.frame.origin.x;//0.3-i*0.03
        //每一个按钮都做一次时长kAnimationDuration的动画 但是开始时间不同。
        [UIView animateWithDuration:kAnimationDuration
                              delay:delay * count - i * delay
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.04
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            button.frame  = CGRectMake(buttonX, dy, width, width);
        }
                         completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.currentPage = page;
    // 设置页码
    self.pageControl.currentPage = page;
}

- (void)setScrollViewColor:(UIColor *)scrollViewColor
{
    self.scrollView.backgroundColor = scrollViewColor;
}

- (void)setItemColor:(UIColor *)itemColor
{
    _itemColor = itemColor;
    for (UIButton *item in self.items) {
        [item setTitleColor:itemColor forState:UIControlStateNormal];
    };
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
