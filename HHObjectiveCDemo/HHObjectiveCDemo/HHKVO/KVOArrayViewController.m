//
//  ViewController.m
//  KVO_Array
//
//  Created by laouhn on 15/11/26.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "KVOArrayViewController.h"

@interface KVOArrayTestPersonModel : NSObject
@property (nonatomic, copy)NSString *name;
@end
@implementation KVOArrayTestPersonModel

@end

@interface KVOArrayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)UITableView *tableV;
@end

@implementation KVOArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.array = [@[@"sdf",@"sdafgf"] mutableCopy];
    self.array = [NSMutableArray array];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addArrayAcion:)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    
    //如果想监听一个数组的变化,需要重写系统自动生成的两个方法-插入和删除,而且两个方法必须同时写.这样数组内容发生改变的时候才会走监听的方法.
    [self addObserver:self forKeyPath:@"array" options:NSKeyValueObservingOptionNew context:NULL];
    //布局
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    [self.view addSubview:_tableV];
    
}

#pragma mark - 数组修改方法
- (void)addArrayAcion_:(UIButton *)sender {
//    [self.array addObject:@[@"fgs"]];
    //通过mutableArrayValueForKeyPath 方法可以不用重写他的 增删改的方法.当数据发生改变的时候 也能触发KVO的方法.
    [[self mutableArrayValueForKeyPath:@"array"] addObject:@"111"];
}


//重写替换方法
- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)object {
    [self.array replaceObjectAtIndex:index withObject:object];
}

//重写删除方法
- (void)removeObjectFromArrayAtIndex:(NSUInteger)index {
    [self.array removeObjectAtIndex:index];
}

//重写插入方法  id 不带 *
- (void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index {
    //拿出这个方法  重写
    [self.array insertObject:object atIndex:index];
}
//kvo监听到数据变化时走的方法. 他和添加监听者是成对出现的.  一定不要拉下
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"%@",change);
    
    int kind = [change[NSKeyValueChangeKindKey] intValue];
    if (kind == NSKeyValueChangeInsertion) {
        //插入数据
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.array.count - 1 inSection:0];
        [self.tableV insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        //自动滚到最后一条
        [self.tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else if (kind == NSKeyValueChangeRemoval) {
        //删除
        NSIndexSet *set = change[NSKeyValueChangeIndexesKey];
        __block NSIndexPath *indexPath = nil;
        [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            //这个idx 就是选取的那个row,
            indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        }];
        [self.tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    } else {
        //改
        NSIndexSet *set = change[NSKeyValueChangeIndexesKey];
        __block NSIndexPath *indexPath = nil;
        [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        }];
        [self.tableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}
- (void)addArrayAcion:(UIBarButtonItem *)sender {
    NSLog(@"+1");
    KVOArrayTestPersonModel *per = [[KVOArrayTestPersonModel alloc]init];
    int num = arc4random()%52;
    per.name = [NSString stringWithFormat:@"虎哥%d号",num];
    [self insertObject:per inArrayAtIndex:self.array.count];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indifer];
    }
    KVOArrayTestPersonModel *p = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",p.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KVOArrayTestPersonModel *p = [[KVOArrayTestPersonModel alloc]init];
    p.name = @"🐅";
    [self replaceObjectInArrayAtIndex:indexPath.row withObject:p];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据
        [self removeObjectFromArrayAtIndex:indexPath.row];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
