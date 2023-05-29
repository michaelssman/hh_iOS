//
//  ChatTableViewController.m
//  LessonXMPP
//
//  Created by laouhn on 15/12/3.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "ChatTableViewController.h"

@interface ChatTableViewController ()<XMPPStreamDelegate>

@property (nonatomic, strong)NSMutableArray *messageArray;
@end

@implementation ChatTableViewController
- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        self.messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.chatJid.user;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(sendmessage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    //添加代理
    [[XmppHelper shareXmppHelper].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self seachMessageForReload];
}
//数据查询.
- (void)seachMessageForReload {
    //数据管理器.
    NSManagedObjectContext *context = [XmppHelper shareXmppHelper].managedObjectContext;
    //检索条件
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@",self.chatJid.bare,[XmppHelper shareXmppHelper].xmppStream.myJID.bare];
    request.predicate = predicate;
    //数据查询
    NSArray *temArray = [context executeFetchRequest:request error:nil];
    //安全判断 如果数据源的数组存在数据就全部移除.
    if (self.messageArray.count != 0) {
        [self.messageArray removeAllObjects];
    }
    [self.messageArray addObjectsFromArray:temArray];
    //刷新UI
    [self.tableView reloadData];
//    //将tableview滚动到最后一行
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark -XMPPStreamDelegate
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSLog(@"已经收到消息");
    //安全处理
    if ([message.from.bare isEqualToString:self.chatJid.bare]) {
        [self addmessages:message];
    }
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"已经发送消息");
    [self addmessages:message];
}
///数据源添加数据
- (void)addmessages:(XMPPMessage *)message {
    [self.messageArray addObject:message];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.tableView reloadData];
}
///添加消息
- (void)sendmessage {
    //1.chat 指的是我们的格式 是聊天.
    //2.发送的消息到达的jid.
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.chatJid];
    //发送内容
    [message addBody:@"hello world"];
    //通道执行
    [[XmppHelper shareXmppHelper].xmppStream sendElement:message];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.messageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell" forIndexPath:indexPath];
    
    // Configure the cell...
    XMPPMessage * tempMessage = self.messageArray[indexPath.row];
    //区分我发的还是对方发的消息，显示不同的cell。
    if (tempMessage.thread == nil) {
        //我的消息
        cell.textLabel.text = tempMessage.body;
    } else {
        //对方的消息
        cell.textLabel.text = tempMessage.body;
    }
    return cell;
}

@end
