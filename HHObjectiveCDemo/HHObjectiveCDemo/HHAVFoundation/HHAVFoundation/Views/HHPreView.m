//
//  HHPreView.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/12/21.
//

#import "HHPreView.h"

@interface HHPreView ()
@end

@implementation HHPreView

//重写layerClass方法
+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    //图层的填充方式。设置videoGravity 使用AVLayerVideoGravityResizeAspectFill 铺满整个预览层的边界范围
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

//会话的get方法
- (AVCaptureSession*)session {
    return self.previewLayer.session;
}

//会话的set方法
- (void)setSession:(AVCaptureSession *)session {
    self.previewLayer.session = session;
}

//获得layer
- (AVCaptureVideoPreviewLayer *)previewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}


//用于支持该类定义的不同触摸处理方法。 将屏幕坐标系上的触控点转换为摄像头上的坐标系点
- (CGPoint)captureDevicePointForPoint:(CGPoint)point {
    AVCaptureVideoPreviewLayer *layer =
        (AVCaptureVideoPreviewLayer *)self.layer;
    return [layer captureDevicePointOfInterestForPoint:point];
}
@end
