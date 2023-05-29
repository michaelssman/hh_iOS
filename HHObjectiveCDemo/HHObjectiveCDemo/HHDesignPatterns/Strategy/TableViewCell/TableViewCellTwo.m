//
//  TableViewCellTwo.m
//  HHDesignPatterns
//
//  Created by Michael on 2021/3/9.
//  Copyright © 2021 michael. All rights reserved.
//

#import "TableViewCellTwo.h"

@implementation TableViewCellTwo
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
    }
    return self;
}

- (void)setDataWithModel:(id)model
{
    [super setDataWithModel:model];
}

+ (CGFloat)heightWithModel:(id)model
{
    return [super heightWithModel:model];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
