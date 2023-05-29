//
//  UMShareUtil.m
//  UMDemo
//
//  Created by Michael on 2020/11/27.
//

#import "UMShareUtil.h"
@interface UMShareUtil()<UMSocialPlatformProvider>
@end
@implementation UMShareUtil

//分享到指定平台
+ (void)shareToPlatformType:(UMSocialPlatformType)platformType
              umShareObject:(UMShareObject *)umShareObject
{
    //判断是否安装所分享到的平台， 没安装则不分享，给出提示。
    if (![self isInstall:platformType]) {
        return ;
    }
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = umShareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        //分享失败
        if (error) {
            
        } else {
            switch (platformType) {
                case UMSocialPlatformType_WechatTimeLine:
                    //分享到朋友圈成功
                    break;
                default:
                    //分享到其他平台成功
                    break;
            }
        }
    }];
}

#pragma mark 判断是否安装分享平台
+ (BOOL)isInstall:(UMSocialPlatformType)platformType {
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        switch (platformType) {
            case UMSocialPlatformType_QQ:
                NSLog(@"未安装QQ");
                break;
            default:
                break;
        }
        return NO;
    }
    return YES;
}
@end
