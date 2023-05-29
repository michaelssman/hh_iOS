//
//  ChapterCornerView.h
//  HHChapterDemo
//
//  Created by Michael on 2021/3/19.
//  Copyright © 2021 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHChapterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChapterCornerView : UIView
@property (nonatomic, strong)UIView *cornerView;
@property (nonatomic, strong)HHChapterView *chapterV;
- (void)hiddenAction;
@end

NS_ASSUME_NONNULL_END
