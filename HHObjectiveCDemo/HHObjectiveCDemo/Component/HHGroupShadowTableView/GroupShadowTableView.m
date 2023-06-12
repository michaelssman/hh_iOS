//
//  GroupShadowTableView.m
//  GroupShadowTableViewDemo
//
//  Created by 崔辉辉 on 2020/1/16.
//  Copyright © 2020 huihui. All rights reserved.
//

#import "GroupShadowTableView.h"

@interface UIView (Util)
- (void)setShadowWithRadius:(CGFloat)radius
                     shadow:(BOOL)shadow
                    opacity:(CGFloat)opacity;
@end
@implementation UIView (Util)
- (void)setShadowWithRadius:(CGFloat)radius
                     shadow:(BOOL)shadow
                    opacity:(CGFloat)opacity
{
    self.layer.cornerRadius = radius;
    if (shadow) {
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = opacity;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 1;
        self.layer.shouldRasterize = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:radius] CGPath];
    }
    self.layer.masksToBounds = !shadow;
}
@end

#pragma mark - cell
@interface PlainTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

/// 是否显示分割线
@property (nonatomic,assign) BOOL showSeparator;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSInteger (^numberOfRowsInSection)(PlainTableViewCell *plainCell,NSInteger section);
@property (nonatomic, copy)UITableViewCell * (^cellForRowAtIndexPath)(PlainTableViewCell *plainCell,NSIndexPath *indexPath);
@property (nonatomic, copy)CGFloat (^heightForRowAtIndexPath)(PlainTableViewCell *plainCell,NSIndexPath *indexPath);
@property (nonatomic, copy)void (^didSelectRowAtIndexPath)(PlainTableViewCell *plainCell,NSIndexPath *indexPath);

- (void)deselectCell;
- (void)selectCell:(NSInteger)row;
@end

@interface GroupShadowTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)PlainTableViewCell *selectedCell;
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@end
@implementation GroupShadowTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self initializeUI];
    }
    return self;
}
- (void)initializeUI
{
    [self registerClass:[PlainTableViewCell class] forCellReuseIdentifier:@"PlainTableViewCell"];
    self.delegate = self;
    self.dataSource = self;
}
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    PlainTableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    [cell.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:animated];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.groupShadowDataSource && [self.groupShadowDataSource respondsToSelector:@selector(numberOfSectionsInGroupShadowTableView:)]) {
        return [self.groupShadowDataSource numberOfSectionsInGroupShadowTableView:self];
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlainTableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"PlainTableViewCell"];
    
    //分割线
    cell.showSeparator = self.showSeparator;
    cell.tableView.separatorInset = self.separatorInset;
    cell.tableView.separatorColor = self.separatorColor;
    
    if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:canSelectAtSection:)]) {
        cell.tableView.allowsSelection = [self.groupShadowDelegate groupShadowTableView:self canSelectAtSection:indexPath.section];
    }
    cell.tag = indexPath.section;//标记是第几组
    __weak typeof(self) weakSelf = self;
    [cell setNumberOfRowsInSection:^NSInteger(PlainTableViewCell *plainCell, NSInteger section) {
        if (weakSelf.groupShadowDataSource && [weakSelf.groupShadowDataSource respondsToSelector:@selector(groupShadowTableView:numberOfRowsInSection:)]) {
            return [weakSelf.groupShadowDataSource groupShadowTableView:weakSelf numberOfRowsInSection:section];
        }
        return 0;
    }];
    [cell setHeightForRowAtIndexPath:^CGFloat(PlainTableViewCell *plainCell, NSIndexPath *indexPath) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:plainCell.tag];
        if (weakSelf.groupShadowDelegate && [weakSelf.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:heightForRowAtIndexPath:)]) {
            return [weakSelf.groupShadowDelegate groupShadowTableView:weakSelf heightForRowAtIndexPath:newIndexPath];
        }
        return 0;
    }];
    [cell setCellForRowAtIndexPath:^UITableViewCell *(PlainTableViewCell *plainCell, NSIndexPath *indexPath) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:plainCell.tag];
        if (weakSelf.groupShadowDataSource && [weakSelf.groupShadowDataSource respondsToSelector:@selector(groupShadowTableView:cellForRowAtIndexPath:)]) {
            return [weakSelf.groupShadowDataSource groupShadowTableView:weakSelf cellForRowAtIndexPath:newIndexPath];
        }
        return nil;
    }];
    [cell setDidSelectRowAtIndexPath:^(PlainTableViewCell *plainCell, NSIndexPath *indexPath) {
        NSInteger actualSection = plainCell.tag;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:actualSection];
        if (weakSelf.selectedCell && weakSelf.selectedCell != plainCell) {
            [weakSelf.selectedCell deselectCell];
        }
        if (weakSelf.groupShadowDelegate && [weakSelf.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:didSelectRowAtIndexPath:)]) {
            [weakSelf.groupShadowDelegate groupShadowTableView:weakSelf didSelectRowAtIndexPath:newIndexPath];
        }
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:actualSection];
        self.selectedCell = plainCell;
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlainTableViewCell *pCell = (PlainTableViewCell *)cell;
    [pCell.tableView reloadData];
    if (indexPath.section == self.selectedIndexPath.section) {
        [self.selectedCell selectCell:self.selectedIndexPath.row];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRows = 0;
    if (self.groupShadowDataSource && [self.groupShadowDataSource respondsToSelector:@selector(groupShadowTableView:numberOfRowsInSection:)]) {
        totalRows = [self.groupShadowDataSource groupShadowTableView:self numberOfRowsInSection:indexPath.section];
    }
    CGFloat totalHeight = 0;
    for (int i = 0; i < totalRows; i++) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:heightForRowAtIndexPath:)]) {
            totalHeight += [self.groupShadowDelegate groupShadowTableView:self heightForRowAtIndexPath:newIndexPath];
        }
    }
    return totalHeight;
}

