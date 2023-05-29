//
//  HHCardView.m
//  CardDemo
//
//  Created by Michael on 2020/9/5.
//  Copyright © 2020 michael. All rights reserved.
//

/**
每移除一个就在最后自动添加一个新的，永远是5条。
*/

#import "HHCardView.h"
#import "HHCardCell.h"
#define kPageSize   5
@interface HHCardView ()<HHCardCellDelegate>
@property (nonatomic, assign)NSInteger itemViewCount;
@property (nonatomic, assign)NSInteger lastIndex;
@end

@implementation HHCardView

- (void)deleteTheTopItemViewWithLeft:(BOOL)left {
    HHCardCell *cardCell = (HHCardCell *)self.subviews.lastObject;
    [cardCell removeWithLeft:left];
}

- (void)reloadData {
    
    if (_dataSource == nil) {
        return ;
    }
    
    // 1. 移除
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 2. 创建
    _itemViewCount = [self numberOfItemViews];
    _lastIndex = (_itemViewCount > kPageSize ? kPageSize : _itemViewCount) - 1;
    for (int i = 0; i < _lastIndex; i++) {
        [self addCellAtIndex:i];
    }
}

- (void)addCellAtIndex:(NSInteger)i {
    CGSize size = [self itemViewSizeAtIndex:i];
    
    HHCardCell *itemView = [self itemViewAtIndex:i];
//    [self addSubview:itemView];
    [self insertSubview:itemView atIndex:0];
    itemView.delegate = self;
    
    itemView.frame = CGRectMake(self.frame.size.width / 2.0 - size.width / 2.0, self.frame.size.height / 2.0 - size.height / 2.0, size.width, size.height);
    itemView.tag = i + 1;

    if (i < kPageSize) {
        //缩放
        CGAffineTransform scaleTransfrom = CGAffineTransformMakeScale(1 - 0.005 * (10 - i), 1);
        // x y 坐标
        itemView.transform = CGAffineTransformTranslate(scaleTransfrom, 0, 1.5 * i);
    } else {
        CGAffineTransform scaleTransfrom = CGAffineTransformMakeScale(1 - 0.005 * (10 - kPageSize - 1), 1);
        itemView.transform = CGAffineTransformTranslate(scaleTransfrom, 0, 1.5 * (kPageSize - 1));
    }
    
    [UIView animateKeyframesWithDuration:0.05 delay:0.01 * i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        for (int index = 0; index < self.subviews.count; index ++) {
            CGAffineTransform scaleTransfrom = CGAffineTransformMakeScale((1 + 0.005 * index), 1);
            HHCardCell *cell = self.subviews[index];
            cell.transform = CGAffineTransformTranslate(scaleTransfrom, 0, -5 * index);
        }
     } completion:nil];
    
    itemView.userInteractionEnabled = YES;
    [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestHandle:)]];
}

- (CGSize)itemViewSizeAtIndex:(NSInteger)index {
    
    if ([self.dataSource respondsToSelector:@selector(cardView:sizeForItemViewAtIndex:)] && index < [self numberOfItemViews]) {
        CGSize size = [self.dataSource cardView:self sizeForItemViewAtIndex:index];
        if (size.width > self.frame.size.width || size.width == 0) {
            size.width = self.frame.size.width;
        } else if (size.height > self.frame.size.height || size.height == 0) {
            size.height = self.frame.size.height;
        }
        return size;
    }
    return self.frame.size;
}

- (HHCardCell *)itemViewAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(cardView:itemViewAtIndex:)]) {
        HHCardCell *itemView = [self.dataSource cardView:self itemViewAtIndex:index];
        if (itemView == nil) {
            return [[HHCardCell alloc] init];
        } else {
            return itemView;
        }
    }
    return [[HHCardCell alloc] init];
}

- (NSInteger)numberOfItemViews {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemViewsInCardView:)]) {
        return [self.dataSource numberOfItemViewsInCardView:self];
    }
    return 0;
}

- (void)tapGestHandle:(UITapGestureRecognizer *)tapGest {
    if ([self.delegate respondsToSelector:@selector(cardView:didClickItemAtIndex:)]) {
        [self.delegate cardView:self didClickItemAtIndex:tapGest.view.tag - 1];
    }
}

- (void)cardCellViewDidRemoveFromSuperView:(HHCardCell *)cardCell {
    //加载更多
    if (_itemViewCount > 0) {
        _itemViewCount -= 1;
        if (_itemViewCount == 0) {
            if ([self.dataSource respondsToSelector:@selector(cardViewNeedMoreData:)]) {
                [self.dataSource cardViewNeedMoreData:self];
            }
        }
        else {
            _lastIndex++;
            [self addCellAtIndex:_lastIndex];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
