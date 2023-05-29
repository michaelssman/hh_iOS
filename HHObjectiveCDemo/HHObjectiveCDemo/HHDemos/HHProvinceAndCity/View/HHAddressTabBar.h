//
//  HHAddressTabBar.h
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAddressTabBar : UIView

@property (nonatomic, strong)NSMutableArray *tabItems;

/// setter方法中，去改变选中的button和line的frame
@property (nonatomic, assign)NSInteger selectedIndex;

- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
