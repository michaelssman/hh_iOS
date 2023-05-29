//
//  HHUMLogin.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2022/2/14.
//

#import "HHUMLogin.h"

@implementation HHUMLogin

#pragma mark - 友盟第三方登录
//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
//{
//    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = YES;
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
//        UMSocialUserInfoResponse *resp = result;
//        
//        if (error) {
//            NSLog(@"=====授权失败：%@",error);
//        } else {
//            
//            NSLog(@"=====授权成功=====");
//            
//            // 第三方登录数据(为空表示平台未提供)
//            // 授权数据
//            //            B22D5D5D4A6DC3C22F41F003D56E76CA
//            NSLog(@" uid: %@", resp.uid);
//            NSLog(@" openid: %@", resp.openid);
//            NSLog(@" accessToken: %@", resp.accessToken);
//            NSLog(@" refreshToken: %@", resp.refreshToken);
//            NSLog(@" expiration: %@", resp.expiration);
//            NSLog(@" resp.unionId: %@", resp.unionId);
//            // 用户数据
//            NSLog(@" name: %@", resp.name);
//            NSLog(@" iconurl: %@", resp.iconurl);
//            NSLog(@" gender: %@", resp.unionGender);
//            
//            // 第三方平台SDK原始数据
//            NSLog(@" originalResponse: %@", resp.originalResponse);
//            
//            /*
//             然后就可以在里面写自己服务器的网络请求， 去登录自己服务器。
//             */
//            
//        }
//    }];
//}

@end
