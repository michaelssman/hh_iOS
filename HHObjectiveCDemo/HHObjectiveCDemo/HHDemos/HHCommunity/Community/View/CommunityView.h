//
//  CommunityView.h
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AvatarSize      45.0

@class CommunityModel;

@interface CommunityView : UIView

@property (nonatomic, strong)UIImageView *avatarView;
@property (nonatomic, strong)UIButton *supportBtn;
@property (nonatomic, strong)UIButton *commentCntBtn;

- (void)setDataWithModel:(CommunityModel *)model;

@end
