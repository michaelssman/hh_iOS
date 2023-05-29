#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import "THCameraControllerDelegate.h"

FOUNDATION_EXPORT NSString * const THCameraErrorDomain;
FOUNDATION_EXPORT NSString *const THThumbnailCreatedNotification;

typedef NS_ENUM(NSInteger, THCameraErrorCode) {
    THCameraErrorFailedToAddInput = 98,
	THCameraErrorFailedToAddOutput,
};

@interface THBaseCameraController : NSObject

@property (weak, nonatomic) id<THCameraControllerDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;

// Session Configuration
- (BOOL)setupSession:(NSError **)error;
- (BOOL)setupSessionInputs:(NSError **)error;
- (BOOL)setupSessionOutputs:(NSError **)error;
- (void)startSession:(void(^)(void))didStartBlock;
- (void)stopSession;

// Camera Device Support
- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;
@property (nonatomic, readonly) NSUInteger cameraCount;
@property (nonatomic, readonly) AVCaptureDevice *activeCamera;

// 聚焦、曝光、重设聚焦、曝光的方法
- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;

// Still Image Capture
- (void)captureStillImage;

// Video Recording
- (void)startRecording;
- (void)stopRecording;
- (BOOL)isRecording;

@end
