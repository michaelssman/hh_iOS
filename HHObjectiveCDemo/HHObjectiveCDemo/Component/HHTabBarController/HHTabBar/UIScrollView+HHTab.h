//
//  UIScrollView+HHTab.h
//  HHTabBarController
//
//  Created by 崔辉辉 on 2020/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HHTab)
@property (nonatomic, copy)void (^hh_didScollHandler)(UIScrollView * scrollView);
@end

NS_ASSUME_NONNULL_END
