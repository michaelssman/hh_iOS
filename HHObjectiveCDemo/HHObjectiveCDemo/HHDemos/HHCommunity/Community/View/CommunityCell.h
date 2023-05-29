//
//  CommunityCell.h
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityView.h"

@class CommunityModel;

@interface CommunityCell : UITableViewCell

@property (nonatomic, strong)CommunityView *communityView;

- (void)setDataWithModel:(CommunityModel *)model;

@end
