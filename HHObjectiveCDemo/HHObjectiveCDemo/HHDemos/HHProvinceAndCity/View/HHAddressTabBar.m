//
//  HHAddressTabBar.m
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHAddressTabBar.h"
@interface HHAddressTabBar()
@property (nonatomic, strong)UIView *underLine;
@end
@implementation HHAddressTabBar
static CGFloat const HHBarItemMargin = 20;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    _selectedIndex = 0;
    self.tabItems = [NSMutableArray arrayWithCapacity:0];

    self.underLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.underLine.backgroundColor = [UIColor grayColor];
    [self addSubview:self.underLine];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (NSInteger i = 0; i < self.tabItems.count; i++) {
        UIView *view = self.tabItems[i];
        if (i == 0) {
            CGRect frame = view.frame;
            frame.origin.x = HHBarItemMargin;
            frame.size.height = self.frame.size.height - 2;
            view.frame = frame;
        }
        if (i > 0) {
            UIView *preV = self.tabItems[i - 1];
            CGRect frame = view.frame;
            frame.origin.x = HHBarItemMargin + CGRectGetMaxX(preV.frame);
            frame.size.height = self.frame.size.height - 2;
            view.frame = frame;
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    UIButton *button = [self.tabItems objectAtIndex:_selectedIndex];
    button.selected = NO;
    button = [self.tabItems objectAtIndex:selectedIndex];
    button.selected = YES;
    _selectedIndex = selectedIndex;
    
    self.underLine.frame = CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame), button.frame.size.width, 2.0);
}

- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    
    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    UIButton *leftItem = self.tabItems[leftIndex];
    UIButton *rightItem = nil;
    if (rightIndex < self.tabItems.count) {
        rightItem = self.tabItems[rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0～1
    rightScale = rightScale - leftIndex;

    
    CGRect frame = self.underLine.frame;
    CGFloat xDiff = rightItem.frame.origin.x - leftItem.frame.origin.x;
    
    frame.origin.x = rightScale * xDiff + leftItem.frame.origin.x;
    
    CGFloat widthDiff = rightItem.frame.size.width - leftItem.frame.size.width;
    frame.size.width = rightScale * widthDiff + leftItem.frame.size.width;
    
    self.underLine.frame = frame;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
