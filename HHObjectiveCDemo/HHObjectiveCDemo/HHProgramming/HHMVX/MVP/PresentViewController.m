//
//  PresentViewController.m
//  HHMVX
//
//  Created by Michael on 2021/5/9.
//  Copyright © 2021 michael. All rights reserved.
//

#import "PresentViewController.h"
#import "LMDataSource.h"
#import "MVPTableViewCell.h"
#import "MVModel.h"
#import "Present.h"

static NSString *const reuserId = @"reuserId";

@interface PresentViewController ()<PresentProtocol>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Present *pt;
@property (nonatomic, strong) LMDataSource *dataSource;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1. 数据提供层
    self.pt = [[Present alloc] init];
    __weak  typeof(self) weakSelf = self;
    //2. 数据业务处理层
    self.dataSource = [[LMDataSource alloc]initWithIdentifier:reuserId configureBlock:^(MVPTableViewCell *cell, MVModel *model, NSIndexPath *indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        cell.numLabel.text = model.num;
        cell.nameLabel.text = model.name;
        cell.delegate = strongSelf.pt;//设置通讯代理
        cell.indexPath = indexPath;
    }];
    [self.view addSubview:self.tableView];
    //3. 建立关系
    self.tableView.dataSource = self.dataSource;
    [self.dataSource addDataArray:self.pt.dataArray];
    self.pt.delegate = self;

}

#pragma mark -PrsentProtocol
-(void)reloadUI {
    [self.dataSource addDataArray:self.pt.dataArray];
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [_tableView registerClass:[MVPTableViewCell class] forCellReuseIdentifier:reuserId];
    }
    return _tableView;
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
