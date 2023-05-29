//
//  PresentProtocol.h
//  HHMVX
//
//  Created by Michael on 2021/5/10.
//  Copyright © 2021 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PresentProtocol <NSObject>
@optional

/**
 刷新加载更多的网络请求
 */
//UI --> model  UI改变通知Model跟着改变
- (void)didClickAddBtnWithNum:(NSString *)num
                    indexPath:(NSIndexPath *)indexPath;
//数据发生改变。刷新UI
- (void)reloadUI;

@end

NS_ASSUME_NONNULL_END
