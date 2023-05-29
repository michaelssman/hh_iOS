//
//  VoyeurNode.h
//  PdfLooker
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface VoyeurNode : NSObject
{
    CGPDFObjectType type;
    CGPDFObjectRef object;
    CGPDFDictionaryRef catalog;
    NSString *name;
    NSMutableArray *children;
}

- (id)initWithCatalog:(CGPDFDictionaryRef)value;
- (id)initWithObject:(CGPDFObjectRef)value name:(NSString *)name;

- (NSString *)name;
- (CGPDFObjectType)type;
- (NSString *)typeAsString;
- (CGPDFObjectRef)object;
- (NSString *)value;
- (NSArray *)children;
- (VoyeurNode *)childrenForName:(NSString *)key;

@end
