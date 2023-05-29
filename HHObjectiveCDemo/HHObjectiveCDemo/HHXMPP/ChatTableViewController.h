//
//  ChatTableViewController.h
//  LessonXMPP
//
//  Created by laouhn on 15/12/3.
//  Copyright (c) 2015年 hehe. All rights reserved.
//  聊天界面

#import <UIKit/UIKit.h>
#import "XmppHelper.h"
@interface ChatTableViewController : UITableViewController
@property (nonatomic, strong)XMPPJID *chatJid;
@end
