//
//  HHRouterViewController.m
//  HHRouter
//
//  Created by Michael on 2020/7/14.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHRouterViewController.h"
#import "HHRouter+Utils.h"
@interface HHRouterViewController ()

@end

@implementation HHRouterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HHRouter *router = [HHRouter sharedInstance];
    [router openUrl:@"http://Index/home?name=zhangsan&pws=123"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20.0;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"newsVC" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnA) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 300, 100, 90);
}

- (void)btnA
{
    // 这里 param dict 的 value 也可以 传 model
    UIViewController *viewController = [[HHRouter sharedInstance] hhRouter_newsViewControllerWithParams:@{@"newsID":@"123456"} callBlock:^(NSString * _Nonnull str) {
        NSLog(@"回调！！！！！%@",str);
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
