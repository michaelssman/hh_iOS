//
//  HHWebViewCookieManager.m
//  WebViewDemo
//
//  Created by Michael on 2020/10/23.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHWebViewCookieManager.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKHTTPCookieStore.h>
#import "WKProcessPool+ShareProcessPool.h"
@interface HHWebViewCookieManager ()
@property (nonatomic, strong)WKWebView *cookieWebView;
@property (nonatomic, copy)NSString *webviewCookie;
@property (nonatomic, strong)NSMutableArray *cookieURLs;
@end

@implementation HHWebViewCookieManager

+ (instancetype)sharedCookieManager {
    static HHWebViewCookieManager *sharedCookieManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedCookieManager) {
            sharedCookieManager = [[self alloc] init];
        }
    });
    return sharedCookieManager;
}

- (void)setCookieWithUrl:(NSURL *)url
{
    NSString *host = [url host];
    
    if (!self.webviewCookie.length) {
        //请求webViewCookie
        return;
    }
    
    if ([self.cookieURLs containsObject:host]) {
        return;
    }
    [self.cookieURLs addObject:host];
    
    WKUserScript *wkcookieScript = [[WKUserScript alloc]initWithSource:self.webviewCookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.cookieWebView.configuration.userContentController addUserScript:wkcookieScript];
    
    NSString *baseWebUrl = [NSString stringWithFormat:@"%@://%@",url.scheme,url.host];
    [self.cookieWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:baseWebUrl]];
}

- (WKWebView *)cookieWebView
{
    if (!_cookieWebView) {
        WKUserContentController *userContentController = WKUserContentController.new;
        WKWebViewConfiguration *webViewConfig = WKWebViewConfiguration.new;
        webViewConfig.userContentController = userContentController;
        webViewConfig.processPool = [WKProcessPool shareInstance];
        _cookieWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:webViewConfig];
    }
    return _cookieWebView;
}


/// 该方法根据url来执行cookie的相关逻辑，并返回cookie给callback
/// @param url 需要加载cookie的url
/// @param scriptCallback 获得cookies后需要执行的callback
- (void)shouldLoadRequestURL:(NSURL *)url scriptCallback:(void (^)(NSString *scriptString))scriptCallback {
    if (!scriptCallback) {
        return;
    }
    //此处可根据url决定是否需要加载cookie等逻辑
    
    if (!url.host.length) {
        scriptCallback(nil);
        return;
    }
    
    //静态cookie串或者从接口中获取拼接
    NSDictionary *properties = @{
                                 @"id":@"2018",
                                 @"name":@"ella"
                                 };
    NSMutableString *scriptString = [NSMutableString string];
    for (NSString *key in properties.allKeys) {
        NSString *cookieString = [NSString stringWithFormat:@"%@=%@;", key, properties[key]];
        [scriptString appendString:[NSString stringWithFormat:@"document.cookie = '%@';", cookieString]];
    }
    scriptCallback([scriptString copy]);
}

- (void)removeCookieWithURL:(NSURL *)url {
    if (@available(iOS 9.0, *)) {
        NSSet *cookieTypeSet = [NSSet setWithObject:WKWebsiteDataTypeCookies];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:cookieTypeSet modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{
            
        }];
    }
}

- (void)setCookieForIOS11 {
    if (@available(iOS 11.0, *)) {
        //        NSSet *cookieSet = [NSSet setWithObject:WKWebsiteDataTypeCookies];
        //        [[WKWebsiteDataStore defaultDataStore] fetchDataRecordsOfTypes:cookieSet completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
        //            if (records && records.count) {
        //                for (WKWebsiteDataRecord *record in records) {
        //                    NSLog(@"displayName: %@", record.displayName);
        //                    NSLog(@"dataTypes: %@", record.dataTypes);
        //                }
        //            }
        //        }];
        
        //        WKHTTPCookieStore *cookieStore = self.webview.configuration.websiteDataStore.httpCookieStore;
        //        NSDictionary *properties = @{NSHTTPCookieDomain:@"vip.com",
        //                                     NSHTTPCookieName:@"saturn",
        //                                     NSHTTPCookieValue:@"v05839302b2dfbe16cb095110d28d70f9",
        //                                     NSHTTPCookiePath:@"/",
        //                                     };
        //        NSHTTPCookie *saturnCookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        //        [cookieStore setCookie:saturnCookie completionHandler:^{
        //            [self.webview loadHTMLString:@"" baseURL:[NSURL URLWithString:@"https://wxk.vip.com"]];
        //        }];
    }
}

- (void)getCookie {
    if (@available(iOS 9.0, *)) {
        //获取指定类型的website data
        NSSet *types = [[NSSet alloc] initWithObjects:@"WKWebsiteDataTypeCookies", nil];
        [[WKWebsiteDataStore defaultDataStore] fetchDataRecordsOfTypes:types completionHandler:^(NSArray<WKWebsiteDataRecord *> *datas) {
            if (datas && datas.count) {
                for (WKWebsiteDataRecord *record in datas) {
                    NSLog(@"WKWebsiteDataRecord: %@", record.displayName);
                    NSLog(@"dataTypes:%@", record.dataTypes);
                }
            }
        }];
    } else if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            if (cookies && cookies.count) {
                for (NSHTTPCookie *cookie in cookies) {
                    NSLog(@"domain:%@", cookie.domain);
                    NSLog(@"name:%@", cookie.name);
                    NSLog(@"value:%@", cookie.value);
                    NSLog(@"httpOnly:%@", @(cookie.isHTTPOnly));
                }
            }
        }];
    }
}

@end
