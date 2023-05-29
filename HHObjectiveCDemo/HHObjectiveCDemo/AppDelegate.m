//
//  AppDelegate.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2021/12/30.
//

#import "AppDelegate.h"
#import "HHStartOptimization/AppLaunchTime.h"
#import "HHCrashHandler.h"
#import "HHRunloop/界面优化/LGBlockMonitor.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

//当程序第一次运行并且将要显示窗口的时候执行，在该方法中我们完成的操作（1）创建一个窗口对象，并且将窗口对象指定为程序的主窗口。（2）我们写的代码也在该方法中。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    InstallUncaughtExceptionHandler();
    InstallSignalHandler();
    [AppLaunchTime mark];
    [[LGBlockMonitor sharedInstance] start];
//    [self setUpJPushWithLaunchOptions:launchOptions];
    return YES;
}

//程序进入后台的时候首先执行程序将要取消活跃该方法。
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //在该方法中我们经常用来暂停正在执行的任务，让时间计时器失效。如果是游戏需要暂停游戏的运行。
        NSLog(@"%s  %d", __FUNCTION__,__LINE__);
}

//该方法当应用程序进入后台的时候调用
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //在该方法中经常用来释放一些公共资源，保存用户数据，使时间计时器失效，保存足够的状态信息用来恢复应用程序之前的状态。
    //当应用程序支持后台运行的时候，该方法会取代applicationWillTerminate:方法
    NSLog(@"%s  %d",__FUNCTION__,__LINE__);
}

//当程序进入将要前台的时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //该方法中我们经常用来取消在程序进入后台的时候执行的操作。
    NSLog(@"%s  %d",__FUNCTION__,__LINE__);
}

//应用程序已经变得活跃（应用程序的运行状态）
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //重启之前暂停或者之前根本没有运行的任务。如果程序之前在后台，必要的时候需要做界面的刷新操作。
    NSLog(@"%s  %d",__FUNCTION__,__LINE__);
}

//当程序将要退出的时候调用，如果应用程序支持后台运行，该方法被applicationDidEnterBackground:替换
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s   %d",__FUNCTION__,__LINE__);
}

#pragma mark - JPush
#pragma mark 注册 APNs 成功并上报 DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /*
     温馨提示：
     JPush 3.0.9 之前的版本，必须调用此接口，注册 token 之后才可以登录极光，使用通知和自定义消息功能。
     从 JPush 3.0.9 版本开始，不调用此方法也可以登录极光。但是不能使用 APNs 通知功能，只可以使用 JPush 自定义消息。
     */
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
/// 实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark app已经打开在前台运行的时候，接收到通知之后会走下面方法：
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
