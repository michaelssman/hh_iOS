//
//  Present.h
//  HHMVX
//
//  Created by Michael on 2020/9/16.
//  Copyright © 2020 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresentProtocol.h"
#import "MVModel.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Present : NSObject<PresentProtocol>
/// 加载数据
- (void)loadData;

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, weak)id<PresentProtocol> delegate;
@end

NS_ASSUME_NONNULL_END
