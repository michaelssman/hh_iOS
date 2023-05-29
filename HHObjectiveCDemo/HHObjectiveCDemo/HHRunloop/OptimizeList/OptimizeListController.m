//
//  OptimizeListController.m
//  HHRunloop
//
//  Created by Michael on 2021/3/30.
//  Copyright © 2021 michael. All rights reserved.
//

#import "OptimizeListController.h"

//定义一个block
typedef BOOL(^RunloopBlock)(void);
@interface OptimizeListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

/// 存放任务的数组
@property (nonatomic, strong)NSMutableArray *tasks;

/// 任务标记
@property (nonatomic, strong)NSMutableArray *tasksKeys;

/// 最大任务数
@property (nonatomic, assign)NSUInteger max;

@end

@implementation OptimizeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpConfig];
    [self tableView];
}
- (void)setUpConfig
{
    _max = 2000;
    _tasks = [NSMutableArray array];
    _tasksKeys = [NSMutableArray array];
    
    //注册监听
    [self addRunLoopObserver];
}
#pragma mark lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}
#pragma mark tableView delegate & dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 380;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    lab.textColor = [UIColor blackColor];
    lab.text = [NSString stringWithFormat:@"%ld凤凰大厦空腹喝点酒",(long)indexPath.row];
    [cell.contentView addSubview:lab];
    
    
    //不要直接加载图片！！ 将加载图片的代码都给RunLoop！
    [self addTask:^BOOL{
        [OptimizeListController addImage1With:cell];
        return YES;
    } withKey:indexPath];
    [self addTask:^BOOL{
        [OptimizeListController addImage2With:cell];
        return YES;
    } withKey:indexPath];
    [self addTask:^BOOL{
        [OptimizeListController addImage3With:cell];
        return YES;
    } withKey:indexPath];
    return cell;
}

#pragma mark - cell
+ (void)addImage1With:(UITableViewCell *)cell
{
    //第一张
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 85, 85)];
    imageView.tag = 1;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut |UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}
+ (void)addImage2With:(UITableViewCell *)cell
{
    //第二张
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 50, 85, 85)];
    imageView.tag = 2;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut |UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}
+ (void)addImage3With:(UITableViewCell *)cell
{
    //第二张
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 50, 85, 85)];
    imageView.tag = 3;
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut |UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
}

#pragma mark - 添加任务
- (void)addTask:(RunloopBlock)unit
        withKey:(id)key
{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    //保证之前没有显示出来的任务，不再浪费时间加载
    if (self.tasks.count > self.max) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}

/// 这里面都是C语言，添加一个监听者
- (void)addRunLoopObserver
{
    //获取当前的RunLoop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    //初始化runloop观察者上下文结构体，为创建观察者准备。
    /**
     typedef struct {
     CFIndex    version;
     void *    info;
     const void *(*retain)(const void *info);
     void    (*release)(const void *info);
     CFStringRef    (*copyDescription)(const void *info);
     } CFRunLoopObserverContext;
     */
    CFRunLoopObserverContext context = {
        0,
        (__bridge  void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    //定义一个runloop观察者，当runloop进入等待前（滑动结束，没有任何操作的时候），进行监听
    static CFRunLoopObserverRef defaultModeObserver;
    //创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL,
                                                  kCFRunLoopBeforeWaiting,
                                                  YES,
                                                  NSIntegerMax - 999,
                                                  &Callback,
                                                  &context);
    
    //添加当前runloop的观察者
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
    
    //c语言有create就需要release
    CFRelease(defaultModeObserver);
}

//回调函数，runloop中事件的执行体，只要监测到对应的runloop状态，该函数就会得到响应
//定义一个回调函数，一次RunLoop来一次
static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    OptimizeListController *vc = (__bridge  OptimizeListController *)(info);
    if (vc.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && vc.tasks.count) {
        //取出任务
        RunloopBlock unit = vc.tasks.firstObject;
        //执行任务
        result = unit();
        //干掉第一个任务
        [vc.tasks removeObjectAtIndex:0];
        //干掉标示
        [vc.tasksKeys removeObjectAtIndex:0];
    }
}

@end
