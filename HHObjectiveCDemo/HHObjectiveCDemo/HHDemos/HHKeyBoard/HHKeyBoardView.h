//
//  HHKeyBoardView.h
//  HHKeyboard
//
//  Created by Michael on 2020/1/7.
//  Copyright © 2020 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat collectionViewH;

@class HHKeyBoardView;
@protocol KeyBoardViewDelegate <NSObject>

@optional
- (void)didSelectSureButton:(HHKeyBoardView *)keyBoardView;
- (void)didSelectDeleteButton:(HHKeyBoardView *)keyBoardView;

@end

@interface HHKeyBoardView : UIView
@property (nonatomic, weak)id<KeyBoardViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
