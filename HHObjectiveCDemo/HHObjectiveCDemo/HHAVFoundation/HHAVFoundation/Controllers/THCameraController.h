
#import <AVFoundation/AVFoundation.h>
#import "THBaseCameraController.h"
#import "HHDetectionDelegate.h"

@interface THCameraController : THBaseCameraController
@property (weak, nonatomic) id <HHDetectionDelegate> detectionDelegate;
@end


@interface HHQRCodeCameraController : THBaseCameraController
@property (weak, nonatomic) id <HHDetectionDelegate> detectionDelegate;
@end

@interface HHBarCodeCameraController : THBaseCameraController
@property(nonatomic,strong)AVCaptureMetadataOutput  *metadataOutput;
@property (weak, nonatomic) id <HHDetectionDelegate> detectionDelegate;
@end
