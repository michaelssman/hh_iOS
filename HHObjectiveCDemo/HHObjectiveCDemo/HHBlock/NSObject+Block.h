//
//  NSObject+Block.h
//  003-Block循环引用
//
//  Created by ws on 2020/5/28.
//  Copyright © 2020 Cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(*LGBlockCopyFunction)(void *, const void *);
typedef void(*LGBlockDisposeFunction)(const void *);
typedef void(*LGBlockInvokeFunction)(void *, ...);

enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};

struct _LGBlockDescriptor1 {
    uintptr_t reserved;
    uintptr_t size;
};

struct _LGBlockDescriptor2 {
    // requires BLOCK_HAS_COPY_DISPOSE
    LGBlockCopyFunction copy;
    LGBlockDisposeFunction dispose;
};

struct _LGBlockDescriptor3 {
    // requires BLOCK_HAS_SIGNATURE
    const char *signature;
    const char *layout;     // contents depend on BLOCK_HAS_EXTENDED_LAYOUT
};

#pragma mark - 重写block结构
// 底层
struct _LGBlock {
    void *isa;
    volatile int32_t flags; // contains ref count
    int32_t reserved;
    // 函数指针
    LGBlockInvokeFunction invoke;
    struct _LGBlockDescriptor1 *descriptor;
};


static struct _LGBlockDescriptor3 * _LG_Block_descriptor_3(struct _LGBlock *aBlock) {
    if (! (aBlock->flags & BLOCK_HAS_SIGNATURE)) return nil;
    uint8_t *desc = (uint8_t *)aBlock->descriptor;
    desc += sizeof(struct _LGBlockDescriptor1);
    if (aBlock->flags & BLOCK_HAS_COPY_DISPOSE) {
        desc += sizeof(struct _LGBlockDescriptor2);
    }
    return (struct _LGBlockDescriptor3 *)desc;
}

static const char *LGBlockTypeEncodeString(id blockObj) {
    struct _LGBlock *block = (__bridge void *)blockObj;
    return _LG_Block_descriptor_3(block)->signature;
}
@interface NSObject (Block)

// 打印Block 签名
- (NSMethodSignature *)getBlcokSignature;

// 打印Block 签名
- (NSString *)getBlcokSignatureString;

// 调用block
- (void)invokeBlock;

@end

NS_ASSUME_NONNULL_END
