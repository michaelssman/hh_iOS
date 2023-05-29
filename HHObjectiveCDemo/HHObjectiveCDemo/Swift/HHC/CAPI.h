//
//  CAPI.h
//  HHSwift
//
//  Created by Michael on 2022/4/10.
//

#ifndef CAPI_h
#define CAPI_h

#include <stdio.h>
//声明标准库符号
const void * _Nullable swift_getTypeByMangledNameInContext(
                        const char * _Nullable typeNameStart,
                        int typeNameLength,
                        const void * _Nullable context,
                        const void * _Nullable const * _Nullable genericArgs);

const void * _Nullable swift_allocObject(
                    const void * _Nullable type,
                    int requiredSize,
                    int requiredAlignmentMask);

#endif /* CAPI_h */
