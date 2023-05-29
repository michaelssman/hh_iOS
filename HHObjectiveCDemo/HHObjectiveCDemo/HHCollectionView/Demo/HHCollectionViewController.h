//
//  FirstViewController.h
//  UICollectionViewClass
//
//  Created by laouhn on 15/11/2.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHCollectionViewController : UIViewController

@end

@interface CustomViewCell : UICollectionViewCell
@property (nonatomic, retain)UIImageView *photo;
@end

/*
 集合视图每个分区的区头和区尾都必须是UICollectionReusableView的子类
 */
@interface HeaderView : UICollectionReusableView
@property (nonatomic, retain)UILabel *titleLabel;
@end
