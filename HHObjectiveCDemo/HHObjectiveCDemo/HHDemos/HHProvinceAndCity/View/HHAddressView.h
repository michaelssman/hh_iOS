//
//  HHAddressView.h
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 3个tableView，用一个数组保存。tableViews都在一个scrollView上。
 tableView代理：
 numberOfRowsInSection：
 分别返回省，市，区的个数，根据tableView的tag判断省市区的tableView。
 willSelectRowAtIndexPath：
 获取下一级别点数据源，如果下一级数据源为空，则把tableView从父视图移除，并且从数组中移除。
 */

@class HHAddressView;

@protocol HHAddressDelegate <NSObject>

@optional

- (void)addressView:(HHAddressView *)addressView
         provinceId:(NSNumber *)provinceId
             cityId:(NSNumber *)cityId
            ountyId:(NSNumber *)countyId;

@end
@interface HHAddressView : UIView
@property (nonatomic, weak) id<HHAddressDelegate> delegate;
- (void)show;
@end

NS_ASSUME_NONNULL_END
