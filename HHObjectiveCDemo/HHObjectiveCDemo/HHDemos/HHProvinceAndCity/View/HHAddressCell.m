//
//  HHAddressCell.m
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHAddressCell.h"
@interface HHAddressCell()
@property (nonatomic, strong)UILabel *titleLab;
@end
@implementation HHAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLab = [UILabel new];
        self.titleLab.frame = self.contentView.bounds;
        self.titleLab.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}
- (void)setData:(HHAddressModel *)model
{
    self.titleLab.textColor = model.isSelected ? [UIColor redColor] : [UIColor blueColor];
    self.titleLab.text = model.title;
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
