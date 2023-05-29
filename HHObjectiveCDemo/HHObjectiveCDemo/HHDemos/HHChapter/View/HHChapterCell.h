//
//  HHChapterCell.h
//  HHChapterDemo
//
//  Created by Michael on 2019/9/20.
//  Copyright © 2019 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHChapterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HHChapterCell : UITableViewCell
- (void)setData:(HHChapterModel *)model;
@property (nonatomic, copy)void (^openOrClose)(void);

@end

NS_ASSUME_NONNULL_END
