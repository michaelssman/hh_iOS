//
//  KeyboardWithTextView.h
//  HHKeyboard
//
//  Created by Michael on 2021/2/25.
//  Copyright © 2021 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHKeyBoardView.h"
NS_ASSUME_NONNULL_BEGIN

@interface KeyboardWithTextView : UIView<KeyBoardViewDelegate>
@property (nonatomic, strong)HHKeyBoardView *kbV;
@property (nonatomic, strong)UITextField *textField;
@end

NS_ASSUME_NONNULL_END
