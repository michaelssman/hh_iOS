//
//  WKProcessPool+ShareProcessPool.m
//  WebViewDemo
//
//  Created by Michael on 2020/10/28.
//  Copyright © 2020 michael. All rights reserved.
//

#import "WKProcessPool+ShareProcessPool.h"

@implementation WKProcessPool (ShareProcessPool)
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
@end
