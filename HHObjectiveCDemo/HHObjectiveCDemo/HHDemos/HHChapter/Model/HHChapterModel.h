//
//  HHChapterModel.h
//  HHChapterDemo
//
//  Created by Michael on 2019/8/6.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHChapterBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHChapterModel : HHChapterBaseModel
@property (nonatomic, copy)NSString *TypeName;
@property (nonatomic, strong)NSArray <HHChapterModel *> *ChildrenModels;
@end

NS_ASSUME_NONNULL_END
