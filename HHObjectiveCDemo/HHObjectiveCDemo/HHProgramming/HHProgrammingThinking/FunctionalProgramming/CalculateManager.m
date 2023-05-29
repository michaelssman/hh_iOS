//
//  CalculateManager.m
//  HHProgrammingThinking
//
//  Created by Michael on 2020/9/20.
//

#import "CalculateManager.h"

@implementation CalculateManager

- (void)testFunc {
    if (self.testB) {
        self.testB(@"测试", ^(NSString * _Nonnull parm1, NSString * _Nonnull parm2) {
            NSLog(@"这里是我该做的任务，我实现 外面调用");
        });
    }
}

//参数是block block由外面实现 自己调用
//一个实现  一个调用
//不同的对象做自己的事情
- (instancetype)manager:(int (^)(int))block
{
    _result = block(_result);
    return self;
}

@end
