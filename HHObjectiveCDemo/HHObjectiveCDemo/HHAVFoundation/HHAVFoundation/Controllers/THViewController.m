
#import "THViewController.h"
#import "THCameraController.h"
#import "THPreviewView.h"
#import "HHBarCodeView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface THViewController ()

@property (strong, nonatomic) THCameraController *cameraController;
@property (strong, nonatomic) THPreviewView *previewView;
@property (nonatomic, strong)HHQRCodeCameraController *qrCodeController;
@property (nonatomic, strong)HHBarCodeCameraController *barCodeController;
@property (nonatomic, strong)HHBarCodeView *preView;

@end

@implementation THViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSError *error;
//    self.previewView = [[THPreviewView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:self.previewView];
//    self.cameraController = [[THCameraController alloc] init];
//    if ([self.cameraController setupSession:&error]) {
//        [self.cameraController switchCameras];//切换摄像头
//        [self.previewView setSession:self.cameraController.captureSession];
//        self.cameraController.detectionDelegate = self.previewView;
//        [self.cameraController startSession];
//    } else {
//        NSLog(@"Error: %@", [error localizedDescription]);
//    }

//    self.qrCodeController = [[HHQRCodeCameraController alloc]init];
//    if ([self.qrCodeController setupSession:&error]) {
//        [self.previewView setSession:self.qrCodeController.captureSession];
//        [self.qrCodeController startSession];
//    } else {
//        NSLog(@"Error: %@", [error localizedDescription]);
//    }
    
    
    self.preView = [[HHBarCodeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT)];
    self.preView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.preView];
    self.barCodeController = [[HHBarCodeCameraController alloc]init];
    if ([self.barCodeController setupSession:&error]) {
        [self.preView setSession:self.barCodeController.captureSession];
        self.barCodeController.detectionDelegate = self.preView;
        [self.barCodeController startSession:^{
            // 设置有效的扫描区域(兴趣区域为扫描框内的区域)
            self.barCodeController.metadataOutput.rectOfInterest = [self.preView.previewLayer metadataOutputRectOfInterestForRect:self.preView.scanAnimationV.frame];
            //        self.preView.backgroundColor = [UIColor clearColor];
            NSLog(@"😂rectOfInterest1:%@",NSStringFromCGRect(self.barCodeController.metadataOutput.rectOfInterest));
        }];
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

@end
