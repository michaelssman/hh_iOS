//
//  HHPerson.h
//  KVODemo
//
//  Created by Michael on 2020/7/20.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHKVOPerson : NSObject
@property (nonatomic, copy)NSString *nick;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, copy)NSString *name;

@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSMutableArray *mArray;

#pragma mark - 一对多
@property (nonatomic, copy) NSString *downloadProgress;
@property (nonatomic, assign) double writtenData;
@property (nonatomic, assign) double totalData;

@end

NS_ASSUME_NONNULL_END
