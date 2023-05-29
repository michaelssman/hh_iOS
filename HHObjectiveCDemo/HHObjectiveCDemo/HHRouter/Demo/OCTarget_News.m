//
//  OCTarget_News.m
//  HHRouter
//
//  Created by michael on 2021/5/18.
//  Copyright © 2021 michael. All rights reserved.
//

#import "OCTarget_News.h"
#import "NewsViewController.h"

@implementation OCTarget_News

- (UIViewController *)action_NativeToNewsViewController:(NSDictionary *)params
{
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    
    if ([params valueForKey:@"newsID"]) {
        newsVC.newsID = params[@"newsID"];
    }
    if ([params valueForKey:@"callBlock"]) {
        newsVC.callBlock = params[@"callBlock"];
    }
    return newsVC;
}

@end
