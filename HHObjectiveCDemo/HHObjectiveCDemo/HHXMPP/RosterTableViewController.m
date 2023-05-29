//
//  RosterTableViewController.m
//  LessonXMPP
//
//  Created by laouhn on 15/12/3.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "RosterTableViewController.h"
#import "XmppHelper.h"
#import "ChatTableViewController.h"
@interface RosterTableViewController ()<XMPPRosterDelegate>
//数据源
@property (nonatomic, strong)NSMutableArray *rosterArray;
@end

@implementation RosterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //数组初始化
    self.rosterArray = [NSMutableArray array];
    
    //显示当前账号用户名
    self.title = [XmppHelper shareXmppHelper].xmppStream.myJID.user;
    [[XmppHelper shareXmppHelper].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark XMPPRosterDelegate
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender {
    NSLog(@"开始检索好友");
}
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item {
    NSLog(@"检索到好友");
    NSLog(@"%@",item);
    //根据item的str 拿到我们需求的jid值.
    NSString *jidStr = [[item attributeForName:@"jid"] stringValue];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    //进行安全判断.防止重复的用户添加.
    if (![self.rosterArray containsObject:jid]) {
        [self.rosterArray addObject:jid];
    }
    //变换UI
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.rosterArray.count - 1 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

//收到好友消息后的代理方法
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    NSLog(@"%@",presence);
    NSLog(@"收到好友的申请");
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"添加请求" message:@"有东儿要加您" preferredStyle:UIAlertControllerStyleAlert];
    //同意好友
    UIAlertAction *defaultA = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //同意添加好友
//        sender == [XmppHelper shareXmppHelper].xmppRoster
        [sender acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    }];
    UIAlertAction *cancleA = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //拒绝好友添加
        [sender rejectPresenceSubscriptionRequestFrom:presence.from];
    }];
    [alertC addAction:defaultA];
    [alertC addAction:cancleA];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.rosterArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rosterCell" forIndexPath:indexPath];
    XMPPJID *jid = [self.rosterArray objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = jid.user;
    return cell;
}

#pragma mark - 跳聊天界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPJID *jid = [self.rosterArray objectAtIndex:indexPath.row];
    ChatTableViewController *chatVC = [[ChatTableViewController alloc] init];
    chatVC.chatJid = jid;
    [self.navigationController pushViewController:chatVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
