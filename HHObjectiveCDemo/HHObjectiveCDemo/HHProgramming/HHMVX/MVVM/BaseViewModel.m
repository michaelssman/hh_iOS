//
//  BaseViewModel.m
//  HHMVVM
//
//  Created by Michael on 2020/8/20.
//  Copyright © 2020 michael. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel
- (void)initWithBlock:(SuccessBlock)successBlock fail:(FailBlock)failBlock
{
    _successBlock = successBlock;
    _failBlock = failBlock;
}
@end
