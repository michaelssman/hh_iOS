//
//  TableViewCellBase.h
//  HHDesignPatterns
//
//  Created by Michael on 2021/3/24.
//  Copyright © 2021 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCellBase : UITableViewCell
- (void)setDataWithModel:(id)model;
+ (CGFloat)heightWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
