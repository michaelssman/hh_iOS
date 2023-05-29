//
//  HHPlusPopView.h
//  HHPlusPopViewDemo
//
//  Created by Michael on 2018/8/3.
//  Copyright © 2018年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPlusPopView : UIView
/**
 弹出视图
 
 @param imgs 图片名字集合
 @param titles 文字集合
 @param selectBlock 点击的Item回调
 */
+ (instancetype)showWithImages:(NSArray *)imgs
                        titles:(NSArray *)titles
                   selectBlock:(void (^)(NSInteger index))selectBlock;

+ (instancetype)showWithImages:(NSArray *)imgs
                        titles:(NSArray *)titles
                   columnCount:(NSInteger)columnCount
                      rowCount:(NSInteger)rowCount
                   selectBlock:(void (^)(NSInteger index))selectBlock;

/// 列间距
@property (nonatomic, assign)CGFloat columnSpace;
/// 行间距
@property (nonatomic, assign)CGFloat rowSpace;

@property (nonatomic, strong)UIColor *scrollViewColor;

@property (nonatomic, strong)NSArray <UIButton *> *items;

/// 底部关闭按钮
@property (nonatomic, strong) UIImageView *shutImgView;

- (void)show;


/// 按钮颜色
@property (nonatomic, strong)UIColor *itemColor;

@end
