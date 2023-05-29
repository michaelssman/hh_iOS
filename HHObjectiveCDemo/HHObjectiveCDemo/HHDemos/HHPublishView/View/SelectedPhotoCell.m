//
//  SelectedPhotoCell.m
//  yyt-teacher
//
//  Created by ebsinori on 16/8/19.
//  Copyright © 2016年 ebsinori. All rights reserved.
//

#import "SelectedPhotoCell.h"
#import <Masonry.h>
@implementation SelectedPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.photoView = [[UIImageView alloc] init];
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.contentMode = UIViewContentModeScaleAspectFit;
        [self.cancelButton setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.cancelButton];
        
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(8, 0, 0, 8));
        }];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return self;
}

@end
