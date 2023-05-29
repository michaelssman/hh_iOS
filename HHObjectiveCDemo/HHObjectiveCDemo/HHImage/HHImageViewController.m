//
//  ViewController.m
//  HHImage
//
//  Created by michael on 2021/10/25.
//

#import "HHImageViewController.h"

@interface HHImageViewController ()

@end

@implementation HHImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:imageV];
    [imageV setImage:[self testGIF]];
}

- (void)buttonAction{
    //加载图片的代码
    /**
     压缩过后的位图！！！解压缩的操作
     1、图片的大小和什么有关系？  width * height * 4bytes (ARGB)
     Data Buffert
     */
    UIImage *image = [UIImage imageNamed:@"logic"];
    /**
     image Buffer
     */
    //    _imageView.image = image;
    //    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(_imageView.image.CGImage));
    //    NSLog(@"%ld",[(__bridge NSData *)rawData length]);
}


- (void)testImageLoad{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        UIImage *image = [UIImage imageNamed:@"logic"];
    //        _imageView.image = image;
    //    });
    //    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(_imageView.image.CGImage));
    //    NSLog(@"%ld",[(__bridge NSData *)rawData length]);
}

- (void)testProgerss{
    NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"logic" ofType:@"png"]];
    //    bool finished = (data.len
    //    CGImageSourceRef source;
    //    // 更新数据
    //    CGImageSourceUpdateData(source, (__bridge CFDataRef)data, finished);
    //
    //    // 和普通解码过程一样
    //    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    //    //解码的操作！！！
    //    CGImageSourceCreateThumbnailAtIndex(<#CGImageSourceRef  _Nonnull isrc#>, <#size_t index#>, <#CFDictionaryRef  _Nullable options#>)
}


#pragma mark - Image/IO解码
#pragma mark - 解码
- (UIImage *)testJPEGPNG{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logic" ofType:@"png"]];
    //输入源！！！
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //获取图片的类型
    NSString *typeStr = (__bridge NSString *)CGImageSourceGetType(sourceRef);
    //获取图像的数量
    NSUInteger count = CGImageSourceGetCount(sourceRef);
    
    NSDictionary *properties = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(sourceRef, 0, NULL);
    NSUInteger width = [properties[(__bridge NSString *)kCGImagePropertyPixelWidth] unsignedIntegerValue]; //宽度，像素值
    NSUInteger height = [properties[(__bridge NSString *)kCGImagePropertyPixelHeight] unsignedIntegerValue]; //高度，像素值
    BOOL hasAlpha = [properties[(__bridge NSString *)kCGImagePropertyHasAlpha] boolValue]; //是否含有Alpha通道
    CGImagePropertyOrientation exifOrientation = (CGImagePropertyOrientation)[properties[(__bridge NSString *)kCGImagePropertyOrientation] unsignedIntegerValue]; // 这里也能直接拿到EXIF方向信息，和前面的一样。如果是iOS 7，就用NSInteger取吧 :)
    
    //解码的操作！！！
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    
    // UIImageOrientation和CGImagePropertyOrientation枚举定义顺序不同，封装一个方法搞一个switch case就行
    UIImageOrientation imageOrientation = LG_YYUIImageOrientationFromEXIFValue(exifOrientation);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:imageOrientation];
    // 清理，都是C指针，避免内存泄漏
    CGImageRelease(imageRef);
    CFRelease(sourceRef);
    
    //解码过后的图片数据（imageBuffer）
    return image;
}
#pragma mark - 解码动图
- (UIImage *)testGIF{
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test@2x" withExtension:@"gif"];
    //    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"test@2x" ofType:@"gif"]];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    NSUInteger frameCount = CGImageSourceGetCount(source); //帧数
    //解码过后的数据！！！
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    double totalDuration = 0;
    for (size_t i = 0; i < frameCount; i++) {
        NSDictionary *properties = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSDictionary *gifProperties = properties[(NSString *)kCGImagePropertyGIFDictionary]; // GIF属性字典
        double duration = [gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime] doubleValue]; // GIF原始的帧持续时长，秒数
        CGImagePropertyOrientation exifOrientation = (CGImagePropertyOrientation)[properties[(__bridge NSString *)kCGImagePropertyOrientation] integerValue]; // 方向
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL); // CGImage
        UIImageOrientation imageOrientation = LG_YYUIImageOrientationFromEXIFValue(exifOrientation);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:imageOrientation];
        totalDuration += duration;
        [images addObject:image];
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    // 最后生成动图，动图的播放不准确！
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:totalDuration];
    return animatedImage;
}

UIImageOrientation LG_YYUIImageOrientationFromEXIFValue(NSInteger value) {
    switch (value) {
        case kCGImagePropertyOrientationUp: return UIImageOrientationUp;
        case kCGImagePropertyOrientationDown: return UIImageOrientationDown;
        case kCGImagePropertyOrientationLeft: return UIImageOrientationLeft;
        case kCGImagePropertyOrientationRight: return UIImageOrientationRight;
        case kCGImagePropertyOrientationUpMirrored: return UIImageOrientationUpMirrored;
        case kCGImagePropertyOrientationDownMirrored: return UIImageOrientationDownMirrored;
        case kCGImagePropertyOrientationLeftMirrored: return UIImageOrientationLeftMirrored;
        case kCGImagePropertyOrientationRightMirrored: return UIImageOrientationRightMirrored;
        default: return UIImageOrientationUp;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[[NSClassFromString(@"HHOffScreenRenderedVC") alloc]init] animated:YES];
}
@end
