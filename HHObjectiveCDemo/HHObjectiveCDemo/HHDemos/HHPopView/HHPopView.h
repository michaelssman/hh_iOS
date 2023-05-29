//
//  HHPopView.h
//  HHBaseViews
//
//  Created by Michael on 2020/3/25.
//  Copyright © 2020 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPopBackgroundView.h"

NS_ASSUME_NONNULL_BEGIN

@class HHPopView;
@protocol HHPopViewDelegate <NSObject>

@required

- (UITableViewCell *)popView:(HHPopView *)popView
                   tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGFloat)popView:(HHPopView *)popView
         tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)popView:(HHPopView *)popView
      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HHPopView : UIView
/// 数据源
@property(nonatomic,copy)NSArray * dataArray;

/// <#Description#>
/// @param frame 整个popView的frame
/// @param dataArray <#dataArray description#>
/// @param animate <#animate description#>
/// @param hiddenAction <#hiddenAction description#>
+ (instancetype)showPopViewWithWindowFrame:(CGRect)frame
                                 dataArray:(NSArray *)dataArray
                                  animated:(BOOL)animate
                                    hidden:(void(^)(void))hiddenAction;
- (void)show;
/// <#Description#>
/// @param animate <#animate description#>
+ (void)hiden:(BOOL)animate;

- (void)reloadPopViewWithDataArray:(NSArray *)dataArray;

@property(nonatomic, weak) id <HHPopViewDelegate> delegate;
@property (nonatomic, assign)CGRect backgroundViewFrame;

@end

NS_ASSUME_NONNULL_END
