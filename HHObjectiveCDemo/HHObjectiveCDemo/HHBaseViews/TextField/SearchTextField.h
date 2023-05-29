//
//  SearchTextField.h
//  LemonCloud
//
//  Created by Michael on 2018/2/24.
//  Copyright © 2018年 sunny. All rights reserved.
//

/**
 去除键盘上面的工具栏
 */

#import <UIKit/UIKit.h>

@interface SearchTextField : UITextField

/// 占位文字
@property (nonatomic, copy)NSString *placeholderString;
/// 占位文字字体大小
@property (nonatomic, strong)UIFont *placeholderFont;
/// 占位文字字体颜色
@property (nonatomic, strong)UIColor *placeholderColor;


@property (nonatomic, assign)CGFloat cornerRadius;
@property (nonatomic, strong)UIColor *cornerBackgroundColor;

@end
