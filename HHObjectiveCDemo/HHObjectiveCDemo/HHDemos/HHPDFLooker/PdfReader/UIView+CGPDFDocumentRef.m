//
//  UIView+CGPDFDocumentRef.m
//  PdfLooker
//
//  Created by apple on 2016/12/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+CGPDFDocumentRef.h"

@implementation UIView (CGPDFDocumentRef)
//用于本地pdf文件
- (CGPDFDocumentRef)pdfRefByFilePath:(NSString *)aFilePath {
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    
    path = CFStringCreateWithCString(NULL, [aFilePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    document = CGPDFDocumentCreateWithURL(url);
    
    CFRelease(path);
    CFRelease(url);
    
    return document;
}

- (NSString *)getPdfPathByFile:(NSString *)fileName {
    return [[NSBundle mainBundle] pathForResource:fileName ofType:@".pdf"];
}

//用于网络pdf文件
- (CGPDFDocumentRef)pdfRefByDataByUrl:(NSString *)aFileUrl {
    NSData *pdfData = [NSData dataWithContentsOfFile:aFileUrl];
    CFDataRef dataRef = (__bridge_retained CFDataRef)(pdfData);
    
    CGDataProviderRef proRef = CGDataProviderCreateWithCFData(dataRef);
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithProvider(proRef);
    
    CGDataProviderRelease(proRef);
    CFRelease(dataRef);
    
    return pdfRef;
}
@end
