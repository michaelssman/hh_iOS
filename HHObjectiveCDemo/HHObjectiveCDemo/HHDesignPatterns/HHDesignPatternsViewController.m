//
//  HHDesignPatternsViewController.m
//  HHDesignPatterns
//
//  Created by Michael on 2020/8/25.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHDesignPatternsViewController.h"
#import "StrategyViewController.h"
@interface HHDesignPatternsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *objects;

@end

@implementation HHDesignPatternsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.objects = @[@"StrategyViewController"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.objects[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[NSClassFromString(self.objects[indexPath.row]) new] animated:YES];
}

@end
