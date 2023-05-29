//
//  HHAutoArchiveModel.m
//  HHRuntime
//
//  Created by michael on 2021/7/28.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHAutoArchiveModel.h"
#import <objc/runtime.h>

@implementation HHAutoArchiveModel
//runtime实现通用copy
//如果自定义类的子类，模型套模型你真的会copy吗，小心有坑。
//
//copy需要自定义类继承NSCopying协议
- (id)copyWithZone:(NSZone *)zone {
    
    id obj = [[[self class] allocWithZone:zone] init];
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [[self valueForKey:strName] copy];//如果还套了模型也要copy呢
            [obj setValue:value forKey:strName];
        }
        free(ivar);
        
        class = class_getSuperclass(class);//记住还要遍历父类的属性呢
    }
    return obj;
}
#pragma mark - 拷贝运行时
- (id)mutableCopyWithZone:(NSZone *)zone
{
    id objcopy = [[[self class]allocWithZone:zone] init];
    //1.获取属性列表
    unsigned int count = 0;
    objc_property_t* propertylist = class_copyPropertyList([self class], &count);

    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = propertylist[i];
        //2.获取属性名
        const char * propertyName = property_getName(property);
        NSString * key = [NSString stringWithUTF8String:propertyName];
        //3.获取属性值
        id value = [self valueForKey:key];
        //4.判断属性值对象是否遵守NSMutableCopying协议
        if ([value respondsToSelector:@selector(mutableCopyWithZone:)])
        {
            //5.设置对象属性值
            [objcopy setValue:[value mutableCopy] forKey:key];
        }
        else
        {
            [objcopy setValue:value forKey:key];
        }
    }
    //*****切记需要手动释放
    free(propertylist);
    return objcopy;
}


#pragma mark - 归档、解档
//runtime实现通用归档解档
//归档解档需要自定义类继承NSCoding协议
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [self valueForKey:strName];
            //对属性（实例变量）进行归档操作的过程中需要为每一个对象设置一个唯一标识Key，作为区分。
            [encoder encodeObject:value forKey:strName];
        }
        free(ivar);
        
        class = class_getSuperclass(class);//记住还要遍历父类的属性呢
    }
}
//实现反归档操作的协议方法
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        Class class = [self class];
        while (class != [NSObject class]) {
            unsigned int count = 0;
            //获取类中所有成员变量名
            Ivar *ivar = class_copyIvarList(class, &count);
            for (int i = 0; i < count; i++) {
                Ivar iva = ivar[i];
                const char *name = ivar_getName(iva);
                NSString *strName = [NSString stringWithUTF8String:name];
                //进行解档取值
                id value = [decoder decodeObjectForKey:strName];
                //利用KVC对属性赋值
                [self setValue:value forKey:strName];
            }
            free(ivar);
            
            class = class_getSuperclass(class);//记住还要遍历父类的属性呢
        }
    }
    return self;
}
@end
