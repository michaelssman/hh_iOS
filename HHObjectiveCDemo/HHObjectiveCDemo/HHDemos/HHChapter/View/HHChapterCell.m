//
//  HHChapterCell.m
//  HHChapterDemo
//
//  Created by Michael on 2019/9/20.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHChapterCell.h"
@interface HHChapterCell()
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UIButton *iconV;
@end
@implementation HHChapterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.bounds.size.width - 80, self.bounds.size.height)];
        self.titleLab.textColor = [UIColor lightGrayColor];
    }
    return _titleLab;
}
- (UIButton *)iconV
{
    if (!_iconV) {
        self.iconV = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.iconV setImage:[UIImage imageNamed:@"icon_zhankai"] forState:UIControlStateNormal];
        [self.iconV setImage:[UIImage imageNamed:@"icon_shouqi"] forState:UIControlStateSelected];
        [self.iconV addTarget:self action:@selector(iconAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconV;
}
- (void)setData:(HHChapterModel *)model {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.text = model.TypeName;
    if (model.selected) {
        self.titleLab.textColor = [UIColor colorWithRed:71/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
        UIColor *gbColor = [[UIColor colorWithRed:71/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] colorWithAlphaComponent:0.04];
        self.backgroundColor = gbColor;
    } else {
        self.titleLab.textColor = [UIColor lightGrayColor];
        self.backgroundColor = [UIColor clearColor];
    }
    CGFloat iconSize = 8,space = 4,iconMaxX = 20;
    for (int i = 0; i < model.grade - 1; i++) {
        UILabel *iconV = [UILabel new];
        iconV.frame = CGRectMake(20 + (space + iconSize) * i, (self.bounds.size.height - iconSize) * 0.5, iconSize, iconSize);
        iconV.layer.masksToBounds = YES;
        iconV.layer.cornerRadius = iconSize * 0.5;
        if (model.selected) {
            iconV.backgroundColor = [UIColor colorWithRed:71/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
        } else {
            iconV.backgroundColor = [UIColor lightGrayColor];
        }
        [self.contentView addSubview:iconV];
        iconMaxX = CGRectGetMaxX(iconV.frame);
    }
    self.titleLab.frame = CGRectMake(iconMaxX + 4, 0, self.bounds.size.width - 80, self.bounds.size.height);
    if (model.ChildrenModels.count) {
        [self.contentView addSubview:self.iconV];
        CGFloat imgSize = 15;
        self.iconV.selected = model.isOpen;
        self.iconV.frame = CGRectMake(self.bounds.size.width - imgSize - 20, (self.bounds.size.height - imgSize) * 0.5, imgSize, imgSize);
    }
}

- (void)iconAction
{
    if (self.openOrClose) {
        self.openOrClose();
    }
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
