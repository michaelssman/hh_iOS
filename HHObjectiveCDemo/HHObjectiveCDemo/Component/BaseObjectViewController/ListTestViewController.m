//
//  TestViewController.m
//  HHTableListViewController
//
//  Created by 崔辉辉 on 2020/5/6.
//  Copyright © 2020 huihui. All rights reserved.
//

#import "ListTestViewController.h"
#import "HHListController.h"
@interface ListTestViewController ()<HHTableViewDelegate>
@property (nonatomic, strong)HHListController *listVC;
@end

@implementation ListTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.listVC = [[HHListController alloc]init];
    self.listVC.tableViewDelegate = self;
    [self addChildViewController:self.listVC];
    [self.view addSubview:self.listVC.view];
    self.listVC.view.frame = self.view.bounds;
    
    [self.listVC.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.listVC.didScroll = ^{
        //
    };
    
    //设置lastCell和空数据
    self.listVC.lastCell.textLabel.textColor = [UIColor redColor];
    self.listVC.lastCell.textLabel.font = [UIFont systemFontOfSize:14];
    self.listVC.requestData = ^(HHListController * _Nonnull listVC, BOOL refresh, SuccessCallBack  _Nonnull success, FailureCallback  _Nonnull failure) {
        //如果是刷新 offset设置为第一页 有的是1是第一页 有的是0是第一页
        if (refresh) {
            listVC.offset = 1;
        }
        
        //网络请求成功
        NSArray *responseArray = @[@"范德萨发",@"发送到",@"发送到",@"到发萨芬发",@"发发的是非得失",@"发送到",@"发发送到范德萨",@"范德萨",@"规范化发",@"发烫衣服",@"刚发的",@"规范地方法规",@"玉体u哦破"];
        // 成功
        success(responseArray);
        //失败
//        failure();
    };
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.listVC.objects[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99;
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
