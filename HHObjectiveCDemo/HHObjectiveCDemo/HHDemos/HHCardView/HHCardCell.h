//
//  HHCardCell.h
//  CardDemo
//
//  Created by Michael on 2020/9/5.
//  Copyright © 2020 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HHCardCell;
@protocol HHCardCellDelegate <NSObject>
- (void)cardCellViewDidRemoveFromSuperView:(HHCardCell *)cardCell;
@end

@interface HHCardCell : UIView
@property (nonatomic, weak) id <HHCardCellDelegate> delegate;
- (void)removeWithLeft:(BOOL)left;
@end

NS_ASSUME_NONNULL_END
