//
//  HHWKWebViewController.m
//  WebViewDemo
//
//  Created by Michael on 2019/8/2.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHWKWebViewController.h"
#import <WebKit/WebKit.h>
@interface HHWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong)WKWebView *webView;
@end

@implementation HHWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加到视图
    [self.view addSubview:self.webView];
}

#pragma mark - webView
- (WKWebView *)webView
{
    if (!_webView) {
        //利用WKWebView向网页内容中注入JS代码
        /**
         // 适配暗黑模式颜色
         NSString *backgroundColor = @"";
         NSString *labelColor = @"";
         if (@available(iOS 13.0, *)) {
         if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
         backgroundColor = @"'#1B1B21'";
         labelColor = @"'#B0B4BB'";
         }else{
         backgroundColor = @"'#FFFFFF'";
         labelColor = @"'#0D0D0D'";
         }
         }
         //写入JS代码
         NSString *js = [NSString stringWithFormat:@"document.querySelector('.content').style.background=%@",backgroundColor];
         WKUserScript *wkUserScript = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
         WKUserContentController *wkUserContentController = [[WKUserContentController alloc]init];
         [wkUserContentController addUserScript:wkUserScript];
         WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
         config.userContentController = wkUserContentController;
         */
        
        //代理方法, 处理原生和H5交互的, 根据H5返回的func做不同的事
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContentController;
        //视频播放器，禁止默认全屏播放
        config.allowsInlineMediaPlayback = YES;
        
        WKPreferences *preferences = [WKPreferences new];
        //是否支持JavaScript
        preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preferences;
        
        //创建wkwebview
        //webView的frame初始CGRectMake(0, 0, self.view.bounds.size.width, 0)，是因为如果设置frame高度大，contentSize小的时候，返回的contentSize的高度就是frame的高度。就不会准确。
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0) configuration:config];
                
        //某些情况（隐藏导航栏）页面下移问题
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        //遵循代理
        //可以检测到js的alert()弹出，然后我们出来我们自己的样式。弹出什么和做什么操作。
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        //加载webView或者刷新webView
        //方法一
        NSURL *url = [NSURL URLWithString:@"https://www.jianshu.com/p/01f36026da7d"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
        [_webView loadRequest:urlRequest];
        //方法二
//        [self.webView loadHTMLString:@"html文件字符串" baseURL:[NSURL URLWithString:@"baseUrl"]];
    }
    return _webView;
}

- (void)addObserver {
    //JS调用OC 添加处理脚本
    //交互 WKScriptMessageHandler
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"Native"];
    //监听webview高度变化
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    //获取网页标题
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //获取网页加载进度和加载状态
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    //监听UIWindow隐藏(防止全屏播放视频返回后状态栏消失)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}
- (void)removeObserver {
    // 这个也需要移除 不然不释放 应该是在viewWillDisappear中移除，在viewWillAppear中添加。
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Native"];
    
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObserver];
}

#pragma mark 设置userAgent
- (void)setWebViewUserAgent {
    __weak __typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *userAgent = result;
        userAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@""]];
        weakSelf.webView.customUserAgent = userAgent;
    }];
}

#pragma mark -------- WKNavigationDelegate ---------
/*
 WKNavigationDelegate
 WKNavigationDelegate主要是处理一些跳转、加载处理操作
 WKWebView中的navigationDelegate协议可以监听加载网页的周期和结果。
 网页加载开始，结束，失败这几个都特别简单。
 说一下下面这个协议方法，这个方法发生在页面跳转中。
 判断链接是否允许跳转:
 WKNavigationActionPolicy是一个枚举:
 WKNavigationActionPolicyAllow表示允许跳转
 WKNavigationActionPolicyCancel表示取消跳转。
 */
#pragma mark 页面加载
//请求开始的代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}
//请求结束的代理方法。
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
    
//    // 适配暗黑模式颜色
//    NSString *backgroundColor = @"";
//    NSString *labelColor = @"";
//    if (@available(iOS 13.0, *)) {
//        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            backgroundColor = @"'#1B1B21'";
//            labelColor = @"'#B0B4BB'";
//        }else{
//            backgroundColor = @"'#FFFFFF'";
//            labelColor = @"'#0D0D0D'";
//        }
//    }
//    //写入JS代码
//    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.querySelector('.content').style.background=%@",backgroundColor] completionHandler:nil];
//    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor=%@",labelColor] completionHandler:nil];
}
//加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webViewDidFail");
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webViewDidFailProvisional");
}

