//
//  HHChapterView.h
//  HHChapterDemo
//
//  Created by Michael on 2021/3/2.
//  Copyright © 2021 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHChapterView : UIView
@property (nonatomic, strong)NSMutableArray <HHChapterModel *>*objects;

@property (nonatomic, copy)void (^didSelectRow)(NSInteger index);
@property (nonatomic, copy)void (^didHidden)(void);
@property (nonatomic, copy)void (^refreshData)(NSMutableArray *dataArray);
- (void)setDataSource;
- (void)hiddenAction;
@end

NS_ASSUME_NONNULL_END
