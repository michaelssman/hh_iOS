//
//  UIView+CGPDFDocumentRef.h
//  PdfLooker
//
//  Created by apple on 2016/12/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CGPDFDocumentRef)
- (CGPDFDocumentRef)pdfRefByFilePath:(NSString *)aFilePath;
- (NSString *)getPdfPathByFile:(NSString *)fileName;
- (CGPDFDocumentRef)pdfRefByDataByUrl:(NSString *)aFileUrl;
@end
