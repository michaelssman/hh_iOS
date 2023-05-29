//
//  TestLabelViewController.m
//  HHCategorysDemo
//
//  Created by Michael on 2020/4/3.
//  Copyright © 2020 michael. All rights reserved.
//

#import "TestLabelViewController.h"
#import "UILabel+Util.h"
@interface TestLabelViewController ()

@end

@implementation TestLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    lab.numberOfLines = 0;
    lab.text = @"发动机上课；发了几款礼服；记得发酒疯健康； 就健康和空间和空间环境狂欢节 健康环境狂欢节看";
    UILabel *tagLabel = [UILabel new];
    tagLabel.text = @"我TM是个类似图片的标签";
    tagLabel.font = [UIFont boldSystemFontOfSize:12];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.backgroundColor = [UIColor redColor];
    tagLabel.clipsToBounds = YES;
    tagLabel.layer.cornerRadius = 3;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    [lab setTextAttachment:tagLabel];
    [self.view addSubview:lab];
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
