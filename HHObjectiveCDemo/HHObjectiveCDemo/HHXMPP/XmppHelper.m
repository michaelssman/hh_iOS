//
//  XmppHelper.m
//  LessonXMPP
//
//  Created by laouhn on 15/12/2.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "XmppHelper.h"

//openfire服务器IP地址
#define  kHostName      @"10.90.91.76"
//openfire服务器端口 默认5222
#define  kHostPort      5222
//openfire域名
#define kDomin @"michael"
//resource
#define kResource @"iOS"

@implementation XmppHelper
+ (XmppHelper *)shareXmppHelper {
    static XmppHelper *xmppHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmppHelper = [[XmppHelper alloc]init];
    });
    return xmppHelper;
}
///重写init的方法.完成一些配置信息
- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self initXMPPStream];
        
        //给花名册添加一些配置信息.
        //花名册存储对象
        XMPPRosterCoreDataStorage *RosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        //初始化花名册对象
        self.xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:RosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        //激活通信管道
        [self.xmppRoster activate:self.xmppStream];
        //给花名册添加代理.
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //聊天
        //1信息归档数据存储对象.
        XMPPMessageArchivingCoreDataStorage *messageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        //信息归档对象.
        self.messageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:messageArchivingCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        //激活通道
        [self.messageArchiving activate:self.xmppStream];
        //给数据管理器赋值
        self.managedObjectContext = messageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    }
    return self;
}
#pragma mark - 初始化XMPPStream
- (void)initXMPPStream {
    //完成xmppStream的基本配置
    //1创建通道对象
    self.xmppStream = [[XMPPStream alloc]init];
    //2指定管道对象链接的服务器地址
    self.xmppStream.hostName = kHostName;
    //3指定xmpp的服务器端口
    self.xmppStream.hostPort = kHostPort;
    //4添加代理
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (void)initXMPPReconnect {
    self.xmppReconnect = [[XMPPReconnect alloc]init];
    _xmppReconnect.autoReconnect = YES;
    _xmppReconnect.reconnectDelay = 3.0;
    _xmppReconnect.reconnectTimerInterval = 3.0;
    [self.xmppReconnect activate:self.xmppStream];
    [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
#pragma mark XMPPRosterDelegate
//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
//
//}
#pragma mark XMPPStreamDelegate
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket { //常链接  不断开不会停
    //xmpp的底层是socket. 是一种长链接形式. 如果不主动断开.是不会断开的.
    NSLog(@"socket");
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    NSLog(@"通道将要链接");
}
//连接xmpp成功之后，使用密码认证
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"通道已经链接");
    NSError *error = nil;
    if (self.loginOrRegist == Login) {
        [self.xmppStream authenticateWithPassword:self.password error:&error];
    } else {
        [self.xmppStream registerWithPassword:self.password error:&error];
    }
}
//认证通过之后的处理
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"认证通过");
    //登录成功
    if (self.loginOrRegist == Login) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(LoginSuccess:)]) {
            [self.delegate LoginSuccess:sender];
        }
    }
}
//认证没有通过的处理
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"登陆失败");
}
//连接服务器的超时处理
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    NSLog(@"连接超时");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"xmppStreamDidDisconnect");
}

#pragma mark 注册
// 注册成功的方法回调
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"注册成功");
}
// 注册失败的方法回调
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    NSLog(@"注册失败");
}
#pragma mark 登陆注册
- (void)loginOrRegistWithLoginOrRegist:(LoginOrRegist)loginOrRegist userName:(NSString *)userName password:(NSString *)password {
    //属性赋值
    self.loginOrRegist = loginOrRegist;//登录\注册
    self.password = password;//密码赋值
    //创建账号对象
    //参数 1 用户名 2 域名 3 标识
    XMPPJID *loginJid = [XMPPJID jidWithUser:userName domain:kDomin resource:kResource];
    //告诉通道是谁在登陆/注册
    self.xmppStream.myJID = loginJid;
    //发起请求
    [self connectToServer];
}

//connect
- (void)connectToServer {
    if ([self.xmppStream isConnected] || [self.xmppStream isConnecting]) {
        [self goOffline];
        //取消链接
        [self.xmppStream disconnect];
    }
    //发起请求
    //-1指的是不设置超时时间.
    //error就是指通道发起请求时的返回的错误信息
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
}

#pragma mark - 上下线状态
- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [self.xmppStream sendElement:presence];
}
- (void)goOffline {
    //取消上线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    //告诉通道下线
    [self.xmppStream sendElement:presence];
}

#pragma mark - 取消
- (void)teardownStream {
    [_xmppReconnect deactivate];
    [_xmppStream disconnect];
    _xmppReconnect = nil;
    _xmppStream = nil;
}
@end
