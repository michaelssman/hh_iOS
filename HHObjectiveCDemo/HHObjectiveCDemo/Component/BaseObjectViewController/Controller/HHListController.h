//
//  HHListController.h
//  HHBaseController
//
//  Created by 崔辉辉 on 2018/12/10.
//  Copyright © 2018 huihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHLastCell.h"

NS_ASSUME_NONNULL_BEGIN

@class HHListController;

@protocol HHTableViewDelegate <NSObject>
@required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
/// 点击cell
/// @param tableView <#tableView description#>
/// @param indexPath <#indexPath description#>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

typedef void(^SuccessCallBack)(NSArray *responseArray);
typedef void(^FailureCallback)(void);

@interface HHListController : UITableViewController

@property (nonatomic, assign)BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, assign)BOOL needRefreshAnimation;
@property (nonatomic, assign)BOOL needAutoRefresh;
@property (nonatomic, copy)NSString *kLastRefreshTime;
@property (nonatomic, assign) NSTimeInterval refreshInterval;

@property (nonatomic, copy)void (^willBeginRefresh)(void);
@property (nonatomic, copy)void (^didScroll)(void);
/// 网络请求由外面实现，请求成功数据处理完之后的操作在基类实现。
@property (nonatomic, copy)void (^requestData)(HHListController *listVC, BOOL refresh, SuccessCallBack success, FailureCallback failure);

/// 每页个数
@property (nonatomic, assign)NSUInteger objectsPerPage;
/// 第几页、偏移量、最后一条数据的时间戳等
@property (nonatomic, assign)NSUInteger offset;
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong)HHLastCell *lastCell;
@property(nonatomic, weak) id <HHTableViewDelegate> tableViewDelegate;
@end

NS_ASSUME_NONNULL_END
