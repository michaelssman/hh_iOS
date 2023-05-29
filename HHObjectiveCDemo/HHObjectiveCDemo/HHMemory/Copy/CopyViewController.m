//
//  CopyViewController.m
//  HHMemoryDemo
//
//  Created by michael on 2021/10/19.
//  Copyright © 2021 michael. All rights reserved.
//

#import "CopyViewController.h"
#import "LMDataSource.h"

@interface CopyViewController ()<UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong) LMDataSource *dataSource;

@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataSource = [[LMDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, NSString *model, NSIndexPath *indexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = model;
    }];
    [self.dataSource addDataArray:self.objects];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.dataSource;

}

//不可变数组进行copy，不会开辟新的内存空间，生成一个不可变对象，指向同一个数组。
- (void)array_Copy {
    NSArray *normalArray = [[NSArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    id tempArray = [normalArray copy];
    [tempArray isKindOfClass:[NSMutableArray class]] ? NSLog(@"array的copy是可变数组"):NSLog(@"array的copy是不可变数组");
}

//可变数组进行copy，会开辟新的内存空间，生成一个新的不可变数组，两个数组之间不受任何影响。
- (void)mutableArray_Copy {
    NSMutableArray *normalArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    id tempArray = [normalArray copy];
    [tempArray isKindOfClass:[NSMutableArray class]] ? NSLog(@"mutableArray的copy是可变数组"):NSLog(@"mutableArray的copy是不可变数组");
    normalArray[0] = @"1000";//修改数组元素
//    tempArray[0] = @"2000";//修改数组元素 崩溃
    NSLog(@"normalArray内存地址 = %p",normalArray);
    NSLog(@"tempArrayOne内存地址 = %p",tempArray);
    NSLog(@"normalArray = %@",normalArray);
    NSLog(@"tempArrayOne = %@",tempArray);
}

- (void)array_MutableCopy {
    NSArray *normalArray = [[NSArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    id tempArray = [normalArray mutableCopy];
    [tempArray isKindOfClass:[NSMutableArray class]] ? NSLog(@"tempArrayOne可变数组"):NSLog(@"tempArrayOne不可变数组");
    tempArray[0] = @"1000";//改变数组
    NSLog(@"normalArray = %@",normalArray);
    NSLog(@"tempArrayOne = %@",tempArray);
    NSLog(@"normalArray内存地址 = %p",normalArray);
    NSLog(@"tempArrayOne内存地址 = %p",tempArray);
}

- (void)mutableArray_MutableCopy {
    NSMutableArray *normalArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    id tempArrayOne = [normalArray mutableCopy];
    [tempArrayOne isKindOfClass:[NSMutableArray class]] ? NSLog(@"tempArrayOne可变数组"):NSLog(@"tempArrayOne不可变数组");
    normalArray[0] = @"1000";
    NSLog(@"normalArray = %@",normalArray);
    NSLog(@"normalArray内存地址 = %p",normalArray);
    NSLog(@"tempArrayOne = %@",tempArrayOne);
    NSLog(@"tempArrayOne内存地址 = %p",tempArrayOne);
}

- (void)arrayCopy {
    NSMutableArray *mA = [NSMutableArray arrayWithObjects:@"aa",@"ss",@"dd", nil];
    NSArray *a = [mA copy];
    [mA addObject:@"gg0"];
    mA = [NSMutableArray arrayWithObjects:@"dd", nil];
    [mA addObject:@"gg1"];
    NSLog(@"mA:%@ \n a:%@",mA,a);
}

#pragma mark lazy load
- (NSMutableArray *)objects {
    if (!_objects) {
        self.objects = [NSMutableArray arrayWithObjects:@"array_Copy",@"mutableArray_Copy",@"array_MutableCopy",@"mutableArray_MutableCopy",@"arrayCopy", nil];
    }
    return _objects;
}
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
#pragma mark tableView delegate & dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:NSSelectorFromString(self.objects[indexPath.row])];
}

@end
