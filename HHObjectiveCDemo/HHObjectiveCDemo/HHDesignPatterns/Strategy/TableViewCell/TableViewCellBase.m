//
//  TableViewCellBase.m
//  HHDesignPatterns
//
//  Created by Michael on 2021/3/24.
//  Copyright © 2021 michael. All rights reserved.
//

#import "TableViewCellBase.h"

@implementation TableViewCellBase

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(id)model
{
    
}

+ (CGFloat)heightWithModel:(id)model
{
    return 100;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