#pragma mark - header footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:viewForHeaderInSection:)]) {
        return [self.groupShadowDelegate groupShadowTableView:self viewForHeaderInSection:section];
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:heightForHeaderInSection:)]) {
        return [self.groupShadowDelegate groupShadowTableView:self heightForHeaderInSection:section];
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:viewForFooterInSection:)]) {
        return [self.groupShadowDelegate groupShadowTableView:self viewForFooterInSection:section];
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:heightForFooterInSection:)]) {
        return [self.groupShadowDelegate groupShadowTableView:self heightForFooterInSection:section];
    }
    return CGFLOAT_MIN;
}

#pragma mark - cell
- (__kindof UITableViewCell *)groupShadowTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlainTableViewCell *pCell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    return [pCell.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
}
@end



@implementation PlainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectInset(self.bounds, 15, 0) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView setShadowWithRadius:8 shadow:YES opacity:0.6];
}

//MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(self,self.tag);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.cellForRowAtIndexPath) {
        cell = self.cellForRowAtIndexPath(self,indexPath);
    }
    NSAssert(cell, @"Cell不能为空");
    return cell;
}
#pragma mark - 重点：设置每条cell的样式
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //圆角弧度半径
    CGFloat cornerRadius = 8.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    
    NSInteger numberOfRows = 0;
    if (self.numberOfRowsInSection) {
        numberOfRows = self.numberOfRowsInSection(self,self.tag);
    }
    
    BOOL needSeparator = NO;
    
    //只有一个cell的情况
    if (indexPath.row == 0 && numberOfRows == 1) {
        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    }
    //下面的是多个cell情况
    else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        /*
         起始坐标为左下角，设为p，
         （CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)
         (CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)
         然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
         */
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
        needSeparator = YES;
        
    }
    else if (indexPath.row == numberOfRows -1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    }
    else {
        CGPathAddRect(pathRef, nil, bounds);
        needSeparator = YES;
    }
    
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    CFRelease(pathRef);
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // 分割线
    if (self.showSeparator && needSeparator) {
        CALayer *lineLayer = [[CALayer alloc] init];
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        lineLayer.frame = CGRectMake(self.separatorInset.left, bounds.size.height - lineHeight, bounds.size.width - (self.separatorInset.left + self.separatorInset.right), lineHeight);
        lineLayer.backgroundColor = self.tableView.separatorColor.CGColor;
        [layer addSublayer:lineLayer];
    }
    
    //cell的背景view
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    // 选中背景
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    if (@available(iOS 13.0, *)) {
        backgroundLayer.fillColor = [UIColor systemGroupedBackgroundColor].CGColor;
    } else {
        // Fallback on earlier versions
        backgroundLayer.fillColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    [selectedBackgroundView.layer insertSublayer:backgroundLayer below:cell.layer];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
}

//MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(self,indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.heightForRowAtIndexPath) {
        return self.heightForRowAtIndexPath(self,indexPath);
    }
    return 0;
}

- (void)deselectCell {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}

- (void)selectCell:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

@end
