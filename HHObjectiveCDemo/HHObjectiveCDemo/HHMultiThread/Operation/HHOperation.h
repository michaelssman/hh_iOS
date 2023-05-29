//
//  HHOperation.h
//  HHMultiThread
//
//  Created by michael on 2021/10/20.
//  Copyright © 2021 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, AFOperationState) {
  AFOperationPausedState      = -1,
  AFOperationReadyState       = 1,
  AFOperationExecutingState   = 2,
  AFOperationFinishedState    = 3,
};

@interface HHOperation : NSOperation
@property(nonatomic, assign)AFOperationState state;
@end

NS_ASSUME_NONNULL_END
