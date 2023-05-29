//
//  BaseTextField.h
//  yyt-teacher
//
//  Created by ebsinori on 16/7/19.
//  Copyright © 2016年 ebsinori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField

@property (nonatomic, assign)BOOL isSecureText;
@property (nonatomic, assign)CGFloat leftPadding;

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder andClearButton:(BOOL)hasBtn;

@end
