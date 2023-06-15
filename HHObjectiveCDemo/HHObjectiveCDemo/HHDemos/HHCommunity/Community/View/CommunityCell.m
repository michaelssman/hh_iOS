//
//  CommunityCell.m
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "CommunityCell.h"
#import "CommunityModel.h"
#import <Masonry.h>
#define CellPadding     1.0

@implementation CommunityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor backgroundColor];
        
        self.communityView = [[CommunityView alloc] init];
        [self.contentView addSubview:self.communityView];
        
        [self.communityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CellPadding, 0, 0, 0));
        }];
    }
    return self;
}

- (void)setDataWithModel:(CommunityModel *)model {
    [self.communityView setDataWithModel:model];
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
