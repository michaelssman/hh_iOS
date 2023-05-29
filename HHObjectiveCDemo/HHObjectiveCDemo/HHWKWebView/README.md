# WebViewDemo
WebViewDemo

## 获取webView的内容高度
通过添加观察者获得的内容高度，如果设初始高度是屏幕高度，内容高度小的话，返回的内容高度一直都是设置的高度，只有内容多的时候，高度才准确，所以在初始的时候要设置webView的高度为一个小的高度`CGFLOAT_MIN`。

## js与原生的交互
iOS和js的交互都要通过代理方法去处理。
### JS调用OC代码
`[self.webView.configuration.userContentController addScriptMessageHandler:self name:@"Share"];`
这是利用WKWebView的一个新特性MessageHandler来处理JS调用原生方法。要实现JS调用iOS原生方法，步骤见下：
1. 添加<WKScriptMessageHandler>协议。让控制器成为MessageHandler的代理对象。
2. 对于监听的方法名要和JS开发的人商量好。这里我们监听的是Share方法，对于JS开发的人员必须要以以下方式写。
`window.webkit.messageHandlers. Share.postMessage(null)`
3. 实现协议方法。在这个方法里message参数有一个属性body。message.body就是JS传过来的参数，可以是字符串，可以是数组，也可以是字典。通过message.name判断可以知道监听的是JS的哪个方法。
```
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{    
    if ([message.name isEqualToString:@"Share"]) {
             //TODO
    }
}
```
至此，JS调用OC代码就已完结。另外，还有不一样的处理方式。可以参考WebViewJavascriptBridge，写的比较清楚。


1、iOS调用js的方法， 例如调用js的跳转方法。
2、iOS获取js的方法，截取方法然后自己去实现。 
```
@protocol WKScriptMessageHandler <NSObject>

@required

/*! @abstract Invoked when a script message is received from a webpage.
 @param userContentController The user content controller invoking the
 delegate method.
 @param message The script message received.
 */
方法中主要是收到JS的回执脚本就会运行一次
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
```
该代理方法是h5调用js方法的时候，客户端可以获取到并且去做自己的处理。
点击某个按钮，webview加载完成之后原生可以获取到里面的某些需要的数据去设置。
h5调原生本地函数

```
/**
 当从网页收到脚本消息时调用。

 @param userContentController 调用委托方法的用户内容控制器。
 @param message 收到的脚本消息。
 */
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSDictionary *bodyParam = (NSDictionary*)message.body;
    NSString *func = [bodyParam objectForKey:@"function"];
    
    NSLog(@"MessageHandler Name:%@", message.name);
    NSLog(@"MessageHandler Body:%@", message.body);
    NSLog(@"MessageHandler Function:%@",func);
    
    //本人喜欢只定义一个MessageHandler协议 当然可以定义其他MessageHandler协议
    
    if ([message.name isEqualToString:@"Native"])
    {
        NSDictionary *parameters = [bodyParam objectForKey:@"parameters"];
        //调用本地函数
        if ([func isEqualToString:@"callNativeWebShare"]){
            NSLog(@"调用原生的分享功能");
        }
    }
}
```
这个是检测收到html的js消息的时候， 我们客户端做的操作。

### 原生调用js方法（OC调用JS代码）
```
     [self.webView evaluateJavaScript:@"show()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                //TODO
      }];
```
show()就是JS写的方法，这个方法可传可不传参数，具体依实际情况而定。
例一：
文章详情页面发表评论功能，发评论的内容是客户端控制的，客户端才拥有。
点击发送按钮，需要调用js方法，告诉h5发表评论的内容。
点击发送按钮需要调用h5的js方法：
```
NSString *contentString = [<#评论的内容#> stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];

[wkWebView evaluateJavaScript:[NSString stringWithFormat:@"keyboardBarCommentReturn('%@')",contentString] completionHandler:^(id _Nullable response, NSError * _Nullable error){
        
    }];
```
例二：
点击底部的评论按钮，详情页滚动到评论，需要h5去做，原生告诉h5
```
[wkWebView evaluateJavaScript:[NSString stringWithFormat:@"keyboardBarRecordReturn('1')"] completionHandler:^(id _Nullable response, NSError * _Nullable error) {

    }];
```
另外关于UIWebView和JS的交互，以下部分仅供参考。
```
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"Share"] = ^() {
        NSArray *args = [JSContext currentArguments];
        dispatch_async(dispatch_get_main_queue(), ^{
                //TODO
        });
```

## WKProcessPool

WKWebView共用Sessionid，WKProcessPool这个属性就是WKWebView的数据池，让WKWebView共用WKProcessPool就好了，需要把WKProcessPool定义成单例。
