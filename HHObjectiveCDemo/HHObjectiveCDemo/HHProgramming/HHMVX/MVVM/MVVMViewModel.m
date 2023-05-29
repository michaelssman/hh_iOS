//
//  MVVMViewModel.m
//  HHMVX
//
//  Created by Michael on 2020/9/16.
//  Copyright © 2020 michael. All rights reserved.
//

#import "MVVMViewModel.h"
#import <ReactiveObjC.h>
@implementation MVVMViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [RACObserve(self, contentKey) subscribeNext:^(id  _Nullable x) {
            NSArray *array = @[@"反倒是",@"是反倒是",@"好",@"刚发的",@"金银潭",@"收费的",@"但是风格",@"让太阳"];
            NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
            //线程不安全。线程异步。多线程 资源抢夺的情况
            @synchronized (mArray) {
                [mArray removeObject:x];
                if (self.successBlock) {
                    self.successBlock(mArray);
                }
            }
        }];
    }
    return self;
}


/// 加载数据（本地数据、网络请求）
- (void)loadData
{
    //数据异步  session afn manager
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSArray *array = @[@"反倒是",@"是反倒是",@"好",@"刚发的",@"金银潭",@"收费的",@"但是风格",@"让太阳"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.successBlock) {
                self.successBlock(array);
            }
        });
    });
}

@end
