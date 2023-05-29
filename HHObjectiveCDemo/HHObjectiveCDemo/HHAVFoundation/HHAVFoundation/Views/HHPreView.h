//
//  HHPreView.h
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/12/21.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHPreView : UIView
@property (strong, nonatomic) AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

//用于支持该类定义的不同触摸处理方法。 将屏幕坐标系上的触控点转换为摄像头上的坐标系点
- (CGPoint)captureDevicePointForPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
