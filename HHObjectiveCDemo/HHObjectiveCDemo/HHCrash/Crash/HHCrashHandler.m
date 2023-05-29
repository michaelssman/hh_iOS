//
//  HHCrashHandler.m
//  HHCrash
//
//  Created by Michael on 2020/7/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHCrashHandler.h"
#import <execinfo.h>

static NSUncaughtExceptionHandler custom_exceptionHandler;
static NSUncaughtExceptionHandler *oldhandler;

//atomic_int HHUncaughtExceptionCount = 0;
//const int32_t HHUncaughtExceptionMaximum = 8;

@implementation HHCrashHandler

//不想崩溃 使用runloop 开一个平行空间。
//作用：保证上传的时候能够有时间上传完成（虽然也可以断点续传），比较及时
- (void)saveLive {
    NSLog(@"崩溃了");
    /**
     所有的都是items，通知，回调，timer。
     items依赖mode在runloop执行。
     */
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //把所有的mode拷贝出来
    CFArrayRef allModes = CFRunLoopCopyAllModes(runloop);
    BOOL notKill = YES;
    //app出现问题之后，会在当前线程找有没有处理问题的函数，如果找不到则直接调用exit()，导致app直接退出
    //runloop线程保活：系统发现有专门处理当前崩溃的函数的时候，当前函数重新启用了一个runloop，app重新进入循环，不能调用exit()函数，
    while (notKill) {//模拟运行循环
        for (NSString *mode in (__bridge NSArray *)allModes) {
            if ([mode isEqualToString:(NSString *)kCFRunLoopCommonModes]) {
                continue;
            }
            CFStringRef modeRef = (__bridge  CFStringRef)mode;
            CFRunLoopRunInMode((CFStringRef)modeRef, 0.0001, false);
        }
    }
    CFRelease(allModes);
}

#pragma mark - UncaughtExceptionHandler
/// 注册
void InstallUncaughtExceptionHandler(void)
{
    if(NSGetUncaughtExceptionHandler() != custom_exceptionHandler)
        oldhandler = NSGetUncaughtExceptionHandler();
    
    //参数是函数custom_exceptionHandler的地址
    //注册回调函数。 进入到自定义的函数里面进行捕捉 处理。
    //objc_setUncaughtExceptionHandler
    //设置新的异常处理函数，捕获OC异常
    NSSetUncaughtExceptionHandler(&custom_exceptionHandler);
}

// 注册回原有的
void Uninstall(void)
{
    NSSetUncaughtExceptionHandler(oldhandler);
}

/**
 异常的捕捉
 数据的分析处理
 */
void custom_exceptionHandler(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    // 组合上面的异常信息
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception name: %@\nException reason: %@\nException Stack: %@",name, reason, [stackArray componentsJoinedByString:@"\n"]];
    
    NSLog(@"%@", exceptionInfo);
    
    [HHCrashHandler saveCrash:exceptionInfo crashType:OCCrash];
    [[[HHCrashHandler alloc]init] performSelectorOnMainThread:@selector(saveLive) withObject:nil waitUntilDone:YES];
    // 注册回之前的handler
    Uninstall();
}

#pragma mark - Signal
void SignalExceptionHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc]init];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);//用于获取当前线程的函数调用堆栈，返回实际获取的指针个数
    char** strs = backtrace_symbols(callstack, frames);//从backtrace函数获取的信息转化为一个字符串数组
    for (i = 0; i < frames; ++i) {
        [mstr appendFormat:@"%s\n",strs[i]];
    }
    //保存
    [HHCrashHandler saveCrash:mstr crashType:SigCrash];
    [[[HHCrashHandler alloc]init] performSelectorOnMainThread:@selector(saveLive) withObject:nil waitUntilDone:YES];
}
//注册SIGABRT, SIGBUS, SIGSEGV等信号发生时的处理函数
//当应用发生错误而产生上述Signal后，就将会进入我们自定义的回调函数SignalExceptionHandler。为了得到崩溃时的现场信息，还可以加入一些获取CallTrace及设备信息的代码
void InstallSignalHandler(void){
    signal(SIGHUP, SignalExceptionHandler);
    signal(SIGINT, SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    signal(SIGTRAP, SignalExceptionHandler);
    signal(SIGABRT, SignalExceptionHandler);
#ifdef SIGPOLL
    signal(SIGPOLL, SignalExceptionHandler);
#endif
#ifdef SIGEMT
    signal(SIGEMT, SignalExceptionHandler);
#endif
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGKILL, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGSYS, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
    signal(SIGALRM, SignalExceptionHandler);
    signal(SIGTERM, SignalExceptionHandler);
    signal(SIGURG, SignalExceptionHandler);
    signal(SIGSTOP, SignalExceptionHandler);
    signal(SIGTSTP, SignalExceptionHandler);
    signal(SIGCONT, SignalExceptionHandler);
    signal(SIGCHLD, SignalExceptionHandler);
    signal(SIGTTIN, SignalExceptionHandler);
    signal(SIGTTOU, SignalExceptionHandler);
#ifdef SIGIO
    signal(SIGIO, SignalExceptionHandler);
#endif
    signal(SIGXCPU, SignalExceptionHandler);
    signal(SIGXFSZ, SignalExceptionHandler);
    signal(SIGVTALRM, SignalExceptionHandler);
    signal(SIGPROF, SignalExceptionHandler);
#ifdef SIGWINCH
    signal(SIGWINCH, SignalExceptionHandler);
#endif
#ifdef SIGINFO
    signal(SIGINFO, SignalExceptionHandler);
#endif
    signal(SIGUSR1, SignalExceptionHandler);
    signal(SIGUSR2, SignalExceptionHandler);
}

#pragma mark - 保存crash信息到本地
+ (void)saveCrash:(NSString *)exceptionInfo crashType:(CrashType)crashType
{
    NSString *_libPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (crashType == OCCrash) {
        [_libPath stringByAppendingPathComponent:@"OCCrash"];
    } else {
        [_libPath stringByAppendingPathComponent:@"SigCrash"];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // crash日期
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYYMMdd-HHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    exceptionInfo = [exceptionInfo stringByAppendingString:[self getAppInfo]];
    NSString *savePath = [_libPath stringByAppendingFormat:@"/Crash%@.log",dateString];
    BOOL success = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"YES success:%d",success);
}

+ (NSString *)getAppInfo
{
    NSString *appInfo = [NSString stringWithFormat:@"\nApp :%@ %@ %@\nDevice : %@\nOS Version : %@ \nUDID :%@ \nDateime:%@",
                         // 应用名
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         // 应用版本号
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         [UIDevice currentDevice].identifierForVendor,
                         [NSDate date]];
    NSLog(@"Crash!!! %@",appInfo);
    return appInfo;
}
@end
