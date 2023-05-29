//
//  HHRuntimeViewController.m
//  HHRuntime
//
//  Created by Michael on 2020/9/7.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHRuntimeViewController.h"
#import "Person.h"
#import "LMDataSource.h"

#import "HHStudent.h"
#import "HHStudent+HH.h"
#import "HHPerson.h"
@interface HHRuntimeViewController ()<UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong) LMDataSource *dataSource;

@end

@implementation HHRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.objects = [NSMutableArray arrayWithObjects:
                    @"消息转发",
                    @"方法交换",
                    @"HHRuntimeDemoVC",
                    nil];
    //2. 数据业务处理层
    self.dataSource = [[LMDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, NSString *model, NSIndexPath *indexPath) {
        cell.textLabel.text = model;
    }];
    [self.dataSource addDataArray:self.objects];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.dataSource;
}

#pragma mark lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {//消息转发
            NSDictionary *dic = [NSDictionary dictionary];
            NSLog(@"dicV: %@",dic[@"dis"]);
            
            Person *p = [[Person alloc]init];
            [p runTo:@"明天"];
            
            [[Person new] runTo:@"canshu"];
        //    //哪个对象，方法编号
        //    objc_msgSend([Person new],@selector(runTo:),@"canshu");
            /**
             通过对象的isa找到class。methodList中查找，有就用，没有
             根据SEL找IMP
             */
        }
            break;
        case 1: {//方法交换
            // 黑魔法坑点二: 子类没有实现 - 父类实现
            HHStudent *s = [[HHStudent alloc] init];
            [s personInstanceMethod];
            
            
            // personInstanceMethod -> hh_studentInstanceMethod
            HHPerson *p = [[HHPerson alloc] init];
        //    [p personInstanceMethod];
        }
        case 2:
        {
            [self.navigationController pushViewController:[NSClassFromString(@"HHRuntimeDemoVC") new] animated:YES];
        }
        default:
            break;
    }
}

@end
