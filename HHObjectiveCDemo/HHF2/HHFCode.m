//
//  HHFCode.m
//  HHF2
//
//  Created by Michael on 2022/4/18.
//

#import "HHFCode.h"

@implementation HHFCode
- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"HHF2 init");
    }
    return self;
}
+ (void)load {
    NSLog(@"HHF2 load");
}
@end
