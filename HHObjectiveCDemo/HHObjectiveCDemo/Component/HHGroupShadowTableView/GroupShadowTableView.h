//
//  GroupShadowTableView.h
//  GroupShadowTableViewDemo
//
//  Created by 崔辉辉 on 2020/1/16.
//  Copyright © 2020 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GroupShadowTableView;
@protocol GroupShadowTableViewDelegate <NSObject>
@optional
- (void)groupShadowTableView:(GroupShadowTableView *)tableView
     didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)groupShadowTableView:(GroupShadowTableView *)tableView
          canSelectAtSection:(NSInteger)section;

- (UIView *)groupShadowTableView:(GroupShadowTableView *)tableView
          viewForHeaderInSection:(NSInteger)section;
- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView
       heightForHeaderInSection:(NSInteger)section;
- (UIView *)groupShadowTableView:(GroupShadowTableView *)tableView
          viewForFooterInSection:(NSInteger)section;
- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView
       heightForFooterInSection:(NSInteger)section;
@end

@protocol GroupShadowTableViewDataSource <NSObject>
@optional
- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView;

@required
- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView
            numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface GroupShadowTableView : UITableView

/// 是否显示分割线
@property (nonatomic, assign)BOOL showSeparator;
@property (nonatomic, weak) id <GroupShadowTableViewDelegate> groupShadowDelegate;
@property (nonatomic, weak) id <GroupShadowTableViewDataSource> groupShadowDataSource;

/// 返回cell
/// @param indexPath indexPath
- (nullable __kindof UITableViewCell *)groupShadowTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
