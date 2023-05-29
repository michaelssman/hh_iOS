//
//  HHChapterBaseModel.h
//  HHChapterDemo
//
//  Created by Michael on 2021/3/2.
//  Copyright © 2021 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHChapterBaseModel : NSObject
///是否展开子目录
@property (nonatomic, assign)BOOL isOpen;
/// 被选中
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)NSInteger grade;
@end

NS_ASSUME_NONNULL_END
