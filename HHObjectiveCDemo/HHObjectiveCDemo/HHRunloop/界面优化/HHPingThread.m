//
//  HHPingThread.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/9/8.
//

#import "HHPingThread.h"

@implementation HHPingThread
//
//-(instancetype)initWithThreshold:(double)threshold completion:(LLANRInfoBlock)completion{
//    self = [super init] ;
//    if(self){
//        _isApplicationActive = YES ;
//        _semaphore = dispatch_semaphore_create(0) ;
//        _threshold = threshold ;
//        _completion = completion ;
//        _isMainThreadANR = NO ;
//        _stackInfo = @"" ;
//        _startPingTime = 0.0 ;
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil] ;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil] ;
//    }
//    return self ;
//}
//
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
//}
//
//-(void)main{
//    //处理ANR的block
//    __weak typeof(self) weakSelf = self ;
//    void (^handleANR)(void) = ^(){
//        __strong typeof(weakSelf) strongSelf = weakSelf ;
//        if([strongSelf.stackInfo isEqualToString:@""]){
//
//        }else{
//            if(strongSelf.completion){
//                double currentTime = floor([[NSDate date] timeIntervalSince1970] * 1000) ;
//                double duration = (currentTime - strongSelf.startPingTime) / 1000.0 ;
//
//                strongSelf.completion(@{
//                                        @"stackSymbols":strongSelf.stackInfo,
//                                        @"duration":[NSString stringWithFormat:@"%.2f",duration]
//                                        }) ;
//            }
//            strongSelf.stackInfo = @"" ;
//        }
//    };
//
//    while(!self.cancelled){
//        if(_isApplicationActive){
//            self.isMainThreadANR = YES ;
//            self.stackInfo = @"" ;
//            self.startPingTime = floor([[NSDate date] timeIntervalSince1970] * 1000) ;
//
//            //如果主线程未阻塞，会执行该代码
//            dispatch_async(dispatch_get_main_queue(),^{
//                self.isMainThreadANR = NO ;
//                dispatch_semaphore_signal(self.semaphore) ;
//            });
//
//            //线程休眠
//            [NSThread sleepForTimeInterval:self.threshold] ;
//
//            //主线程卡顿
//            if(self.isMainThreadANR){
//                self.stackInfo = [BSBacktraceLogger bs_backtraceOfMainThread] ;
//                handleANR() ;
//            }
//
//            //主线程卡顿，等待唤醒
//            dispatch_wait(self.semaphore, DISPATCH_TIME_FOREVER) ;
//
//        }else{
//            [NSThread sleepForTimeInterval:self.threshold] ;
//        }
//    }
//}
//
//
//#pragma mark - Notification
//- (void)applicationDidBecomeActive{
//    _isApplicationActive = YES ;
//}
//
//- (void)applicationDidEnterBackground{
//    _isApplicationActive = NO ;
//}

@end
