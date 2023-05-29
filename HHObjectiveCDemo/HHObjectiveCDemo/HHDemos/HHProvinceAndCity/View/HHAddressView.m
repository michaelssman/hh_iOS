//
//  HHAddressView.m
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHAddressView.h"
#import "HHAddressCell.h"
#import "HHAddressModel.h"
#import "HHAddressTopView.h"
#import "HHAddressTabBar.h"
#import "HHAddressTool.h"
#define HHScreenWidth [UIScreen mainScreen].bounds.size.width
@interface HHAddressView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong)HHAddressTabBar *tabBar;
@property (nonatomic, strong)UIScrollView *contentView;
@property (nonatomic, strong)NSMutableArray *tableViews;

@property (nonatomic, strong)NSArray *dataSource0;
@property (nonatomic, strong)NSArray *dataSource1;
@property (nonatomic, strong)NSArray *dataSource2;

@end

@implementation HHAddressView
static CGFloat const kHHTopViewHeight = 42.5; //顶部视图的高度
static CGFloat const kHHTabBarHeight = 44;  //地址标签栏的高度
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];

    self.tableViews = [NSMutableArray arrayWithCapacity:0];
    self.dataSource0 = [[HHAddressTool shareTool] dataSource0];

    HHAddressTopView *topV = [[HHAddressTopView alloc]initWithFrame:CGRectMake(0, 0, HHScreenWidth, kHHTopViewHeight)];
    [self addSubview:topV];
    
    self.tabBar = [[HHAddressTabBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topV.frame), HHScreenWidth, kHHTabBarHeight)];
    [self addSubview:self.tabBar];
    
    self.contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.tabBar.frame))];
    self.contentView.pagingEnabled = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.delegate = self;
    [self addSubview:self.contentView];
    
    [self addItem];
    
    // 必须得调一下layoutIfNeeded使tabBar调用一下layoutSubviews改变items的frame
    [self.tabBar layoutIfNeeded];
    self.tabBar.selectedIndex = self.tabBar.tabItems.count - 1;
}
- (void)addItem
{
    [self addTableView];
    [self addTabItem];
}
- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * HHScreenWidth, 0, HHScreenWidth, _contentView.frame.size.height)];
    tableView.rowHeight = 45.0f;
    [_contentView addSubview:tableView];
    [self.tableViews addObject:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[HHAddressCell class] forCellReuseIdentifier:@"HHAddressCell"];
}
- (void)addTabItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"请选择" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [button sizeToFit];
    [self.tabBar.tabItems addObject:button];
    [self.tabBar addSubview:button];
    [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ([self.tableViews indexOfObject:tableView]) {
        case 0:
            return self.dataSource0.count;
        case 1:
            return self.dataSource1.count;
        case 2:
            return self.dataSource2.count;
        default:
            return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHAddressCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch ([self.tableViews indexOfObject:tableView]) {
        case 0:
            [cell setData:self.dataSource0[indexPath.row]];
            break;
        case 1:
            [cell setData:self.dataSource1[indexPath.row]];
            break;
        case 2:
            [cell setData:self.dataSource2[indexPath.row]];
            break;
        default:
            break;
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.tableViews indexOfObject:tableView]) {
        case 0:
        {
            //获取下一级别点数据源
            self.dataSource1 = [[HHAddressTool shareTool] dataSource1];
            if (self.dataSource1.count == 0) {
                for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                    [self removeLastItem];
                }
                return indexPath;
            }
            // 判断是否是第一次选择，不是则重新选择省，切换省
            NSIndexPath *selectedIndexpath = [tableView indexPathForSelectedRow];
            if ([selectedIndexpath compare:indexPath] != NSOrderedSame && selectedIndexpath) {
                for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                    [self removeLastItem];
                }
                [self addItem];
                [self scrollToNextItem:self.dataSource0[indexPath.row]];
                return indexPath;
            } else if ([selectedIndexpath compare:indexPath] == NSOrderedSame && selectedIndexpath) {
                for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                    [self removeLastItem];
                }
                [self addItem];
                [self scrollToNextItem:self.dataSource0[indexPath.row]];
                return indexPath;
            }
            
            //之前未选中省，第一次选择省
            [self addItem];
            [self scrollToNextItem:self.dataSource0[indexPath.row]];
            return indexPath;
        }
        case 1:
        {
            self.dataSource2 = [[HHAddressTool shareTool] dataSource2];
            NSIndexPath *selectedIndexpath = [tableView indexPathForSelectedRow];
            if ([selectedIndexpath compare:indexPath] != NSOrderedSame && selectedIndexpath) {
                for (int i = 0; i < self.tableViews.count - 1; i++) {
                    [self removeLastItem];
                }
                [self addItem];
                [self scrollToNextItem:self.dataSource1[indexPath.row]];
                return indexPath;
            } else if ([selectedIndexpath compare:indexPath] == NSOrderedSame && selectedIndexpath) {
                [self scrollToNextItem:self.dataSource1[indexPath.row]];
                return indexPath;
            }
            [self addItem];
            [self scrollToNextItem:self.dataSource1[indexPath.row]];
            return indexPath;
        }
        case 2:
            [self finish:self.dataSource2[indexPath.row]];
            return indexPath;
        default:
            return indexPath;
    }
}
/// 将选中的cell改为选中状态
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHAddressModel *model;
    switch ([self.tableViews indexOfObject:tableView]) {
        case 0:
            model = self.dataSource0[indexPath.row];
            break;
        case 1:
            model = self.dataSource1[indexPath.row];
            break;
        case 2:
            model = self.dataSource2[indexPath.row];
            break;
        default:
            break;
    }
    model.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
