//
//  HHTabViewsController.m
//  HHTabBarController_Example
//
//  Created by 崔辉辉 on 2021/4/12.
//  Copyright © 2021 888888888@qq.com. All rights reserved.
//

#import "HHTabViewsController.h"
#import <SCM-Swift.h>
#import "HHTabContentSubView.h"
@interface HHTabViewsController ()

@end

@implementation HHTabViewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    
    NSArray *array = @[@"带回家",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好"];
    HHTabBar *tabBar = [[HHTabBar alloc]init];
    tabBar.backgroundColor = [UIColor lightGrayColor];
    //先设置数据源，再设置下面属性，包括frame
    [tabBar setTitles:array];
    tabBar.indicatorColor = [UIColor purpleColor];
    tabBar.indicatorSwitchAnimated = YES;
    tabBar.indicatorCornerRadius = 20.0;
    tabBar.itemTitleColor = [UIColor cyanColor];
    tabBar.itemTitleSelectedColor = [UIColor blueColor];
    tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:14];
    tabBar.layer.cornerRadius = 20.0;
    [tabBar setScrollEnabledAndItemWidthWithWidth:110];
    //这个要在setTitles后面设置
//    tabBar.selectedItemIndex = 0;
    tabBar.itemFontChangeFollowContentScroll = YES;
    tabBar.indicatorScrollFollowContent = YES;
//    tabBar.indicatorAnimationStyle = HHTabBarIndicatorAnimationStyleDefault;
    [self.view addSubview:tabBar];
    [tabBar setIndicatorInsets:UIEdgeInsetsMake(35, 0, 0, 0)];

    HHTabContentView *cv = [[HHTabContentView alloc]init];
    cv.backgroundColor = [UIColor cyanColor];
    cv.tabBar = tabBar;
    [self.view addSubview:cv];
    NSMutableArray *vs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        HHTabContentSubView *tableView = [[HHTabContentSubView alloc]init];
        tableView.tag = i;
        [vs addObject:tableView];
    }
    cv.views = vs;
    cv.frame = CGRectMake(0, 180, self.view.frame.size.width, 300);
    tabBar.frame = CGRectMake(20, 100, 300, 40);
    tabBar.selectedItemIndex = 2;
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
