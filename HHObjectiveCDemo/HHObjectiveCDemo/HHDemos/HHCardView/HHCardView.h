//
//  HHCardView.h
//  CardDemo
//
//  Created by Michael on 2020/9/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HHCardView, HHCardCell;

@protocol HHCardViewDelegate <NSObject>
@optional
- (void)cardView:(HHCardView *)cardView didClickItemAtIndex:(NSInteger)index;
@end

@protocol HHCardViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemViewsInCardView:(HHCardView *)cardView;
- (HHCardCell *)cardView:(HHCardView *)cardView itemViewAtIndex:(NSInteger)index;
- (void)cardViewNeedMoreData:(HHCardView *)cardView;
@optional
- (CGSize)cardView:(HHCardView *)cardView sizeForItemViewAtIndex:(NSInteger)index;
@end

@interface HHCardView : UIView
@property (nonatomic, weak) id <HHCardViewDataSource> dataSource;
@property (nonatomic, weak) id <HHCardViewDelegate> delegate;

- (void)deleteTheTopItemViewWithLeft:(BOOL)left;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
