//
//  HHCoreTextView.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2022/1/26.
//

#import "HHCoreTextView.h"
#include <CoreText/CoreText.h>
@implementation HHCoreTextView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // y坐标轴反转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 文字描述
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:@"我是一个富文本"];
    [attributeStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(0, 2)];
    // CTFramesetter
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    // 绘制路径，也可以理解成绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    // CTFrame
    NSInteger length = attributeStr.length;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    
    // 绘制
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}


@end
