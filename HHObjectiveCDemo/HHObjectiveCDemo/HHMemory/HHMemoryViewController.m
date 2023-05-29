//
//  HHMemoryViewController.m
//  HHMemoryDemo
//
//  Created by Michael on 2020/8/23.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHMemoryViewController.h"
#import "Copy/CopyViewController.h"
@interface HHMemoryViewController ()
@property(copy) NSArray *a ;
@end

@implementation HHMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.a = [NSArray new];
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(self.a)));//-1
    
    NSArray *b = self.a;
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(self.a)));//-1

    NSArray *c = self.a.copy;
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(self.a)));//-1

    NSArray *d = self.a.mutableCopy;
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(self.a)));//-1

    NSLog(@"----------------");
    
    self.a = @[@"sdf"];
    
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(self.a)));//2
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(b)));//-1
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(c)));//-1
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(d)));//1

  [self test];
}
- (void)test {
    NSObject *a = [NSObject new];
    __weak NSObject *b = [NSObject new];
    __strong NSObject *c = [NSObject new];
    UIImage *d = [UIImage imageNamed:@""];
    
    //打印b和d的引用计数，会崩溃
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(a)));
//    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(b)));
    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(c)));
//    NSLog(@"%ld",(long)CFGetRetainCount((__bridge CFTypeRef)(d)));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[CopyViewController new] animated:YES];
}
@end
