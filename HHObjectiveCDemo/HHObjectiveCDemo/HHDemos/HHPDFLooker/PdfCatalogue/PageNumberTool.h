//
//  PageNumberTool.h
//  PdfLooker
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageNumberTool : NSObject
- (NSArray *)getPDFContents:(NSString *)pdfFile;
@end
