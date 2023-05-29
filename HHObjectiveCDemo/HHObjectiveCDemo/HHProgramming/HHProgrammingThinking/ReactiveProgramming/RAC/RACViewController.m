//
//  RACViewController.m
//  HHMVX
//
//  Created by FN-116 on 2021/11/3.
//  Copyright © 2021 michael. All rights reserved.
//

#import "RACViewController.h"
#import "RACView.h"
#import <ReactiveObjC.h>//面向信号
#import <NSObject+RACKVOWrapper.h>
@interface RACViewController ()
@property (nonatomic, assign)int time;
@property (nonatomic, strong)RACDisposable *disposable;

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [self RACSignal_takeUntil];
    
    
    NSLog(@"RAC测试：");
    [self RACSignalTest];
}

#pragma mark - RACSignal
- (void)RACSignalTest {
    /**
     核心：信号类
     信号类作用：只要有数据改变，就会把数据包装成一个信号，传递出去
     只要有数据改变，就会有信号发出。
     数据发出，并不是信号类发出。
     
     1. 创建信号类createSignal:didsubscriber(block)
     RACDisposable
     RACSubscriber
     
     
     创建createSignal方法：
     1. 创建RACDynamicSignal
     2. 把didSubscribe保存到RACDynamicSignal
     */
    
    //1、创建信号量 coldSignal
   RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       //block调用时刻：当信号被订阅的时候就会调用
       //block作用：描述当前信号哪些数据需要发送
       //发送数据
       NSLog(@"调用了didsubscriber");
       NSLog(@"创建信号量");
       
       //3 发送信号 传递数据出去
       [subscriber sendNext:@"michael"];//调用订阅者的nextBlock
       //3.1 发送完成信号，并取消订阅
       [subscriber sendCompleted];
       //3.2 发送失败信号
       NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:18 userInfo:@{@"key":@"请求网络失败"}];
       [subscriber sendNext:error];
       
       NSLog(@"那我啥时候运行");
       //4、销毁当前信号，用于取消订阅时清理资源用，比如释放一些资源
       return [RACDisposable disposableWithBlock:^{
           NSLog(@"RACDisposable");
       }];
    }];
    
//    RACSignal使用步骤
//    1. 创建信号
//    2. 订阅信号
    /**
     RACSignal底层实现
     1.当一个信号被订阅，创建订阅者，并且把nextBlock保存到订阅者里面
     2.[RACDynamicSignal subscribe:RACSubscriber]
     3.调用RACDynamicSignal的didSubscribe
     4.[subscriber sendNext:@1]
     5.拿到订阅者的nextBlock调用
     */

    /**
     subscribeNext
     1. 创建订阅者
     2. 把nextBlock保存到订阅者里面
     */
    //2、订阅信号量 hotSignal被订阅了才会变成热信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        //block：只要信号内部发送数据，就会调用这个block
        NSLog(@"%@",x);
    }];
    //主动出发取消订阅
    [disposable dispose];
    
    //2.2 订阅错误信号 发送的时候会传一个error
    [signal subscribeError:^(NSError * _Nullable error) {
        NSLog(@"error");
    }];
    //2.3 订阅完成信号
    [signal subscribeCompleted:^{
        NSLog(@"completed");
    }];

}

#pragma mark -
- (void)RACSignal_takeUntil {
    // 组合操作——takeUntil：
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      [subscriber sendNext:@11];
      [subscriber sendNext:@12];
      [subscriber sendNext:@13];
      [subscriber sendNext:@14];
      [subscriber sendNext:@15];
      [subscriber sendCompleted];
      return [RACDisposable disposableWithBlock:^{
          NSLog(@"signalA完成");
      }];
    }];

    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      return [RACDisposable disposableWithBlock:^{
          [subscriber sendNext:@23];
          [subscriber sendNext:@24];
          [subscriber sendNext:@25];
          NSLog(@"signalB完成");
      }];
    }];
    [signalB subscribeNext:^(id x) {
      NSLog(@"subscribeNextB:%@",x);
    }];

    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendNext:@33];
