//
//  XmppHelper.h
//  LessonXMPP
//
//  Created by laouhn on 15/12/2.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef NS_ENUM(NSUInteger, LoginOrRegist) {
    Login,
    Regist,
};

@protocol XMPPHelperDelegate <NSObject>

@optional

/// 登录成功
- (void)LoginSuccess:(XMPPStream *)sender;

@end

@interface XmppHelper : NSObject<XMPPStreamDelegate,XMPPRosterDelegate>

/// 登录/注册
@property (nonatomic, assign)LoginOrRegist loginOrRegist;
///密码
@property (nonatomic, copy)NSString *password;
///通道
@property (nonatomic, strong)XMPPStream *xmppStream;
@property (nonatomic, strong)XMPPReconnect *xmppReconnect;
///花名册管理
@property (nonatomic, strong)XMPPRoster *xmppRoster;
///信息归档对象
@property (nonatomic, strong)XMPPMessageArchiving *messageArchiving;
///数据管理器
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak)id<XMPPHelperDelegate> delegate;

///单例方法
+ (XmppHelper *)shareXmppHelper;

///登陆注册方法
- (void)loginOrRegistWithLoginOrRegist:(LoginOrRegist)loginOrRegist
userName:(NSString *)userName
password:(NSString *)password;

@end
