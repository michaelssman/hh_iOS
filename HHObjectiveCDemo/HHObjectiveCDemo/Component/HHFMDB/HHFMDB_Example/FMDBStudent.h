//
//  Student.h
//  MyFMDB
//
//  Created by 崔辉辉 on 2018/12/28.
//  Copyright © 2018 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject<NSCoding>
@property(nonatomic,copy)NSString *name;
@end


@interface FMDBStudent : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,strong)NSArray *infos;
@property(nonatomic,strong)User *user;
@end

NS_ASSUME_NONNULL_END
