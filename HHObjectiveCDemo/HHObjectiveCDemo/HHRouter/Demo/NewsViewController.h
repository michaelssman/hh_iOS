//
//  NewsViewController.h
//  HHRouter
//
//  Created by michael on 2021/5/18.
//  Copyright © 2021 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsViewController : UIViewController
@property(nonatomic, copy)NSString *newsID;
@property (nonatomic, copy)void (^callBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
