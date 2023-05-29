//
//  CommunityModel.h
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityModel : NSObject

@property (nonatomic, assign)int communityId;

@property (nonatomic, strong)NSArray *picture;
@property (nonatomic, strong)NSArray *smallPicture;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, assign)int postNum;
@property (nonatomic, assign)int likeNum;
@property (nonatomic, strong)NSArray *likeList;
@property (nonatomic, assign)int createdTime;

@property (nonatomic, assign)int userId;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *truename;
@property (nonatomic, strong)NSString *displayName;
@property (nonatomic, strong)NSString *avatar;
@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSString *role;
@property (nonatomic, assign)int currentLike;

@end
