//
//  CommunityModel.m
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "CommunityModel.h"

@implementation CommunityModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.communityId = [value intValue];
    }
}

- (BOOL)isEqual:(id)object {
    if ([self class] == [object class]) {
        return self.communityId == ((CommunityModel *)object).communityId;
    }
    
    return NO;
}

@end
