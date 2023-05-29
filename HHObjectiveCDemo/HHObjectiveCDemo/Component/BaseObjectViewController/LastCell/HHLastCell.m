//
//  HHLastCell.m
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HHLastCell.h"
@interface HHLastCell ()
@property (nonatomic, strong)UIActivityIndicatorView *indicator;
@end

@implementation HHLastCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _status = LastCellStatusNotVisible;
        _emptyMessage = @"暂无内容";
        [self setLayout];
    }
    return self;
}
- (void)setLayout {
    _textLabel.textColor = [UIColor redColor];
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kBottomHeight)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_textLabel];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - kBottomHeight, self.bounds.size.width, kBottomHeight)];
    [self addSubview:bottomView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _indicator.color = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1.0];
    _indicator.center = self.center;
    [self addSubview:_indicator];
}
- (BOOL)shouldResponseToTouch
{
    return _status == LastCellStatusMore || _status == LastCellStatusError;
}
- (void)setStatus:(LastCellStatus)status
{
    if (status == LastCellStatusLoading) {
        [_indicator startAnimating];
        _indicator.hidden = NO;
    } else {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
    
    _textLabel.text = @[
                        @"",
                        _moreMessage ?: @"更多…",
                        @"",
                        _errorMessage ?: @"点击重新加载",
                        _finishedMessage ?: @"暂无更多",
                        @"",
                        ][status];
    
    self.frame = CGRectMake(0, 0, self.bounds.size.width, TableLastCellHeight);
    
    _status = status;
}

@end
