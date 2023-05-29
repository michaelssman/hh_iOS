//
//  HHPopView.m
//  HHBaseViews
//
//  Created by Michael on 2020/3/25.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHPopView.h"

#define LeftView 10.0f
#define TopToView 10.0f
#define kTableViewY 30

@interface HHPopView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)HHPopBackgroundView *backgroundView;
@property (nonatomic, strong)UIView *shadeView;//底部灰色背景view
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic,copy)void(^hiddenAction)(void);
@end

@implementation HHPopView

#pragma mark - initializer -
- (instancetype)init {
    if (self = [super init]) {
        //
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //
    }
    return self;
}

#pragma mark - privote method -
+ (instancetype)showPopViewWithWindowFrame:(CGRect)frame
                                 dataArray:(NSArray *)dataArray
                                  animated:(BOOL)animate
                                    hidden:(void(^)(void))hiddenAction {
    
    [HHPopView hiden:NO];
    
    HHPopView *popView = [[HHPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    popView.dataArray = dataArray;
    popView.hiddenAction = hiddenAction;
    
    
    popView.backgroundView = [[HHPopBackgroundView alloc]initWithFrame:frame];
    popView.backgroundViewFrame = frame;
    
    popView.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + kTableViewY, frame.size.width, frame.size.height - kTableViewY);

    popView.shadeView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, CGRectGetMaxY(popView.tableView.frame), frame.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(popView.tableView.frame))];
    popView.shadeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    [popView show];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundclick:)];
//    [popView addGestureRecognizer:tap];
//    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundclick:)];
//    [popView.shadeView addGestureRecognizer:tap1];
    
    if (animate == YES) {
        popView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            popView.alpha = 0.5;
            popView.backgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    
    return popView;
}

#pragma mark 刷新数据
- (void)reloadPopViewWithDataArray:(NSArray *)dataArray {
    self.dataArray = dataArray;
    //    popView.backgroundColor = [UIColor blackColor];
    //    popView.alpha = 0.7;
//    CGRect backgroundViewFrame = self.backgroundView.frame;
//    backgroundViewFrame.size.height = kBackgroundViewHeight;
//    self.backgroundView.frame = backgroundViewFrame;
//
//    CGRect frame = self.tableView.frame;
//    frame.size.height = tableViewHeight;
//    self.tableView.frame = frame;
    [self.tableView reloadData];
}


+ (void)tapBackgroundclick:(UITapGestureRecognizer *)gesture {
    [HHPopView hiden:NO];
}

- (void)show
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [window addSubview:self.shadeView];
    [window addSubview:self.backgroundView];
    [window addSubview:self.tableView];
}

+ (void)hiden:(BOOL)animate {
    
    HHPopView *popView = [self popViewWithView:[[UIApplication sharedApplication] keyWindow]];
    if (animate) {
        //            //    带动画样式
        //        if (popView != nil) {
        //            [UIView animateWithDuration:0.3 animations:^{
        //                tableView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        //            } completion:^(BOOL finished) {
        //                [popView removeFromSuperview];
        //                [tableView removeFromSuperview];
        //                popView = nil;
        //                tableView = nil;
        //            }];
        //        }
    } else {
        if (popView != nil) {
            if (popView.hiddenAction) {
                popView.hiddenAction();
            }
            [UIView animateWithDuration:0.1 animations:^{
                [popView.tableView removeFromSuperview];
                [popView.shadeView removeFromSuperview];
                [popView.backgroundView removeFromSuperview];
                [popView removeFromSuperview];
            }];
        }
    }
}

+ (HHPopView *)popViewWithView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            HHPopView *hud = (HHPopView *)subview;
            return hud;
        }
    }
    return nil;
}

#pragma mark - tableViewdatasource,tableViewDelegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate popView:self tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:tableView:cellForRowAtIndexPath:)]) {
        return [self.delegate popView:self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popView:tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate popView:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    [HHPopView hiden:NO];
}

#pragma mark - tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.layer.masksToBounds = YES;
        self.tableView.layer.cornerRadius = 6.0f;
        self.tableView.layer.shadowColor = [UIColor cyanColor].CGColor;
        self.tableView.layer.shadowOffset = CGSizeMake(-5, 5);
        //    tableView.layer.anchorPoint = CGPointMake(1.0, 0);
        //    tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.tableView.backgroundColor = [UIColor cyanColor];
    }
    return _tableView;
}

#pragma mark - draw up triangle -
//- (void)drawRect:(CGRect)rect {
//    [[UIColor whiteColor] set];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // draw up paths
//    CGContextBeginPath(context);
//    CGFloat location = SCREEN_WIDTH;
//    CGContextMoveToPoint(context, location - LeftView - 10, 70);//起点
//    CGContextAddLineToPoint(context, location - 2*LeftView - 10, 60);
//    CGContextAddLineToPoint(context, location - TopToView*3 - 10, 70);
//    CGContextClosePath(context);
//
//    [[UIColor whiteColor] setFill];
//    [[UIColor whiteColor] setStroke];
//    CGContextDrawPath(context, kCGPathFillStroke);
//
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
