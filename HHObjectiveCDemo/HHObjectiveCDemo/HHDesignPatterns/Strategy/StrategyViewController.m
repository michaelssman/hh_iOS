//
//  StrategyViewController.m
//  HHDesignPatterns
//
//  Created by Michael on 2020/8/25.
//  Copyright © 2020 michael. All rights reserved.
//

#import "StrategyViewController.h"
#import "NSObject+Invocation.h"
#import "TableViewCellOne.h"
#import "TableViewCellTwo.h"
#import "TableViewCellThree.h"
#import "TableViewCellFour.h"
#define kCellClass  @"kCellClass"
#define kCellIdentifier @"kCellIdentifier"
@interface StrategyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong)NSDictionary *strategy_cell;
@end

@implementation StrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - test1
- (void)test1
{
    NSInvocation *invocation = [self.strategyDic valueForKey:@"400"];
    [invocation invoke];
}
//将所有的情况进行整合
- (NSDictionary *)strategyDic
{
    NSDictionary *strategyDic = @{
        @"100":[self invocationWithSelector:@selector(playAction)],
        @"200":[self invocationWithSelector:@selector(eatAction)],
        @"300":[self invocationWithSelector:@selector(runAction)],
        @"400":[self invocationWithSelector:@selector(sleepAction:) withObjects:@[@"ddddddd"]],
        @"500":[self invocationWithSelector:@selector(shoppingAction)]
    };
    return strategyDic;
}

- (void)playAction
{
    NSLog(@"playAction");
}
- (void)eatAction
{
    NSLog(@"eatAction");
}
- (void)runAction
{
    NSLog(@"runAction");
}
- (void)sleepAction:(NSString *)arg
{
    NSLog(@"sleepAction--- %@",arg);
}
- (void)shoppingAction
{
    NSLog(@"shoppingAction");
}


#pragma mark test2 tableView不同cell
- (NSMutableArray *)objects
{
    if (!_objects) {
        self.objects = [NSMutableArray arrayWithObjects:@"100",@"200",@"300",@"200",@"400",@"500",@"300",@"200",@"200",@"100",@"100",@"100",@"100", nil];
    }
    return _objects;
}
- (NSDictionary *)strategy_cell
{
    if (!_strategy_cell) {
        self.strategy_cell = @{
            @"100":@{kCellIdentifier : @"TableViewCellOne", kCellClass : [TableViewCellOne class]},
            @"200":@{kCellIdentifier : @"TableViewCellTwo", kCellClass : [TableViewCellTwo class]},
            @"300":@{kCellIdentifier : @"TableViewCellThree", kCellClass : [TableViewCellThree class]},
            @"400":@{kCellIdentifier : @"TableViewCellFour", kCellClass : [TableViewCellFour class]},
            @"500":@{kCellIdentifier : @"TableViewCellBase", kCellClass : [TableViewCellBase class]}
        };
    }
    return _strategy_cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.tableFooterView = [UIView new];
        for (NSDictionary *dic in [self strategy_cell].allValues) {
            [self.tableView registerClass:dic[kCellClass] forCellReuseIdentifier:dic[kCellIdentifier]];
        }
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}
#pragma mark tableView delegate & dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self strategy_cell][self.objects[indexPath.row]][kCellClass] heightWithModel:@""];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInvocation *invocation = [self.strategy_cell valueForKey:self.objects[indexPath.row]];
//    [invocation setArgument:(&tableView) atIndex:2];
//    [invocation setArgument:(&indexPath) atIndex:3];
//    [invocation invoke];
//    id res = nil;
//    [invocation getReturnValue:(&res)];
//    return res;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self strategy_cell][self.objects[indexPath.row]][kCellIdentifier] forIndexPath:indexPath];
    NSLog(@"ccc--%@",[self strategy_cell]);
    return cell;
}

//- (UITableViewCell *)cell1WithTable:(UITableView *)tableView
//                         indexPath:(NSIndexPath *)indexPath
//{
//    TableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld",(long)indexPath.section,(long)indexPath.row];
//    cell.contentView.backgroundColor = [UIColor redColor];
//    return cell;
//}
//- (UITableViewCell *)cell2WithTable:(UITableView *)tableView
//                         indexPath:(NSIndexPath *)indexPath
//{
//    TableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld",(long)indexPath.section,(long)indexPath.row];
//    return cell;
//}
//- (UITableViewCell *)cell3WithTable:(UITableView *)tableView
//                         indexPath:(NSIndexPath *)indexPath
//{
//    TableViewCellThree *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld",(long)indexPath.section,(long)indexPath.row];
//    return cell;
//}
//- (UITableViewCell *)cell4WithTable:(UITableView *)tableView
//                         indexPath:(NSIndexPath *)indexPath
//{
//    TableViewCellFour *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld",(long)indexPath.section,(long)indexPath.row];
//    return cell;
//}
//- (UITableViewCell *)cell5WithTable:(UITableView *)tableView
//                         indexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld",(long)indexPath.section,(long)indexPath.row];
//    return cell;
//}

@end
