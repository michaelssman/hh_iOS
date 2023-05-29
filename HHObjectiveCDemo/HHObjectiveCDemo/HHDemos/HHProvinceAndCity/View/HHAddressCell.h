//
//  HHAddressCell.h
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HHAddressCell : UITableViewCell
- (void)setData:(HHAddressModel *)model;
@end

NS_ASSUME_NONNULL_END
