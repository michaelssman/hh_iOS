//
//  HHProgrammingViewController.m
//  HHMVX
//
//  Created by Michael on 2020/9/16.
//  Copyright © 2020 michael. All rights reserved.
//

#import "MVVMViewController.h"
#import "MVVMViewModel.h"
static void *VMObjects = &VMObjects;
@interface MVVMViewController ()
@property (nonatomic, strong)MVVMViewModel *vm;
@end

@implementation MVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.vm = [[MVVMViewModel alloc]init];
    [self.vm initWithBlock:^(id  _Nonnull data) {
//        NSArray *array = data;
        //数据绑定
        //更新数据源
        //刷新UI
    } fail:nil];
    
    //加载数据
    [self.vm loadData];
    //数据改变。刷新UI
    [self.vm addObserver:self forKeyPath:@"objects" options:NSKeyValueObservingOptionNew context:VMObjects];
}

- (void)reloadUI
{
    //重新赋值dataSOurce
    //刷新UI
}

#pragma mark - 观察者响应
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == VMObjects) {
        [self reloadUI];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
