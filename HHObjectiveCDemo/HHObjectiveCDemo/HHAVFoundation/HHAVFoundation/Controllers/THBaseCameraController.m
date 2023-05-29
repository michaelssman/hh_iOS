
//采集视频音频

#import "THBaseCameraController.h"
#import "NSFileManager+THAdditions.h"

NSString *const THCameraErrorDomain = @"com.tapharmonic.THCameraErrorDomain";
NSString *const THThumbnailCreatedNotification = @"THThumbnailCreated";

@interface THBaseCameraController () <AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;//捕捉会话
@property (weak, nonatomic) AVCaptureDeviceInput *activeVideoInput;//输入
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;
@property (strong, nonatomic) NSURL *outputURL;

@property (strong, nonatomic) dispatch_queue_t videoQueue;//视频队列

@end

@implementation THBaseCameraController

#pragma mark - AVCaptureSession
- (BOOL)setupSession:(NSError **)error {
    //创建捕捉会话。AVCaptureSession 是捕捉场景的中心枢纽
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //设置图像的分辨率
    self.captureSession.sessionPreset = [self sessionPreset];
    
    if (![self setupSessionInputs:error]) {
        return NO;
    }
    
    if (![self setupSessionOutputs:error]) {
        return NO;
    }
    
    self.videoQueue = dispatch_queue_create("com.tapharmonic.VideoQueue", NULL);
    
    return YES;
}

- (NSString *)sessionPreset {
    /*
     AVCaptureSessionPresetHigh
     AVCaptureSessionPresetMedium
     AVCaptureSessionPresetLow
     AVCaptureSessionPreset640x480
     AVCaptureSessionPreset1280x720
     AVCaptureSessionPresetPhoto
     */
    return AVCaptureSessionPresetHigh;
}

#pragma mark - AVCaptureDevice 设置输入设备摄像头和麦克风
- (BOOL)setupSessionInputs:(NSError **)error {
    // MARK: 添加输入设备摄像头
    // Set up default camera device
    //拿到默认视频捕捉设备 iOS系统返回后置摄像头
    AVCaptureDevice *videoDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //将捕捉设备封装成AVCaptureDeviceInput
    //注意：为会话添加捕捉设备，必须将设备封装成AVCaptureDeviceInput对象
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    //判断videoInput是否有效
    if (videoInput) {
        //canAddInput：测试是否能被添加到会话中
        if ([self.captureSession canAddInput:videoInput]) {
            //将videoInput 添加到 captureSession中
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        } else {
            if (error) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                               @"Failed to add video input."};
                
                *error = [NSError errorWithDomain:THCameraErrorDomain
                                             code:THCameraErrorFailedToAddInput
                                         userInfo:userInfo];
            }
            return NO;
        }
    } else {
        return NO;
    }
    
    // MARK: 添加输入设备麦克风
    //选择默认音频捕捉设备 即返回一个内置麦克风
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //为这个设备创建一个捕捉设备输入
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    
    //判断audioInput是否有效
    if (audioInput) {
        //canAddInput：测试是否能被添加到会话中
        if ([self.captureSession canAddInput:audioInput])
        {
            //将audioInput 添加到 captureSession中
            [self.captureSession addInput:audioInput];
        }
    }else
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - 设置输出
- (BOOL)setupSessionOutputs:(NSError **)error {
    // Setup the still image output
    //AVCaptureStillImageOutput 实例 从摄像头捕捉静态图片
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    //配置字典：希望捕捉到JPEG格式的图片
    //self.imageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    
    //输出连接 判断是否可用，可用则添加到输出连接中去
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    } else {
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                           @"Failed to still image output."};
            *error = [NSError errorWithDomain:THCameraErrorDomain
                                         code:THCameraErrorFailedToAddOutput
                                     userInfo:userInfo];
        }
        return NO;
    }
    return YES;
}

#pragma mark - startSession
- (void)startSession:(void (^)(void))didStartBlock {
    //检查是否处于运行状态
    if (![self.captureSession isRunning]) {
        //使用同步调用会损耗一定的时间，则用异步的方式处理
        dispatch_async(self.videoQueue, ^{
            [self.captureSession startRunning];
            if (didStartBlock) {
                didStartBlock();
            }
        });
    }
}
#pragma mark - stopSession
- (void)stopSession {
    //检查是否处于运行状态
    if ([self.captureSession isRunning]) {
        //使用异步方式，停止运行
        dispatch_async(self.videoQueue, ^{
            [self.captureSession stopRunning];
        });
    }
}

#pragma mark - Device Configuration   配置摄像头支持的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    //获取可用视频设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历可用的视频设备 并返回position 参数值
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)activeCamera {
    //返回当前捕捉会话对应的摄像头的device 属性
    return self.activeVideoInput.device;
}

