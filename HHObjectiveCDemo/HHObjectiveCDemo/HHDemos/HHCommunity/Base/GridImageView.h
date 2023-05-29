//
//  GridImageView.h
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PicWidth MIN(120.0, (maxWidth - 30.0) / 3.0)

@interface GridImageView : UIView

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, assign)CGFloat pictureWidth;

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth;

- (void)setSmallPictures:(NSArray *)smallPics largePictures:(NSArray *)largePics;

@end