#pragma mark 截获点击网页上的链接方法 页面跳转
/**
 截获某个页面的跳转，可以自己去跳转。
 */
//发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%s", __FUNCTION__);
    NSMutableURLRequest *originalRequest = navigationAction.request.mutableCopy;
    NSString *url = originalRequest.URL.absoluteString;
    if([url isEqualToString:@"某一个地址"]) {
        //1. 可以设置请求头 注入js
        [originalRequest setValue:@"token" forHTTPHeaderField:@"Authorization"];
        [webView evaluateJavaScript:[NSString stringWithFormat:@"%@\n XMLHttpRequest.prototype.setCoustomHeader = function(){ this.setRequestHeader(\"Authorization\",\"%@\");}", originalRequest.URL.absoluteString, [NSString stringWithFormat:@"Bearer %@", @""]]  completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            if (error == nil)
            {
                NSLog(@"成功注入");
            }
        }];
        
        //2. 自己做页面跳转
        
        // 取消h5自动跳转页面
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
//拿到响应后决定是否允许跳转
//可以在该代理方法中 获取头部信息 过期日期
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSString *cacheControl = [(NSHTTPURLResponse*)navigationResponse.response allHeaderFields][@"Cache-Control"]; // max-age, must-revalidate, no-cache
    NSArray *cacheControlEntities = [cacheControl componentsSeparatedByString:@","];
    
    for(NSString *substring in cacheControlEntities) {
        
        if([substring rangeOfString:@"max-age"].location != NSNotFound) {
            
            // do some processing to calculate expiresOn
            NSString *maxAge = nil;
            NSArray *array = [substring componentsSeparatedByString:@"="];
            if([array count] > 1)
                maxAge = array[1];
            
            NSDate * expiresOnDate = [[NSDate date] dateByAddingTimeInterval:[maxAge intValue]];
            
            //保存过期时间
            [[NSUserDefaults standardUserDefaults] setObject:expiresOnDate forKey:@"guoqishijian"];
        }
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark -------- WKUIDelegate --------
//可以检测到js的alert()弹出，然后我们出来我们自己的样式。弹出什么和做什么操作。
//创建一个新的webView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    [self.webView loadRequest:navigationAction.request];
    return webView;
}
//警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"textInput" message:@"js调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alertVC.textFields lastObject] text]);
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark WKScriptMessageHandler - 监听JavaScript调用原生方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"Native"]) {
        NSDictionary *bodyParam = message.body;
        NSString *func = bodyParam[@"func"];
        if ([func isEqualToString:@""]) {
            //原生的方法
        }
    }
}

#pragma mark 监听高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"] && !self.webView.isLoading) {//!self.webView.isLoading一定要设置
        CGFloat webViewHeight = self.webView.scrollView.contentSize.height;
        NSLog(@"webViewHeight--%f",webViewHeight);
        //注：webview的frame不要用masnory，不然这个方法的高度会一直增加。
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, webViewHeight > self.view.bounds.size.height ? self.view.bounds.size.height : webViewHeight);
    }
    else if ([keyPath isEqualToString:@"title"] && object == self.webView) {
        if(self.navigationController)
            self.navigationItem.title = self.webView.title;
    }
    else if ([keyPath isEqual: @"estimatedProgress"] && object == self.webView) {
        NSLog(@"加载进度:%f",self.webView.estimatedProgress);
        if(self.webView.estimatedProgress >= 1.0f)
        {
            NSLog(@"加载完成");
        }
    }
    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 全屏播放视频后返回
- (void)endFullScreen
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    [[UIApplication sharedApplication] setStatusBarHidden:false animated:true];
#pragma clang diagnostic pop
}

- (void)dealloc {
    NSLog(@"");
}

#pragma mark - 加载本地文件
- (void)loadLocalFile
{
    NSString *filePath;
    NSString *pathExtension = [filePath pathExtension];
    NSString *MiMEType;
    NSURL *baseURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    if ([pathExtension isEqualToString:@"pdf"]) {
        MiMEType = @"application/pdf";
    }
    else if ([pathExtension isEqualToString:@"docx"]) {
        MiMEType = @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    }
    else if ([pathExtension isEqualToString:@"pptx"]) {
        MiMEType = @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
    }
    else if ([pathExtension isEqualToString:@"xlsx"]) {
        MiMEType = @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    }
    [self.webView loadData:[NSData dataWithContentsOfFile:filePath] MIMEType:MiMEType characterEncodingName:@"UTF-8" baseURL:baseURL];
}
@end