#pragma mark - 返回当前未激活的摄像头
- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    //通过查找当前激活摄像头的反向摄像头获得，如果设备只有1个摄像头，则返回nil
    if (self.cameraCount > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

//判断是否有超过1个摄像头可用
- (BOOL)canSwitchCameras {
    return self.cameraCount > 1;
}

//可用视频捕捉设备的数量
- (NSUInteger)cameraCount {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

#pragma mark - 切换摄像头
- (BOOL)switchCameras {
    //判断是否有多个摄像头
    if (![self canSwitchCameras]) {
        return NO;
    }
    
    //获取当前设备的反向设备
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    
    //将输入设备封装成AVCaptureDeviceInput
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    //判断videoInput 是否为nil
    if (videoInput) {
        //标注原配置变化开始
        [self.captureSession beginConfiguration];
        //将捕捉会话中，原本的捕捉输入设备移除
        [self.captureSession removeInput:self.activeVideoInput];
        
        //判断新的设备是否能加入
        if ([self.captureSession canAddInput:videoInput]) {
            //能加入成功，则将videoInput 作为新的视频捕捉设备
            [self.captureSession addInput:videoInput];
            //将获得设备 改为 videoInput
            self.activeVideoInput = videoInput;
        } else {
            //如果新设备，无法加入。则将原本的视频捕捉设备重新加入到捕捉会话中
            [self.captureSession addInput:self.activeVideoInput];
        }
        //配置完成后， AVCaptureSession commitConfiguration 会分批的将所有变更整合在一起。
        [self.captureSession commitConfiguration];
    } else {
        //创建AVCaptureDeviceInput 出现错误，则通知委托来处理该错误
        [self.delegate deviceConfigurationFailedWithError:error];
        return NO;
    }
    return YES;
}
/*
 AVCapture Device 定义了很多方法，让开发者控制ios设备上的摄像头。可以独立调整和锁定摄像头的焦距、曝光、白平衡。对焦和曝光可以基于特定的兴趣点进行设置，使其在应用中实现点击对焦、点击曝光的功能。
 还可以让你控制设备的LED作为拍照的闪光灯或手电筒的使用
 
 每当修改摄像头设备时，一定要先测试修改动作是否能被设备支持。并不是所有的摄像头都支持所有功能，例如牵制摄像头就不支持对焦操作，因为它和目标距离一般在一臂之长的距离。但大部分后置摄像头是可以支持全尺寸对焦。尝试应用一个不被支持的动作，会导致异常崩溃。所以修改摄像头设备前，需要判断是否支持
 */

#pragma mark - Focus Methods 点击聚焦方法的实现

- (BOOL)cameraSupportsTapToFocus {
    //询问激活中的摄像头是否支持兴趣点对焦
    return [[self activeCamera] isFocusPointOfInterestSupported];
}

- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self activeCamera];
    //是否支持兴趣点对焦 & 是否自动对焦模式
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        //锁定设备准备配置，如果获得了锁
        if ([device lockForConfiguration:&error]) {
            //将focusPointOfInterest属性设置CGPoint
            device.focusPointOfInterest = point;
            //focusMode 设置为AVCaptureFocusModeAutoFocus
            device.focusMode = AVCaptureFocusModeAutoFocus;
            //释放该锁定
            [device unlockForConfiguration];
        }else{
            //错误时，则返回给错误处理代理
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

#pragma mark - Exposure Methods   点击曝光的方法实现
- (BOOL)cameraSupportsTapToExpose {
    //询问设备是否支持对一个兴趣点进行曝光
    return [[self activeCamera] isExposurePointOfInterestSupported];
}

static const NSString *THCameraAdjustingExposureContext;

- (void)exposeAtPoint:(CGPoint)point {
    
    AVCaptureDevice *device = [self activeCamera];
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    
    //判断是否支持 AVCaptureExposureModeContinuousAutoExposure 模式
    if (device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode]) {
        [device isExposureModeSupported:exposureMode];
        NSError *error;
        //锁定设备准备配置
        if ([device lockForConfiguration:&error]) {
            //配置期望值
            device.exposurePointOfInterest = point;
            device.exposureMode = exposureMode;
            //判断设备是否支持锁定曝光的模式。
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                //支持，则使用kvo确定设备的adjustingExposure属性的状态。
                [device addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:&THCameraAdjustingExposureContext];
            }
            //释放该锁定
            [device unlockForConfiguration];
        } else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    //判断context（上下文）是否为THCameraAdjustingExposureContext
    if (context == &THCameraAdjustingExposureContext) {
        //获取device
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        //判断设备是否不再调整曝光等级，确认设备的exposureMode是否可以设置为AVCaptureExposureModeLocked
        if(!device.isAdjustingExposure && [device isExposureModeSupported:AVCaptureExposureModeLocked])
        {
            //移除作为adjustingExposure 的self，就不会得到后续变更的通知
            [object removeObserver:self forKeyPath:@"adjustingExposure" context:&THCameraAdjustingExposureContext];
            
            //异步方式调回主队列，
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    //修改exposureMode
                    device.exposureMode = AVCaptureExposureModeLocked;
                    //释放该锁定
                    [device unlockForConfiguration];
                } else {
                    [self.delegate deviceConfigurationFailedWithError:error];
                }
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//重新设置对焦&曝光
- (void)resetFocusAndExposureModes {
    AVCaptureDevice *device = [self activeCamera];
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    //获取对焦兴趣点 和 连续自动对焦模式 是否被支持
    BOOL canResetFocus = [device isFocusPointOfInterestSupported]&& [device isFocusModeSupported:focusMode];
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    //确认曝光度可以被重设
    BOOL canResetExposure = [device isFocusPointOfInterestSupported] && [device isExposureModeSupported:exposureMode];
    //回顾一下，捕捉设备空间左上角（0，0），右下角（1，1） 中心点则（0.5，0.5）
    CGPoint centPoint = CGPointMake(0.5f, 0.5f);
    NSError *error;
    //锁定设备，准备配置
    if ([device lockForConfiguration:&error]) {
        //焦点可设，则修改
        if (canResetFocus) {
            device.focusMode = focusMode;
            device.focusPointOfInterest = centPoint;
        }
        //曝光度可设，则设置为期望的曝光模式
        if (canResetExposure) {
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centPoint;
        }
        //释放锁定
        [device unlockForConfiguration];
    } else {
        [self.delegate deviceConfigurationFailedWithError:error];
    }
}

#pragma mark - Flash and Torch Modes    闪光灯 & 手电筒
//判断是否有闪光灯
- (BOOL)cameraHasFlash {
    return [[self activeCamera] hasFlash];
}

//闪光灯模式
- (AVCaptureFlashMode)flashMode {
    return [[self activeCamera] flashMode];
}

//设置闪光灯
- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    //获取会话
    AVCaptureDevice *device = [self activeCamera];
    //判断是否支持闪光灯模式
    if ([device isFlashModeSupported:flashMode]) {
        //如果支持，则锁定设备
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            //修改闪光灯模式
            device.flashMode = flashMode;
            //修改完成，解锁释放设备
            [device unlockForConfiguration];
        } else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

//是否支持手电筒
- (BOOL)cameraHasTorch {
    return [[self activeCamera] hasTorch];
}

//手电筒模式
- (AVCaptureTorchMode)torchMode {
    return [[self activeCamera] torchMode];
}

//设置是否打开手电筒
- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    AVCaptureDevice *device = [self activeCamera];
    if ([device isTorchModeSupported:torchMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        } else {
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

#pragma mark - Image Capture Methods 拍摄静态图片
/*
 AVCaptureStillImageOutput 是AVCaptureOutput的子类。用于捕捉图片
 */
- (void)captureStillImage {
    
    AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientation];
    }
    
    id handler = ^(CMSampleBufferRef sampleBuffer, NSError *error) {
        if (sampleBuffer != NULL) {
            
            NSData *imageData =
            [AVCaptureStillImageOutput
             jpegStillImageNSDataRepresentation:sampleBuffer];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            NSLog(@"保存图片: %@", image);
        } else {
            NSLog(@"NULL sampleBuffer: %@", [error localizedDescription]);
        }
    };
    // Capture still image
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                  completionHandler:handler];
}

#pragma mark - Video Capture Methods

- (BOOL)isRecording {
    return self.movieOutput.isRecording;
}

- (void)startRecording {
    
    if (![self isRecording]) {
        
        AVCaptureConnection *videoConnection =
        [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
        
        if ([videoConnection isVideoOrientationSupported]) {
            videoConnection.videoOrientation = self.currentVideoOrientation;
        }
        
        if ([videoConnection isVideoStabilizationSupported]) {
            videoConnection.enablesVideoStabilizationWhenAvailable = YES;
        }
        
        AVCaptureDevice *device = [self activeCamera];
        
        if (device.isSmoothAutoFocusSupported) {
            NSError *error;
            if ([device lockForConfiguration:&error]) {
                device.smoothAutoFocusEnabled = NO;
                [device unlockForConfiguration];
            } else {
                [self.delegate deviceConfigurationFailedWithError:error];
            }
        }
        
        self.outputURL = [self uniqueURL];
        [self.movieOutput startRecordingToOutputFileURL:self.outputURL
                                      recordingDelegate:self];
    }
}

//写入视频唯一文件系统URL
- (NSURL *)uniqueURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //temporaryDirectoryWithTemplateString  可以将文件写入的目的创建一个唯一命名的目录；
    NSString *dirPath = [fileManager temporaryDirectoryWithTemplateString:@"kamera.XXXXXX"];
    if (dirPath) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:@"kamera_movie.mov"];
        return  [NSURL fileURLWithPath:filePath];
    }
    return nil;
}

//停止录制
- (void)stopRecording {
    //是否正在录制
    if ([self isRecording]) {
        [self.movieOutput stopRecording];
    }
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    if (error) {
        [self.delegate mediaCaptureFailedWithError:error];
    } else {
        NSLog(@"保存视频: %@",[self.outputURL copy]);
    }
    self.outputURL = nil;
}

#pragma mark - Recoding Destination URL
//获取方向值
- (AVCaptureVideoOrientation)currentVideoOrientation {
    AVCaptureVideoOrientation orientation;
    //获取UIDevice 的 orientation
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}
@end
