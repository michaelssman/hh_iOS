//
//  HHAutoArchiveModel.h
//  HHRuntime
//
//  Created by michael on 2021/7/28.
//  Copyright © 2021 michael. All rights reserved.
//  利用 class_copyIvarList 实现 NSCoding 的自动归档解档

/////复杂对象-自定义的类创建的对象如果想要实现持久化存储，必须通过归档/反归档操作将其转换成简单对象（NSData）.但是前提该对象遵循NSCoding协议并且实现对应的协议方法

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAutoArchiveModel : NSObject<NSCopying,NSMutableCopying,NSCoding>

@end

NS_ASSUME_NONNULL_END
