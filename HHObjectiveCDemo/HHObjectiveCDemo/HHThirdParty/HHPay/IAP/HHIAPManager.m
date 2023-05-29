//
//  HHIAPManager.m
//  HHPayDemo
//
//  Created by FN-116 on 2021/11/26.
//

#import "HHIAPManager.h"

@implementation HHIAPManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //添加观察者
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //移除观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
#pragma mark 测试内购
- (void)testIAP {
    if ([SKPaymentQueue canMakePayments]) {
        //内购
    } else {
        NSLog(@"不允许程序内购付费");
    }
}

#pragma mark 代理
//实现观察者监听付钱的代理方法，只要交易发生变化就会走下面的方法
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    /**
     SKPaymentTransactionStatePurchasing,    正在购买
     SKPaymentTransactionStatePurchased,     已经购买
     SKPaymentTransactionStateFailed,             购买失败
     SKPaymentTransactionStateRestored,        回复购买中
     SKPaymentTransactionStateDeferred          交易还在队列里面，但最终状态还没有决定
     */
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"正在购买");
                break;
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"购买成功");
                // 购买后告诉交易队列，把这个成功的交易移除掉
                [queue finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"购买失败");
                //购买失败也要把这个交易移除掉
                [queue finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"回复购买，也叫做已经购买");
                //回复购买中也要把这个交易移除掉
                [queue finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateDeferred:
            {
                NSLog(@"交易还在队列里面，但最终状态还没有决定");
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark 提交服务器
- (void)request {
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    //转化为base64字符串
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

@end
