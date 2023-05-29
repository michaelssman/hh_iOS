//
//  HHFCode.m
//  HHF1
//
//  Created by Michael on 2022/4/18.
//

#import "HHFCode.h"

@implementation HHFCode
- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"HHF1 init");
    }
    return self;
}
+ (void)load {
    NSLog(@"HHF1 load");
}
@end
