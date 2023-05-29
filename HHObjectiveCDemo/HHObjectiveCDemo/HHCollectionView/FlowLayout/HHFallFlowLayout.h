//
//  HHFallFlowLayout.h
//  HHBaseController
//
//  Created by Michael on 2019/7/30.
//  Copyright © 2019 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;

@class HHFallFlowLayout;

@protocol FallFlowLayoutDelegate <NSObject>

@required
///item height
- (CGFloat)fallFlowLayout:(HHFallFlowLayout *)fallFlowLayout
       itemHeightForWidth:(CGFloat)itemWidth
              atIndexPath:(NSIndexPath *)indexPath;
@optional
///section header size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(HHFallFlowLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section;

@end


@interface HHFallFlowLayout : UICollectionViewLayout

///总共多少列，默认是2
@property (nonatomic, assign) NSInteger columnCount;

///列间距，默认是0
@property (nonatomic, assign) NSInteger columnSpacing;

///行间距，默认是0
@property (nonatomic, assign) NSInteger rowSpacing;

///section与collectionView的间距，默认是（0，0，0，0）
@property (nonatomic, assign) UIEdgeInsets sectionInset;

///代理，用来计算item的高度
@property (nonatomic, weak) id<FallFlowLayoutDelegate> delegate;

+ (instancetype)fallFlowLayoutWithColumnCount:(NSInteger)columnCount;

- (instancetype)initWithColumnCount:(NSInteger)columnCount;

///同时设置列间距，行间距，sectionInset
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;

@end

NS_ASSUME_NONNULL_END
