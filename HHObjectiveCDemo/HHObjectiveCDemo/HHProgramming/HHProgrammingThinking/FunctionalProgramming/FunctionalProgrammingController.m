//
//  FunctionalProgrammingController.m
//  HHProgrammingThinking
//
//  Created by Michael on 2020/9/20.
//

#import "FunctionalProgrammingController.h"
#import "CalculateManager.h"
@interface FunctionalProgrammingController ()

@end

@implementation FunctionalProgrammingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CalculateManager *m = [[CalculateManager alloc]init];
    int a = [[m manager:^int(int result) {
        result += 10;
        result *= 2;
        return result;
    }] result];
    NSLog(@"%d",a);
    
    m.testB = ^(NSString * _Nonnull testBParm, HHBlock  _Nonnull hhblock) {
        NSLog(@"我先做我该做的事情");
        NSLog(@"做事情中...");
        NSLog(@"我做完了");
        //调方法 传需要的参数
        hhblock(@"给你参数1",@"给你参数2");
    };
    
    [m testFunc];
    
    [self block_test:^NSString *(NSString *par) {
        NSLog(@"传的参数%@",par);
        return par;
    }];
}
- (void)block_test:(NSString * (^)(NSString *par))blck {
    NSLog(@"block_test打印block的返回值：%@",blck(@"dddd"));
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
