//
//  ChainProgrammingController.m
//  HHProgrammingThinking
//
//  Created by Michael on 2020/9/21.
//  链式编程

///方法调用使用.语法
///返回自己才可以一直继续.下去
///想要传参，返回block，block带参数
///方法是一个没有参数，返回值是一个block（block可以带参数，block的返回值是调用者自己）。

#import "ChainProgrammingController.h"
#import "Masonry.h"

@interface HHPerson1 : NSObject
@end
@implementation HHPerson1
@end

@interface ChainProgrammingController ()

@end

@implementation ChainProgrammingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     self.where.selectTable返回值是一个block
     self.where.selectTable(@"hhhhh")相当于调用了block，执行block的代码
     使用block返回，而不是传一个参数，因为方法传参数就违背了getter方法本质，getter方法没有参数。
     所以使用block进行回调，通讯。
     */
    self.where.blockWithParamReturnSelf(@"hhhhh").selectTable(@"fdjl");//make.left.mas_equalTo(100);类似
    
    //源码 - 恐惧
    /**
     为什么可以mas_makeConstraints，因为view没有这个方法。用分类扩展功能，让开发更简洁便捷。
     */
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        //处理约束
        //MASViewConstraint
        make.left.top.height.width.mas_equalTo(100);
    }];
    
    
    //面试
    NSLog(@"%d  -- %d",[[HHPerson1 class] isKindOfClass:[HHPerson1 class]],[[NSObject class] isKindOfClass:[NSObject class]]);

}

// 可以一直点下去，需要返回自己
- (ChainProgrammingController *)where {
    NSLog(@"%s",__func__);
    return self;
}

- (void(^)(NSString *))selectTable {
    //通过调用block就把参数传递了进来。
    //block可以保存代码。
    NSLog(@"%s",__func__);
    void(^block)(NSString *) = ^(NSString *word){
        NSLog(@"123 - %@",word);
    };
    return block;
}


- (ChainProgrammingController *(^)(NSString *))blockWithParamReturnSelf {
    //通过调用block就把参数传递了进来。
    //block可以保存代码。
    NSLog(@"%s",__func__);
    ChainProgrammingController *(^block)(NSString *) = ^(NSString *word){
        NSLog(@"123 - %@",word);
        return self;
    };
    return block;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
