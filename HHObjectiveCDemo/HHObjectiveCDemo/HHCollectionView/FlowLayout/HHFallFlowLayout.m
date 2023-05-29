//
//  HHFallFlowLayout.m
//  HHBaseController
//
//  Created by Michael on 2019/7/30.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHFallFlowLayout.h"
@interface HHFallFlowLayout ()
//用来记录每一列的最大y值
@property (nonatomic, strong) NSMutableDictionary *maxYDic;
//保存每一个item的attributes
@property (nonatomic, strong) NSMutableArray *attributesArray;
@end
@implementation HHFallFlowLayout
#pragma mark- 懒加载
- (NSMutableDictionary *)maxYDic {
    if (!_maxYDic) {
        _maxYDic = [[NSMutableDictionary alloc] init];
    }
    return _maxYDic;
}
- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attributesArray;
}
#pragma mark- 构造方法
- (instancetype)init {
    if (self = [super init]) {
        self.columnCount = 2;
    }
    return self;
}

- (instancetype)initWithColumnCount:(NSInteger)columnCount {
    if (self = [super init]) {
        self.columnCount = columnCount;
    }
    return self;
}
+ (instancetype)fallFlowLayoutWithColumnCount:(NSInteger)columnCount {
    return [[self alloc] initWithColumnCount:columnCount];
}

#pragma mark- 相关设置方法
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset {
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSepacing;
    self.sectionInset = sectionInset;
}

#pragma mark- 布局相关方法
#pragma mark 布局前的准备工作
- (void)prepareLayout {
    [super prepareLayout];
    
    for(NSInteger i = 0;i < self.columnCount; i++)
    {
        NSString * col = [NSString stringWithFormat:@"%ld",(long)i];
        self.maxYDic[col] = @0;
    }
    
    
    NSInteger section = [self.collectionView numberOfSections];
    [self.attributesArray removeAllObjects];
    for (NSInteger i = 0 ; i < section; i++) {
        
        //获取header的UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        [self.attributesArray addObject:headerAttrs];
        
        //获取item的UICollectionViewLayoutAttributes
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j++) {
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [self.attributesArray addObject:attrs];
        }
    }
    
}

#pragma mark 设置collectionView的可滚动范围(瀑布流必要实现)
- (CGSize)collectionViewContentSize {
    __block NSString *maxCol = @"0";
    //遍历字典，找出最长的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[maxCol] floatValue] < obj.floatValue) {
            maxCol = key;
        }
    }];
    
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxYDic[maxCol] floatValue] + self.sectionInset.bottom);
}

#pragma mark 返回对应indexPath的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //找出最短的那一列
    __block NSString *minCol = @"0";
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[minCol] floatValue] > obj.floatValue) {
            minCol = key;
        }
    }];
    
    //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    
    CGFloat itemHeight = 0;
    //获取item的高度，由外界计算得到
    if ([self.delegate respondsToSelector:@selector(fallFlowLayout:itemHeightForWidth:atIndexPath:)])
        itemHeight = [self.delegate fallFlowLayout:self itemHeightForWidth:itemWidth atIndexPath:indexPath];
    
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minCol.integerValue;
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDic[minCol] floatValue] + self.rowSpacing;
    
    //更新字典中的最大y值
    self.maxYDic[minCol] = @(itemY + itemHeight);
    
    
    //根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attributes;
}

#pragma mark 设置区头的属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    __block NSString * maxCol = @"0";
    //遍历找出最高的列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    
    //header
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    //size
    CGSize size = CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        size = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
    }
    CGFloat x = self.sectionInset.left;
    CGFloat y = [[self.maxYDic objectForKey:maxCol] floatValue] + self.sectionInset.top;
    
    //    跟新所有对应列的高度
    for(NSString *key in self.maxYDic.allKeys)
    {
        self.maxYDic[key] = @(y + size.height);
    }
    
    attri.frame = CGRectMake(x , y, size.width, size.height);
    return attri;
    
}

#pragma mark 返回所有当前在可视范围内的item的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return  self.attributesArray;
}

//在collectionView的bounds发生改变的时候刷新布局
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return !CGRectEqualToRect(self.collectionView.bounds, newBounds);
//}


@end
