//
//  YYTCGPDFDocumentRef.h
//  PdfLooker
//
//  Created by apple on 2016/12/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPDFView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                       atPage:(CGFloat)pageNumber
                  andFileName:(NSString *)fileName;
- (CGPDFDocumentRef)createPDFFromExistFile;
@end
