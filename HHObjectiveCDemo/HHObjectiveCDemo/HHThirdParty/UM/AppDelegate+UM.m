//
//  AppDelegate+UM.m
//  UMDemo
//
//  Created by michael on 2021/7/2.
//

#import "AppDelegate+UM.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

@implementation AppDelegate (UM)
- (void)configUM
{
    //     设置友盟appkey
        [UMConfigure initWithAppkey:@"5861e5daf5ade41326001eab" channel:@"App Store"];
        
        //配置微信平台的Universal Links
        //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
        [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
                                                            @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139"
                                                            };
        
        /* 设置微信的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx60d36f0847db422c" appSecret:@"5758b4e5dedabcd34d5bfe7a1a65f31d" redirectURL:nil];

        /* 设置QQ */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101830139"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];

        /* 设置sina */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}
@end
