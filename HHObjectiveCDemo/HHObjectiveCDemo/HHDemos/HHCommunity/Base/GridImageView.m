//
//  GridImageView.m
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "GridImageView.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>

@interface GridImageView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)NSArray *smallPictures;
@property (nonatomic, strong)NSArray *largePictures;
@end

@implementation GridImageView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.pictureWidth, self.pictureWidth);
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GridImageViewCell"];
    }
    return _collectionView;
}

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.pictureWidth = PicWidth;
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setSmallPictures:(NSArray *)smallPics largePictures:(NSArray *)largePics {
    self.smallPictures = [NSArray arrayWithArray:smallPics];
    self.largePictures = [NSArray arrayWithArray:largePics];
}

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.smallPictures.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridImageViewCell" forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.smallPictures[indexPath.row]] placeholderImage:[UIImage imageNamed:@""]];
    [cell.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"预览图片");
//    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < self.smallPictures.count; i++) {
//        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
//        browseItem.bigImageUrl = self.largePictures[i];
//        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        browseItem.smallImageView = cell.contentView.subviews[0];
//        [browseItemArray addObject:browseItem];
//    }
//    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.row];
//    [bvc showBrowseViewController];
}


@end
