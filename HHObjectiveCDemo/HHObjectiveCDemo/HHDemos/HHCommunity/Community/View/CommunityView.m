//
//  CommunityView.m
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "CommunityView.h"
#import "CommunityModel.h"
#import "GridImageView.h"
#import "NSDate+Util.h"
#import "UIImageView+WebCache.h"
#import <SCM-Swift.h>
#define ContentWidth    SCREEN_WIDTH - AvatarSize - 30
#define ContentFontSize 18
#define kButtonFont     [UIFont systemFontOfSize:11]
@interface CommunityView ()

@property (nonatomic, strong)UILabel *nicknameLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)GridImageView *pictureView;
@property (nonatomic, strong)UILabel *dateLabel;

@end

@implementation CommunityView

- (UIButton *)supportBtn {
    if (!_supportBtn) {
        _supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _supportBtn.titleLabel.font = kButtonFont;
        [_supportBtn setTitleColor:[UIColor hexColor:0x404548] forState:UIControlStateNormal];
        [_supportBtn setTitleColor:[UIColor hexColor:0x01C257] forState:UIControlStateSelected];
        [_supportBtn setImage:[UIImage imageNamed:@"icon_supportBtn"] forState:UIControlStateNormal];
        [_supportBtn setImage:[UIImage imageNamed:@"icon_supportBtn_sel"] forState:UIControlStateSelected];
        _supportBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _supportBtn;
}

- (UIButton *)commentCntBtn {
    if (!_commentCntBtn) {
        _commentCntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentCntBtn.titleLabel.font = kButtonFont;
        [_commentCntBtn setTitleColor:[UIColor hexColor:0x404548] forState:UIControlStateNormal];
        [_commentCntBtn setImage:[UIImage imageNamed:@"icon_commentBtn"] forState:UIControlStateNormal];
        [_commentCntBtn setImage:[UIImage imageNamed:@"icon_commentBtn_sel"] forState:UIControlStateHighlighted];
        _commentCntBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _commentCntBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpViews];
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpViews {
    self.avatarView = [[UIImageView alloc] init];
    
    self.nicknameLabel = [[UILabel alloc] initWithTextColor:[UIColor hexColor:0x404548] fontSize:14];
    self.contentLabel = [[UILabel alloc] initWithTextColor:[UIColor darkTextColor] fontSize:ContentFontSize];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.dateLabel = [[UILabel alloc] initWithTextColor:[UIColor hexColor:0x404548] fontSize:11];
    self.pictureView = [[GridImageView alloc] initWithMaxWidth:ContentWidth];
    
    [self addSubview:self.avatarView];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.pictureView];
    [self addSubview:self.dateLabel];
    [self addSubview:self.supportBtn];
    [self addSubview:self.commentCntBtn];
}

- (void)setUpConstraints {
    WEAKSELF
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(AvatarSize, AvatarSize));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.avatarView.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.avatarView.mas_top);
        make.right.mas_equalTo(-20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nicknameLabel.mas_left);
        make.top.equalTo(weakSelf.nicknameLabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(-10);
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.contentLabel.mas_left);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nicknameLabel.mas_left);
        make.bottom.mas_equalTo(-10);
        make.top.equalTo(weakSelf.pictureView.mas_bottom).offset(10);
    }];
    
    [self.commentCntBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.height.and.top.equalTo(weakSelf.dateLabel);
        make.right.mas_equalTo(-10);
    }];
    
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.height.and.top.equalTo(weakSelf.dateLabel);
        make.right.equalTo(weakSelf.commentCntBtn.mas_left).with.offset(-10);
    }];
}

- (void)setDataWithModel:(CommunityModel *)model {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@""]];
//    self.nicknameLabel.text = model.displayName;
//    self.contentLabel.text = model.content;
//    self.dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.createdTime] formattedDescription];
    self.nicknameLabel.text = @"我是昵称";
    self.contentLabel.text = model.content;
    self.dateLabel.text = @"05-23";
    [self.supportBtn setTitle:[NSString stringWithFormat:@"%d", model.likeNum] forState:UIControlStateNormal];
    self.supportBtn.selected = model.currentLike;
    [self.commentCntBtn setTitle:[NSString stringWithFormat:@"%d", model.postNum] forState:UIControlStateNormal];
    
    if (model.picture == nil || model.picture.count == 0) {
        [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else {
        CGFloat picW = self.pictureView.pictureWidth;
        
        NSUInteger picCount = model.picture.count;
        int row = ceilf(picCount / 3.0), col;
        if (picCount >= 3) {
            col = 3;
        } else {
            col = picCount % 3;
        }
        CGFloat picsHeight = (picW + 5.0) * row, picsWidth = (picW + 5) * col + 5;
        if (picCount == 1) {
            picW = picW * 2;
            picsWidth = picW;
            picsHeight = picW;
        } else if (picCount == 4) {
            picsWidth = (picW + 5) * 2 + 5;
        }
        
        [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(picsHeight);
            make.width.mas_equalTo(picsWidth);
        }];
        
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.pictureView.collectionView.collectionViewLayout;
        flowLayout.itemSize = CGSizeMake(picW, picW);
        self.pictureView.collectionView.collectionViewLayout = flowLayout;
        
        [self.pictureView setSmallPictures:model.smallPicture largePictures:model.picture];
        [self.pictureView.collectionView reloadData];
    }
}

@end
