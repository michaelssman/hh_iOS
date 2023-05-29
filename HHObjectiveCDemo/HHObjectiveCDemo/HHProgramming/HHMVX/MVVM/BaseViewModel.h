//
//  BaseViewModel.h
//  HHMVVM
//
//  Created by Michael on 2020/8/20.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock) (id data);
typedef void(^FailBlock) (id data);

@interface BaseViewModel : NSObject
@property (nonatomic, copy)SuccessBlock successBlock;
@property (nonatomic, copy)FailBlock failBlock;
- (void)initWithBlock:(SuccessBlock)successBlock fail:(FailBlock __nullable)failBlock;
@end

NS_ASSUME_NONNULL_END
