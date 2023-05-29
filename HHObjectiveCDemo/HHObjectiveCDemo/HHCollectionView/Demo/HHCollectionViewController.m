//
//  FirstViewController.m
//  UICollectionViewClass
//
//  Created by laouhn on 15/11/2.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "HHCollectionViewController.h"
#import <MJRefresh.h>
@implementation CustomViewCell
//懒加载创建photo
- (UIImageView *)photo {
    if (!_photo) {
        self.photo = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _photo;
}
//当创建自定义cell的时候调用该方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photo];
    }
    return self;
}
@end

@implementation HeaderView
//懒加载创建标签
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    }
    return _titleLabel;
}
//重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}
@end

/*
 UICollectionView:集合视图。使用跟UITabelView的使用非常相似，均需要指定delegate和dataSource.不同的是UICollectionView在使用之前需要指定一种布局（UICollectionViewLayout的子类），并且集合视图的cell需要自定义，系统的cell不包含任何内容，无法使用。
 */
@interface HHCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation HHCollectionViewController

static void *collectionViewContentSize = &collectionViewContentSize;
static CGFloat itemMargin = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCollectionView];
    
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:collectionViewContentSize];
}
#pragma mark Create Collection View
- (void)createCollectionView {
    //1:创建一种布局(UICollectionViewFlowLayout是系统为我们提供的一种具体的布局样式)
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //修改每一个cell的尺寸
    flowLayout.itemSize = CGSizeMake(110, 100);
    //设置每一个分区展示的边缘范围
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //设置行和列之间的最小边距
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;//列和列之间的间距 竖线和竖线的间距
    //返回集合视图每一个分区的区头（区尾）的尺寸
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    //设置集合视图的滚动方向
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //2:创建集合视图
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    //修改集合视图的背景颜色-默认颜色黑色
    collectionView.backgroundColor = [UIColor whiteColor];
    //VIP:指定集合视图的dataSource和delegate
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //3:添加集合视图
    [self.view addSubview:collectionView];
    //4:注册对应的cell
    [collectionView registerClass:[CustomViewCell class] forCellWithReuseIdentifier:@"cell"];
    //为集合视图每一个分区设置区头或区尾的过程中首先需要注册区头（区尾）然后通过对应的协议方法在该方法中按照注册的区头（区尾）获得对应的区头（区尾）
    //5:注册对应的区头（区尾）
    /*
     UICollectionElementKindSectionHeader:代表注册的是分区的区头
     UICollectionElementKindSectionFooter：代表注册的是分区的区尾
     */
    [collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    collectionView.contentInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
    
    self.collectionView = collectionView;
}

#pragma mark 为UICollectionView添加整体的header view
- (void)setUpHeaderView {
    CGFloat headerHeight = 250;
    //自定义的headerView添加到collectionView上，collectionView设置contentInset。
    self.collectionView.contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, -headerHeight, self.collectionView.bounds.size.width, headerHeight);
    [self.collectionView addSubview:headerView];
    //MJRefresh刷新到时候需要设置
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = headerHeight;
}

#pragma mark CollectionView DataSource
//返回分区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
//返回每一个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}
//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        cell.photo.frame = CGRectMake(0, 0, cell.photo.frame.size.width, 120);
    } else {
        cell.photo.frame = CGRectMake(0, 0, cell.photo.frame.size.width, 100);
    }
    cell.photo.image = [UIImage imageNamed:@"333"];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
//返回每一个分区的区头或者区尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        //返回对应分区的区头
        HeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.titleLabel.text = @"小媳妇儿";
        return header;
    }
    return nil;
}
#pragma mark CollectionView Delegate
//当点击cell的时候调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了当前的cell");
}
#pragma mark 布局协议
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return CGSizeMake(110, 120);
    } else {
        return CGSizeMake(110, 100);
    }
}
#pragma mark 区头Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == collectionViewContentSize) {
        //
        CGFloat contentHeight = [change[NSKeyValueChangeNewKey] CGSizeValue].height;
        NSLog(@"%f",contentHeight);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize" context:collectionViewContentSize];
}

@end
