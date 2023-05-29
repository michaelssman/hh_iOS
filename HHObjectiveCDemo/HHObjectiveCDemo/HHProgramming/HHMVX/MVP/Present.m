//
//  Present.m
//  HHMVX
//
//  Created by Michael on 2020/9/16.
//  Copyright © 2020 michael. All rights reserved.
//

#import "Present.h"
@implementation Present

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

/// 加载数据
- (void)loadData
{
    NSArray *temArray =
    @[
        @{@"name":@"Gabrielle",@"imageUrl":@"http://Gabrielle",@"num":@"25"},
        @{@"name":@"James",@"imageUrl":@"http://James",@"num":@"39"},
        @{@"name":@"Gavin",@"imageUrl":@"http://Gavin",@"num":@"7"},
        @{@"name":@"Brandon",@"imageUrl":@"http://Brandon",@"num":@"16"},
        @{@"name":@"Dean",@"imageUrl":@"http://Dean ",@"num":@"6"},
        @{@"name":@"Lucien",@"imageUrl":@"http://Lucien",@"num":@"42"},
        @{@"name":@"Howell",@"imageUrl":@"http://Howell",@"num":@"30"},
        @{@"name":@"Michelle",@"imageUrl":@"http://Michelle",@"num":@"11"},
        @{@"name":@"Quella",@"imageUrl":@"http://Quella",@"num":@"51"},
        @{@"name":@"Ulrica",@"imageUrl":@"http://Ulrica ",@"num":@"61"},
    ];
    for (int i = 0; i<temArray.count; i++) {
        MVModel *m = [[MVModel alloc]init];
        [m setValuesForKeysWithDictionary:temArray[i]];
        [self.dataArray addObject:m];
    }
}

#pragma mark - PresentDelegate
//cell中有一个delegate遵循PresentDelegate，cell点击按钮的方法中调用该协议方法
- (void)didClickAddBtnWithNum:(NSString *)num indexPath:(NSIndexPath *)indexPath
{
    //操作数据，数据安全
    @synchronized (self) {
        //在这里面改变model  cell复用
        if (indexPath.row < self.dataArray.count) {
            MVModel *model = self.dataArray[indexPath.row];
            model.num = num;
        }
        
        //model改变到某值的时候 刷新UI
        if ([num intValue] > 10) {
            [self.dataArray removeAllObjects];
            NSArray *temArray =
            @[
              @{@"name":@"CC",@"imageUrl":@"http://CC",@"num":@"9"},
              @{@"name":@"James",@"imageUrl":@"http://James",@"num":@"9"},
              ];
            for (int i = 0; i<temArray.count; i++) {
                MVModel *m = [[MVModel alloc]init];
                [m setValuesForKeysWithDictionary:temArray[i]];
                [self.dataArray addObject:m];
            }
            
            // model - delegate -> UI
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadUI)]) {
                [self.delegate reloadUI];
            }
        }
    }
}

#pragma mark - LAZY
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
@end
