//
//  YYTCGPDFDocumentRef.m
//  PdfLooker
//
//  Created by apple on 2016/12/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HHPDFView.h"
#import "UIView+CGPDFDocumentRef.h"

@interface HHPDFView ()
{
    CGFloat _pageNumber;
    NSString *_fileName;
}
@end
@implementation HHPDFView

- (instancetype)initWithFrame:(CGRect)frame
                       atPage:(CGFloat)pageNumber
                  andFileName:(NSString *)fileName {
    self = [super initWithFrame:frame];
    if (self) {
        _pageNumber = pageNumber;
        _fileName = fileName;
    }
    return self;
}
- (CGPDFDocumentRef)createPDFFromExistFile {
    return [self pdfRefByFilePath:[self getPdfPathByFile:_fileName]];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPDFPageRef pageRef = CGPDFDocumentGetPage([self createPDFFromExistFile], _pageNumber);//获取指定页的内容如_pageNumber=1，获取的是pdf第一页的内容
    CGRect mediaRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);//pdf内容的rect
    
    CGContextRetain(context);
    CGContextSaveGState(context);
    
    [[UIColor colorWithHex:0xededed] set];
    CGContextFillRect(context, rect);//填充背景色，否则为全黑色；
    
    CGContextTranslateCTM(context, 0, rect.size.height);//设置位移，x，y；
    
    CGFloat under_bar_height = 0.0f;
    CGContextScaleCTM(context, rect.size.width / mediaRect.size.width, -(rect.size.height + under_bar_height) / mediaRect.size.height);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(context, pageRef);//绘制pdf
    
    CGContextRestoreGState(context);
    CGContextRelease(context);
}

@end
