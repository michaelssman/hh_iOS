//
//  WKProcessPool+ShareProcessPool.h
//  WebViewDemo
//
//  Created by Michael on 2020/10/28.
//  Copyright © 2020 michael. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKProcessPool (ShareProcessPool)
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
