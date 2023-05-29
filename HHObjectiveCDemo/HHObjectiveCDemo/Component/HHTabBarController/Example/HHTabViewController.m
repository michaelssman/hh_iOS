//
//  HHTabViewController.m
//  HHTabBarController_Example
//
//  Created by 崔辉辉 on 2020/8/25.
//  Copyright © 2020 888888888@qq.com. All rights reserved.
//

#import "HHTabViewController.h"
#import <SCM-Swift.h>
@interface HHTabViewController ()
@property (nonatomic, strong)HHTabContentView *tabContentView;

@end

@implementation HHTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    //流海屏 页面上下偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat barHeight = 40, buttonWidth = 40;
    self.tabContentView = [[HHTabContentView alloc]init];
    [self.view addSubview:self.tabContentView];
    [self.view addSubview:self.tabContentView.tabBar];
    //先设置controllers，再设置frame
    [self initViewControllers];
    self.tabContentView.frame = CGRectMake(0, 88 + barHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 88 - barHeight - 49);
    self.tabContentView.tabBar.frame = CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width - buttonWidth, barHeight);
    self.tabContentView.tabBar.itemTitleColor = [UIColor redColor];
    self.tabContentView.tabBar.itemTitleSelectedColor = [UIColor blueColor];
    self.tabContentView.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabContentView.tabBar.itemTitleSelectedFont = [UIFont boldSystemFontOfSize:15];

    self.tabContentView.tabBar.backgroundColor = [UIColor whiteColor];
//    self.loadViewOfChildContollerWhileAppear = YES;
//    [self setContentScrollEnabled:YES tapSwitchAnimated:YES];
    
    self.tabContentView.tabBar.indicatorScrollFollowContent = YES;
    self.tabContentView.tabBar.indicatorColor = [UIColor orangeColor];
//    self.tabBar.indicatorAnimationStyle = YPTabBarIndicatorAnimationStyle2;
    self.tabContentView.tabBar.indicatorCornerRadius = 2.0;
    [self.tabContentView.tabBar setScrollEnabledAndItemFitTextWidthWithSpacingWithSpacing:30 minWidth:55];
    
//    [self.tabContentView setSelectedTabIndex:1];
    [self setBadge];
}
- (void)initViewControllers
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
    for (int i  = 0; i < 7; i++) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor orangeColor];
        [viewControllers addObject:vc];
        vc.title = [NSString stringWithFormat:@"栏目%d",i];
    }
    self.tabContentView.viewControllers = viewControllers;
}

- (void)setBadge
{
    // TODO: 待做
//    for (UIViewController *vc in self.viewControllers) {
//        //badge
//        HHBadgeButton *badgeButton = vc.tabItem.badgeButton;
////        badgeButton.badgeStyle = HHTabItemBadgeStyleNumber;
//        badgeButton.badgeTitleFont = [UIFont boldSystemFontOfSize:11];
//        badgeButton.badge = 35;
//        badgeButton.badgeBackgroundColor = [UIColor cyanColor];
//        badgeButton.badgeTitleColor = [UIColor blueColor];
//        [badgeButton setNumberBadgeWithMarginTop:0 centerMarginRight:0 titleHorizonalSpace:5 titleVerticalSpace:0];
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
