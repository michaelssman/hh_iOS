//
//  HHPopViewViewTestController.m
//  HHBaseViews
//
//  Created by Michael on 2020/3/31.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHPopViewViewTestController.h"
#import "HHPopView.h"

@interface HHPopViewViewTestController ()<HHPopViewDelegate>
@property (nonatomic, strong)HHPopView *popView;

@end

@implementation HHPopViewViewTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"刷新下拉数据" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, 128, 60);
    [btn addTarget:self action:@selector(bbb) forControlEvents:UIControlEventTouchUpInside];
}
- (void)bbb {
    [self.popView reloadPopViewWithDataArray:@[@"发动机舒服",@"豆腐块；第六回房间里好风景看",@"返回丹江口市；家里；缴费单飞机考",@"法国的手机卡了 ",@"返回都是卡列洪薯榔航天飞机看",@"会分开的；使肌肤",@"发哈到家酸辣粉"]];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.popView = [HHPopView showPopViewWithWindowFrame:CGRectMake(0, 117, [UIScreen mainScreen].bounds.size.width, 100)  dataArray:@[@"发发呆fdsf",@"发大的身份地方发",@"到范德萨范德萨发疯"] animated:YES hidden:^{
        NSLog(@"wo shi yin cang");
    }];
    self.popView.delegate = self;
}

#pragma mark - delegate
- (CGFloat)popView:(HHPopView *)popView tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell *)popView:(HHPopView *)popView tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell1";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = popView.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)popView:(HHPopView *)popView tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
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
