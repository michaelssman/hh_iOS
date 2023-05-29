//
//  MVVMViewModel.h
//  HHMVX
//
//  Created by Michael on 2020/9/16.
//  Copyright © 2020 michael. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVVMViewModel : BaseViewModel

/// 例子  点击页面 更新model
@property (nonatomic, copy)NSString *contentKey;

/// 加载数据
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
