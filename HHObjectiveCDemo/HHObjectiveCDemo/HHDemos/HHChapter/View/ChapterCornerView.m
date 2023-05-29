//
//  ChapterCornerView.m
//  HHChapterDemo
//
//  Created by Michael on 2021/3/19.
//  Copyright © 2021 michael. All rights reserved.
//

#import "ChapterCornerView.h"
static void *ChapterDataSource = &ChapterDataSource;
@interface ChapterCornerView()
@end
@implementation ChapterCornerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAction)]];
        [self addSubview:view];

        [self addSubview:self.cornerView];
        self.chapterV = [[HHChapterView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 300)];
        [self.cornerView addSubview:self.chapterV];
        [self.chapterV addObserver:self forKeyPath:@"objects" options:NSKeyValueObservingOptionNew context:ChapterDataSource];
    }
    return self;
}
- (UIView *)cornerView
{
    if (!_cornerView) {
        self.cornerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 300)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cornerView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.cornerView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.cornerView.layer.mask = maskLayer;
    }
    return _cornerView;
}
- (void)hiddenAction
{
    [self.chapterV hiddenAction];
    [self removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ChapterDataSource) {
        NSArray *a = change[NSKeyValueChangeNewKey];
        CGFloat height = (a.count * 45) > 300 ? 300 : (a.count * 45 + 10);
        self.cornerView.frame = CGRectMake(0, 0, self.bounds.size.width, height);
        self.chapterV.frame = CGRectMake(0, 0, self.bounds.size.width, height);
        NSLog(@"%@",a);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc
{
    [self.chapterV removeObserver:self forKeyPath:@"objects"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
