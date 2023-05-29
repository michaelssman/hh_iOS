//
//  ViewController.m
//  UMDemo
//
//  Created by Michael on 2020/11/27.
//

#import "UMShareViewController.h"
#import "UMShareUtil.h"
@interface UMShareViewController ()

@end

@implementation UMShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20.0;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(shareA) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareA
{
    //创建分享的网页
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享的标题" descr:@"分享的描述" thumImage:@"分享的图片"];
    shareObject.webpageUrl = @"分享的链接";
    [UMShareUtil shareToPlatformType:UMSocialPlatformType_WechatTimeLine umShareObject:shareObject];
}

@end
