//
//  YYTMacros.h
//  HHObjectiveCDemo
//
//  Created by ebsinori on 16/7/19.
//  Copyright © 2016年 ebsinori. All rights reserved.
//
#import <SCM-Swift.h>

#ifndef HHMacros_h
#define HHMacros_h

//MARK: System
/// 获取系统版本
#define IOS_SYSTEM_VERSION          [[UIDevice currentDevice] systemVersion]
/// 获取的是整数，不准确。例：版本12.0.1 则会变为12
#define IOS_SYSTEM_VERSION_VALUE    [[[UIDevice currentDevice] systemVersion] floatValue]
#define APP_NAME                    [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey]
#define APP_VERSION                 [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey]


//MARK: View
#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height

/// Status bar & navigation bar height.
#define STATUS_AND_NAVIGATION_HEIGHT [UIDevice vg_navigationFullHeight]

/// Tabbar height.
#define TAB_BAR_HEIGHT [UIDevice vg_tabBarFullHeight]

/// Tabbar safe bottom margin.
#define TAB_BAR_SAFE_BOTTOM_MARGIN [UIDevice vg_safeDistance].bottom


//MARK: variables & methods
#define WEAKSELF                        __weak __typeof(self) weakSelf = self;
#define STRONGSELF                      __strong __typeof(self) strongSelf = weakSelf;
#define UserDefault                     [NSUserDefaults standardUserDefaults]
#define UserDefaultValueForKey(key)     [UserDefault valueForKey:key]
#define kFont(size)                     [UIFont systemFontOfSize:size * 5 / 9.0]
#define kBoldFont(size)                 [UIFont boldSystemFontOfSize:size * 5 / 9.0]

#pragma mark -
#pragma mark - NSLog



#ifdef DEBUG
#define HHLog(format, ...) NSLog((@"\n\n-----\n%s [Line %d]\n-----\n\n" format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define HHLog(...)
#endif

//MARK: 占位图片
#define PLACE_HOLDER_IMAGE              [UIImage imageNamed:@"placeHolder"]
//MARK: 默认头像
#define DEFAULT_AVATAR                  [UIImage imageNamed:@"avatar"]

//MARK: 通知
#define MsgInterfaceOrientation         @"interfaceOrientationNotification"

#endif /* HHMacros_h */
