//
//  HHModel.m
//  HHRuntime
//
//  Created by michael on 2021/7/23.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHModel.h"
#import <objc/message.h>
@implementation HHModel

#pragma mark - 字典转模型
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        for (NSString *key in dic) {
            id value = dic[key];
            //set方法
            //objc_masSend(id, sel, value)
            //函数指针格式：
            //返回类型（*函数名）（param1，param2）
            NSString *methodName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
            SEL sel = NSSelectorFromString(methodName);
            if (sel) {
                ((void(*)(id,SEL,id))objc_msgSend)(self,sel,value);
                
            }
        }
    }
    return self;
}

#pragma mark - 模型转字典
/**
 key-value
 key：class_getPropertyList()
 value：get方法（objc_msgSend）
 */
- (NSDictionary *)convertModelToDic
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count != 0) {
        NSMutableDictionary *tempDic = [@{} mutableCopy];
        for (int i = 0; i < count; i++) {
            const void *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            SEL sel = NSSelectorFromString(name);
            if (sel) {
                id value = ((id(*)(id,SEL))objc_msgSend)(self,sel);
                if (value) {
                    tempDic[name] = value;
                } else {
                    tempDic[name] = @"";
                }
            }
        }
        free(properties);//因为copy
        return tempDic;
    }
    
    free(properties);//因为copy
    return nil;
}

@end
