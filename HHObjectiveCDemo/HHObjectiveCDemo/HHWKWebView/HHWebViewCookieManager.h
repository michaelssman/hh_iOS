//
//  HHWebViewCookieManager.h
//  WebViewDemo
//
//  Created by Michael on 2020/10/23.
//  Copyright © 2020 michael. All rights reserved.
//


/**
 使用同一个processPool的方法，创建了两个WKWebView，其中的一个用来加载h5，另一个专门用来加载cookie，解决了WKWebview种cookie的问题。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHWebViewCookieManager : NSObject

+ (instancetype)sharedCookieManager;

- (void)setCookieWithUrl:(NSURL *)url;

/*
 * 移除指定url下的cookie
 */
- (void)removeCookieWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
