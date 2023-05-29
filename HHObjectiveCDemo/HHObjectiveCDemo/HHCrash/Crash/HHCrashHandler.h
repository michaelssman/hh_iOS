//
//  HHCrashHandler.h
//  HHCrash
//
//  Created by Michael on 2020/7/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CrashType) {
    OCCrash = 0,
    SigCrash = 1,
};

@interface HHCrashHandler : NSObject

@end

//注册 最好在appdelegate里注册，整个项目都可以捕获。
void InstallUncaughtExceptionHandler(void);

void InstallSignalHandler(void);

NS_ASSUME_NONNULL_END
