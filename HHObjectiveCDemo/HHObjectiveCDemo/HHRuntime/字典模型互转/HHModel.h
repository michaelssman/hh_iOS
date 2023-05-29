//
//  HHModel.h
//  HHRuntime
//
//  Created by michael on 2021/7/23.
//  Copyright © 2021 michael. All rights reserved.
//

/**
 字典模型互转
    1. 字典转模型
        遍历字典获取key和value
        objc_msgSend --- 调用set方法
        函数指针的写法
            返回类型(*名称)(param1, param2)
    2. 模型转字典
        key值 --- class_copyPropertyList，property_getName
        ((id(*)(id,SEL))objc_msgSend)(self,sel)
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHModel : NSObject

@end

NS_ASSUME_NONNULL_END
