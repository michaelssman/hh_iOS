//
//  HHListController.m
//  HHBaseController
//
//  Created by 崔辉辉 on 2018/12/10.
//  Copyright © 2018 huihui. All rights reserved.
//

#import "HHListController.h"
#import "MJRefresh.h"

#define WEAKSELF                        __weak __typeof(self) weakSelf = self;

@interface HHListController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDate *lastRefreshTime;

/// 上滑是否加载更多（默认为YES，网络请求出错时，需要设置为NO，延迟1秒后为YES）
@property (nonatomic, assign) BOOL shouldFetch;
@end

@implementation HHListController

- (instancetype)init {
    self = [super init];
    if (self) {
        _objects = [NSMutableArray new];
        _objectsPerPage = 20;
        _offset = 0;

        _shouldFetchDataAfterLoaded = YES;
        _needRefreshAnimation = YES;
        _refreshInterval = 600;
        _shouldFetch = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.sectionHeaderHeight = 0.1;
    self.tableView.sectionFooterHeight = 0.1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //调用reloadData方法页面跳动问题 需在创建tableview时添加下面三行代码
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    if (!_shouldFetchDataAfterLoaded) {return;}
    if (_needRefreshAnimation) {
        [self.tableView.mj_header beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height) animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*** 自动刷新 ***/
    if (_needAutoRefresh) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _lastRefreshTime = [_userDefaults objectForKey:_kLastRefreshTime];
        
        if (!_lastRefreshTime) {
            _lastRefreshTime = [NSDate dateWithTimeIntervalSince1970:0];
        }
        
        NSDate *currentTime = [NSDate date];
        if ([currentTime timeIntervalSinceDate:_lastRefreshTime] > _refreshInterval) {
            NSLog(@"\n=======================auto refresh=======================\n");
            [self refresh];
        }
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewDelegate && [self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableViewDelegate && [self.tableViewDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        NSAssert(false, @"Implement the proxy method");
        return nil;;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewDelegate && [self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - 刷新
- (void)refresh
{
    if (self.willBeginRefresh) {
        self.willBeginRefresh();
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self fetchObjectWithRefresh:YES];
    });
    
    if (_needAutoRefresh) {
        _lastRefreshTime = [NSDate date];
        [_userDefaults setObject:_lastRefreshTime forKey:_kLastRefreshTime];
    }
}

#pragma mark - 上拉加载更多
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.didScroll) {
        self.didScroll();
    }
    
    if (!_lastCell.shouldResponseToTouch || !_shouldFetch) {
        return;
    }
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - 100) {
        [self fetchMore];
    }
}

- (void)tapLastCellAction
{
    if (_lastCell.status == LastCellStatusFinished) {
        return;
    }
    [self fetchMore];
}

- (void)fetchMore
{
    if ([self.tableView.mj_header isRefreshing]) {return;}
    _lastCell.status = LastCellStatusLoading;
    [self fetchObjectWithRefresh:NO];
}

#pragma mark - 请求数据
- (void)fetchObjectWithRefresh:(BOOL)refresh {
    WEAKSELF
    if (self.requestData) {
        self.requestData(self, refresh, ^(NSArray * _Nonnull responseArray) {
            [weakSelf loadSuccessWithRefresh:refresh ResponseArray:responseArray];
        }, ^{
            [weakSelf loadError];
        });
    }
}

- (void)loadError {
    _lastCell.status = LastCellStatusMore;
    self.shouldFetch = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.shouldFetch = YES;
    });
    [self endRefreshing];
}

//加载完成，设置状态
- (void)loadSuccessWithRefresh:(BOOL)refresh
                 ResponseArray:(NSArray *)responseArray {
    if (refresh) {
        [self.objects removeAllObjects];
    }
    [self.objects addObjectsFromArray:responseArray];
    self.offset++;
    //设置状态
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.objects.count == 0) {
            self.lastCell.status = LastCellStatusEmpty;
        } else if (responseArray.count < self.objectsPerPage) {
            self.lastCell.status = LastCellStatusFinished;
        } else {
            self.lastCell.status = LastCellStatusMore;
        }
        self.tableView.tableFooterView = self.lastCell;
        [self.tableView reloadData];
    });
    [self endRefreshing];
}

- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
    });
}

#pragma mark - lazy load
- (HHLastCell *)lastCell
{
    if (!_lastCell) {
        self.lastCell = [[HHLastCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, TableLastCellHeight)];
        [self.lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLastCellAction)]];
        self.tableView.tableFooterView = self.lastCell;
    }
    return _lastCell;
}

@end
