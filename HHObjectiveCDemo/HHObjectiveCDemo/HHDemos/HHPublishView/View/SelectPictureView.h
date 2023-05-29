//
//  SelectPictureView.h
//  YYT_art
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPictureView : UIView
@property (nonatomic, strong)NSMutableArray *pictureAssets;

@property (nonatomic, copy)void (^selectPictures)(void);
@end
