
#import "THCameraController.h"
//AVCaptureMetadataOutputObjectsDelegate录制视频媒体信息
@interface THCameraController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)AVCaptureMetadataOutput  *metadataOutput;
@end

@implementation THCameraController

- (BOOL)setupSessionOutputs:(NSError **)error {
    self.metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    //为捕捉会话添加一个输出
    if ([self.captureSession canAddOutput:self.metadataOutput]){
        [self.captureSession addOutput:self.metadataOutput];
        //获得人脸属性。指定元数据的类型，减少识别兴趣，只对人脸数据有兴趣
        NSArray *metadatObjectTypes = @[AVMetadataObjectTypeFace];
        //设置metadataObjectTypes 指定对象输出的元数据类型。
        /*
         限制检查到元数据类型集合的做法是一种优化处理方法。可以减少我们实际感兴趣的对象数量
         支持多种元数据。这里只保留对人脸元数据感兴趣
         */
        self.metadataOutput.metadataObjectTypes = metadatObjectTypes;
        //创建主队列： 因为人脸检测用到了硬件加速GPU，而且许多重要的任务都在主线程中执行，所以需要为这次参数指定主队列。
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //通过设置AVCaptureVideoDataOutput的代理，就能获取捕获到一帧一帧数据
        [self.metadataOutput setMetadataObjectsDelegate:self queue:mainQueue];
        return YES;
    } else {
        //报错
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Failed to still image output"};
            *error = [NSError errorWithDomain:THCameraErrorDomain code:THCameraErrorFailedToAddOutput userInfo:userInfo];
        }
        return NO;
    }
}

#pragma mark - 代理
//捕捉数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    //使用循环，打印人脸数据
    for (AVMetadataFaceObject *face in metadataObjects) {
        NSLog(@"Face detected with ID:%li",(long)face.faceID);//id唯一
        NSLog(@"Face bounds:%@",NSStringFromCGRect(face.bounds));//人脸位置
    }
    //已经获取视频中的人脸个数、人脸位置。下一步在预览图层处理人脸
    //将元数据 传递给 THPreviewView.m   将元数据转换为layer
    [self.detectionDelegate didDetect:metadataObjects];
}

@end


@interface HHQRCodeCameraController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)AVCaptureMetadataOutput  *metadataOutput;
@end
@implementation HHQRCodeCameraController

- (BOOL)setupSessionOutputs:(NSError **)error {
    self.metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    //为捕捉会话添加一个输出
    if ([self.captureSession canAddOutput:self.metadataOutput]){
        [self.captureSession addOutput:self.metadataOutput];
        //获得人脸属性。指定元数据的类型，减少识别兴趣，只对人脸数据有兴趣
        NSArray *metadatObjectTypes = @[AVMetadataObjectTypeQRCode];
        //设置metadataObjectTypes 指定对象输出的元数据类型。
        /*
         限制检查到元数据类型集合的做法是一种优化处理方法。可以减少我们实际感兴趣的对象数量
         支持多种元数据。这里只保留对人脸元数据感兴趣
         */
        self.metadataOutput.metadataObjectTypes = metadatObjectTypes;
        //创建主队列： 因为人脸检测用到了硬件加速GPU，而且许多重要的任务都在主线程中执行，所以需要为这次参数指定主队列。
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //通过设置AVCaptureVideoDataOutput的代理，就能获取捕获到一帧一帧数据
        [self.metadataOutput setMetadataObjectsDelegate:self queue:mainQueue];
        return YES;
    } else {
        //报错
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Failed to still image output"};
            *error = [NSError errorWithDomain:THCameraErrorDomain code:THCameraErrorFailedToAddOutput userInfo:userInfo];
        }
        return NO;
    }
}

#pragma mark - 代理
//捕捉数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"二维码啊：%@",metadataObjects);
    [self.detectionDelegate didDetect:metadataObjects];
}

@end


@interface HHBarCodeCameraController ()<AVCaptureMetadataOutputObjectsDelegate>
@end
@implementation HHBarCodeCameraController

- (BOOL)setupSessionOutputs:(NSError **)error {
    self.metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    //为捕捉会话添加一个输出
    if ([self.captureSession canAddOutput:self.metadataOutput]){
        [self.captureSession addOutput:self.metadataOutput];
        //获得人脸属性。指定元数据的类型，减少识别兴趣，只对人脸数据有兴趣
        NSArray *metadatObjectTypes = @[AVMetadataObjectTypeUPCECode,
                                        AVMetadataObjectTypeCode39Code,
                                        AVMetadataObjectTypeCode39Mod43Code,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode93Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypeInterleaved2of5Code,
                                        AVMetadataObjectTypeITF14Code,
                                        AVMetadataObjectTypeAztecCode,
                                        AVMetadataObjectTypeInterleaved2of5Code,
                                        AVMetadataObjectTypeDataMatrixCode];
        //设置metadataObjectTypes 指定对象输出的元数据类型。
        /*
         限制检查到元数据类型集合的做法是一种优化处理方法。可以减少我们实际感兴趣的对象数量
         支持多种元数据。这里只保留对人脸元数据感兴趣
         */
        self.metadataOutput.metadataObjectTypes = metadatObjectTypes;
        //创建主队列： 因为人脸检测用到了硬件加速GPU，而且许多重要的任务都在主线程中执行，所以需要为这次参数指定主队列。
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //通过设置AVCaptureVideoDataOutput的代理，就能获取捕获到一帧一帧数据
        [self.metadataOutput setMetadataObjectsDelegate:self queue:mainQueue];
        return YES;
    } else {
        //报错
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"Failed to still image output"};
            *error = [NSError errorWithDomain:THCameraErrorDomain code:THCameraErrorFailedToAddOutput userInfo:userInfo];
        }
        return NO;
    }
}

#pragma mark - 代理
//捕捉数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"条形码啊：%@",metadataObjects);
    
    if ([metadataObjects count] > 0) {
        
        [self stopSession];
        
        AVMetadataMachineReadableCodeObject *metadataCode = [metadataObjects objectAtIndex:0];
        
        NSLog(@"%@",metadataCode);
        
        NSString *stringValue = metadataCode.stringValue;
        
        //条形码是UPC-A码
        //UPC-A码长度是12位的，EAN13码长度是13位的，苹果将UPC-A条码和EAN13条码放到了一起不做区分！UPC-A条码实际上是EAN-13条码的子集。如果一个EAN-13条码的第一位数字是0，那么这个条码既是EAN-13码也同样是是UPC-A码（去掉开头的0）。
        //解决方法：以0开头的EAN13码实际上就是UPC-A码在前面补了一个0，在AVFoundation扫描得到的结果里只需要判断条码的类别是否AVMetadataObjectTypeEAN13Code并且是否以0开头，如果是的话就把第一位的0直接删掉就好了。
        if ([metadataCode.type isEqualToString:@"org.gs1.EAN-13"] && [metadataCode.stringValue hasPrefix:@"0"]) {
            stringValue = [metadataCode.stringValue substringFromIndex:1];
        } else {
            stringValue = metadataCode.stringValue;
        }
        
        NSLog(@"扫描得到的：%@",stringValue);
        [self.detectionDelegate didDetect:metadataObjects];
    }
}

@end
