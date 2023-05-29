//
//  NSObject+Block.m
//  003-Block循环引用
//
//  Created by ws on 2020/5/28.
//  Copyright © 2020 Cat. All rights reserved.
//

#import "NSObject+Block.h"


@implementation NSObject (Block)

- (NSString *)getBlcokSignatureString {
    
    NSMethodSignature *signature = self.getBlcokSignature;
    if (signature) {
        NSMutableString *blockSignature = [NSMutableString stringWithFormat:@"BlcokSignature: return type: %s, ", [signature methodReturnType]];
        for (int i = 0; i < signature.numberOfArguments; i++) {
            [blockSignature appendFormat:@"argument number: %d, argument type: %s ", i+1, [signature getArgumentTypeAtIndex:i]];
        }
        return blockSignature;
    }
    return nil;
}

- (NSMethodSignature *)getBlcokSignature {
    if ([self isKindOfClass:NSClassFromString(@"__NSMallocBlock__")] || [self isKindOfClass:NSClassFromString(@"__NSStackBlock__")] || [self isKindOfClass:NSClassFromString(@"__NSGlobalBlock__")]) {
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:LGBlockTypeEncodeString(self)];
        return signature;
    }
    return nil;
}

- (void)invokeBlock {
    NSMethodSignature *signature = self.getBlcokSignature;
    if (signature) {
        // 动态的消息转发
        NSInvocation *blockInvocation = [NSInvocation invocationWithMethodSignature:signature];
        [blockInvocation invokeWithTarget:self];
    }
}
// block OC 对象
- (NSString *)description {
    if ([self isKindOfClass:NSClassFromString(@"__NSMallocBlock__")] || [self isKindOfClass:NSClassFromString(@"__NSStackBlock__")] || [self isKindOfClass:NSClassFromString(@"__NSGlobalBlock__")]) {
        //签名
        return [NSString stringWithFormat:@"<%@:%p>--%@", self.class, self, [self getBlcokSignatureString]];
    }
    return [NSString stringWithFormat:@"<%@:%p>", self.class, self];
}
@end
