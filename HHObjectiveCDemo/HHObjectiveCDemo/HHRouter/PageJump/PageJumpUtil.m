//
//  PageJumpUtil.m
//  PageJumpDemo
//
//  Created by Michael on 2021/4/27.
//

#import "PageJumpUtil.h"
#import <UIKit/UIKit.h>
#import <SCM-Swift.h>
#import <objc/runtime.h>

@implementation PageJumpUtil
+ (void)pushViewController:(NSString *)vcString
                 propertys:(NSDictionary *)propertys
{
    //类名
    const char *className = [vcString cStringUsingEncoding:NSASCIIStringEncoding];
    //从字符串返回一个类
    Class class = objc_getClass(className);
    if (!class) {
        //创建一个类
        Class superClass = [NSObject class];
        class = objc_allocateClassPair(superClass, className, 0);
        //注册创建的类
        objc_registerClassPair(class);
    }
    //创建对象
    UIViewController *instance = [[class alloc]init];
    
    //对该对象属性赋值
    [propertys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //检测这个对象是否存在该属性
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            //利用KVC赋值
            [instance setValue:obj forKey:key];
        }
    }];
    
    [[UIDevice topViewController].navigationController pushViewController:instance animated:YES];
}

+ (BOOL)checkIsExistPropertyWithInstance:(id)instance
                      verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount,i;
    //获取对象属性列表
    objc_property_t *properties = class_copyPropertyList([instance class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //属性名转字符串
        NSString *propertyName = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}
@end
