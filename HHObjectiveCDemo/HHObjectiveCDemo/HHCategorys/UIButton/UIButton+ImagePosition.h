//
//  UIButton+ImagePosition.h
//  HHObjectiveCDemo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 ebsinori. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionLeft = 0,              //图片在左，文字在右，默认
    ImagePositionRight = 1,             //图片在右，文字在左
    ImagePositionTop = 2,               //图片在上，文字在下
    ImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (ImagePosition)
- (void)setImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing;
@end
