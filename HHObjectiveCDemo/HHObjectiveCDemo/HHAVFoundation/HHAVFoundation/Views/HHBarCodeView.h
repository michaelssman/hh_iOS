//
//  HHBarCodeView.h
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/12/21.
//

#import "HHPreView.h"
#import "HHDetectionDelegate.h"

@class ScanAnimationView;

NS_ASSUME_NONNULL_BEGIN

@interface HHBarCodeView : HHPreView<HHDetectionDelegate>
@property (nonatomic, strong)ScanAnimationView *scanAnimationV;
@end


@interface ScanAnimationView : UIView

/// 开始动画
- (void)startAnimation;

/// 结束动画
- (void)stopAnimation;

@end
NS_ASSUME_NONNULL_END