/// 将之前选中状态的cell变为未选中状态
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHAddressModel *model;
    switch ([self.tableViews indexOfObject:tableView]) {
        case 0:
            model = self.dataSource0[indexPath.row];
            break;
        case 1:
            model = self.dataSource1[indexPath.row];
            break;
        case 2:
            model = self.dataSource2[indexPath.row];
            break;
        default:
            break;
    }
    model.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tabBar updateSubViewsWhenParentScrollViewScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.contentView) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / HHScreenWidth;
        weakSelf.tabBar.selectedIndex = index;
    }];
}

/// 点击按钮，滚动到对应位置
- (void)itemClick:(UIButton *)sender
{
    NSInteger index = [self.tabBar.tabItems indexOfObject:sender];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * HHScreenWidth, 0);
        self.tabBar.selectedIndex = index;
    }];
}

/// 当重新选择省或者市的时候，需要将下级视图移除
- (void)removeLastItem
{
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.tabBar.tabItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tabBar.tabItems removeLastObject];
}
// 滚动到下级界面，并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(HHAddressModel *)model
{
    NSInteger index = self.contentView.contentOffset.x / HHScreenWidth;
    UIButton *button = self.tabBar.tabItems[index];
    [button setTitle:model.title forState:UIControlStateNormal];
    [button sizeToFit];
    [_tabBar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * HHScreenWidth, 0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HHScreenWidth, offset.y);
        self.tabBar.selectedIndex = self.tabBar.tabItems.count - 1;
    }];
}

/// 完成选择
- (void)finish:(HHAddressModel *)model
{
    NSInteger index = self.contentView.contentOffset.x / HHScreenWidth;
    UIButton *button = self.tabBar.tabItems[index];
    [button setTitle:model.title forState:UIControlStateNormal];
    [button sizeToFit];
    [self.tabBar layoutIfNeeded];
    self.tabBar.selectedIndex = index;
}

#pragma mark - show hide
- (void)show
{
    UIView *bgV = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIView *tapV = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [bgV addSubview:tapV];
    bgV.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [bgV addSubview:self];
    [[UIApplication sharedApplication].windows[0] addSubview:bgV];
    [tapV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
}
- (void)tapAction:(UIGestureRecognizer *)sender
{
    [sender.view.superview removeFromSuperview];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