//        [subscriber sendNext:@34];
//        [subscriber sendNext:@35];
      return [RACDisposable disposableWithBlock:^{
          NSLog(@"signalC完成");
      }];
    }];
    [signalC subscribeNext:^(id x) {
      NSLog(@"subscribeNextC:%@",x);
    }];

    RACSignal *signalD = [[signalA takeUntil:signalB] takeUntil:signalC];

    [[signalD subscribeNext:^(id x) {
      NSLog(@"subscribeNextD:%@",x);
    }] dispose];
}

#pragma mark - RACSubject
- (void)RACSubjectDemo {
    //1 创建信号
    RACSubject *subject = [RACSubject subject];
    //2 订阅信号 订阅信号和响应代码在一起 可读性更强
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1%@",x);
    }];
    //3 发送数据
    [subject sendNext:@"发送数据第一个"];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2%@",x);
    }];
    [subject sendNext:@"第二次发送数据"];
}

#pragma mark - RACReplaySubjectTest
- (void)RACReplaySubjectTest {
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@"我先发送数据了，等你接受哦"];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - 基本用法
- (void)RACTest {
    //监听方法
    RACView *v = [[RACView alloc]initWithFrame:CGRectMake(100, 300, 150, 80)];
    [self.view addSubview:v];
    [v.btnClickSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [[v rac_signalForSelector:@selector(testRACView:par:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"我检测到了视图方法的调用%@",x);//x是集合 参数可能有多个
    }];
    
    //通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"%@",x);
    }];
    
    //监听textfield输入
    UITextField *textField = [[UITextField alloc]init];
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - observer
- (void)observerText {
    RACView *v = [[RACView alloc]initWithFrame:CGRectMake(100, 300, 150, 80)];

    //监听属性 KVO
    //    方法一 第二次调用
    [v rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"1 - %@",value);
    }];
    //    方法二 第一次就会调用，苹果自带的kvo也会调用
    [[v rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 - %@",x);
    }];
    //    方法三 只要这个对象的属性一改变就会产生信号
    [RACObserve(v, frame) subscribeNext:^(id  _Nullable x) {
        NSLog(@"3 - %@",x);
    }];
    
    v.frame = CGRectMake(100, 400, 150, 100);
}

#pragma mark - timer
- (void)timerDemo {
    //timer
    [[RACSignal interval:1.0 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
            NSLog(@"%@---%@",x,[NSThread currentThread]);
    }];
}

#pragma mark - 宏
- (void)textMac {
    UILabel *lab = [UILabel new];
    UITextField *tf = [UITextField new];
    //用来给某个对象的某个属性绑定信号。只要产生信号内容，就会把内容给属性赋值。
    RAC(lab,text) = tf.rac_textSignal;
}
- (void)daojishi:(UIButton *)sender {
    sender.enabled = NO;
    self.time = 10;
    //验证码倒计时
    @weakify(self);
   self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
       @strongify(self);
        //设置文本
        if (self.time > 0) {
            sender.enabled = NO;
            [sender setTitle:[NSString stringWithFormat:@"请等待%d秒",self.time] forState:UIControlStateDisabled];
        } else {
            sender.enabled = YES;
            [sender setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
            [self.disposable dispose];
        }
        self.time--;
    }];
}

#pragma mark - RACMulticastConnection
- (void)RACMulticastConnectionTest {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送网络请求");
        [subscriber sendNext:@"得到网络请求数据"];
        return nil;
    }];
    //普通的订阅
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1 - %@",x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 - %@",x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"3 - %@",x);
    }];
    
    //MulticastConnection
    RACMulticastConnection *connect = [signal publish];
    [connect.signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"11 - %@",x);
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"22 - %@",x);
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"33 - %@",x);
    }];
    [connect connect];
}

#pragma mark - 过滤
- (void)takeUntilDemo {
    RACSubject *subject = [RACSubject subject];
    RACSubject *subject1 = [RACSubject subject];
    [[subject takeUntil:subject1] subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
    }];
    [subject1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    
//    [subject1 sendNext:@"stop"];
    [subject1 sendCompleted];

    [subject sendNext:@"4"];
    [subject sendNext:@"5"];

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
