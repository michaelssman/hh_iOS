//
//  SelectPictureView.m
//  YYT_art
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SelectPictureView.h"
#import "SelectedPhotoCell.h"
#import <Masonry.h>
#define ThumbnailSize   70
#define ItemPadding     5
#define RowItemsCount   floor((SCREEN_WIDTH - 20) / (ThumbnailSize + ItemPadding))

@interface SelectPictureView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@end
@implementation SelectPictureView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(ThumbnailSize, ThumbnailSize);
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.minimumInteritemSpacing = ItemPadding;
        flowLayout.minimumLineSpacing = ItemPadding;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[SelectedPhotoCell class] forCellWithReuseIdentifier:@"photoCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.pictureAssets = [NSMutableArray array];
        
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];

    }
    return self;
}

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictureAssets.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UIImageView *plusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_plus_rect"]];
        [cell.contentView addSubview:plusView];
        [plusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        return cell;
    } else {
        SelectedPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
        cell.cancelButton.tag = indexPath.row;
        [cell.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)cancelAction:(UIButton *)sender {
    [self.pictureAssets removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.selectPictures) {
        self.selectPictures();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
