//
//  MVPTableViewCell.h
//  HHMVX
//
//  Created by Michael on 2021/5/10.
//  Copyright © 2021 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVPTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *subBtn;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, assign) int num;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<PresentProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
