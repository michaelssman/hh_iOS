//
//  BaseTextField.m
//  yyt-teacher
//
//  Created by ebsinori on 16/7/19.
//  Copyright © 2016年 ebsinori. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder andClearButton:(BOOL)hasBtn {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor redColor];
        self.placeholder = placeHolder;
        self.textColor = [UIColor blueColor];
        if (hasBtn) {
            self.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
    return self;
}

- (void)setIsSecureText:(BOOL)isSecureText {
        self.secureTextEntry = isSecureText;
}

- (void)setLeftPadding:(CGFloat)leftPadding {
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftPadding, 1)];
    self.leftView.backgroundColor = [UIColor clearColor];
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
