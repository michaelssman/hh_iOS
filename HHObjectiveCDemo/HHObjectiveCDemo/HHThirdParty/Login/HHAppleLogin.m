//
//  HHThirdPlatformLogin.m
//  UMDemo
//
//  Created by FN-116 on 2021/11/24.
//

#import "HHAppleLogin.h"
#import <AuthenticationServices/AuthenticationServices.h>
@interface HHAppleLogin()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@end
@implementation HHAppleLogin
#pragma mark - appleLogin
- (void)appleLogin API_AVAILABLE(ios(13.0)) {
    //基于用户的Apple ID授权用户，生成用户授权请求的一种机制
    ASAuthorizationAppleIDProvider *provide = [[ASAuthorizationAppleIDProvider alloc] init];
    //创建新的AppleID 授权请求
    ASAuthorizationAppleIDRequest *request = provide.createRequest;
    //在用户授权期间请求的联系信息
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    //由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    //设置授权控制器通知授权请求的成功与失败的代理
    controller.delegate = self;
    //设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
    controller.presentationContextProvider = self;
    //在控制器初始化期间启动授权流
    [controller performRequests];
}

#pragma mark Apple登录
// - ASAuthorizationControllerDelegate -
//授权成功的回调
/**
// 当授权成功后，我们可以通过这个拿到用户的 userID、email、fullName、authorizationCode、identityToken 以及 realUserStatus 等信息。
// */
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        /*
         NSString *state = credential.state;
         //苹果用户信息，邮箱
         NSString *email = credential.email;
         NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
         //用于判断当前登录的苹果账号是否是一个真实用户
         取值有：unsupported、unknown、likelyReal。
         ASUserDetectionStatus realUserStatus = credential.realUserStatus;
         
         */
        
        /**
         验证数据，用于传给开发者后台服务器，然后开发者服务器再向苹果的身份验证服务端验证本次授权登录请求数据的有效性和真实性，详见 Sign In with Apple REST API。如果验证成功，可以根据 userIdentifier 判断账号是否已存在，若存在，则返回自己账号系统的登录态，若不存在，则创建一个新的账号，并返回对应的登录态给 App。
         */
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        //苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString *userId = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        userId = [userId stringByReplacingOccurrencesOfString:@"." withString:@""];
        userId = [NSString stringWithFormat:@"ap%@",userId];
//        [self appleLoginUserID:userId token:identityToken];
        if (identityToken && userId) {

        }
    }
    
}

//失败的回调
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = nil;
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled: {
            errorMsg = @"用户取消了授权请求";
        }
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
//告诉代理应该在哪个window 展示授权界面给用户
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {

    return [UIApplication sharedApplication].keyWindow;
}

@end
