//
//  HHRuntimeDemoVC.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/6/9.
//  获取类的成员变量、属性、方法、协议列表

#import "HHRuntimeDemoVC.h"
#import "LGPerson.h"
#import <objc/runtime.h>

@interface HHRuntimeDemoVC ()

@end

@implementation HHRuntimeDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //v20@0:8i16  @ 8 : 8
    ///v：方法返回值类型void
    ///20：方法参数的长度

    //v24@0:8@16
    
    //类 -- ro -- 成员变量  实例方法,属性,协议 --类对象
    
    // 类方法 -- 元类里面
    
    //获取类的成员变量
    [self lg_class_copyIvarList:LGPerson.class];
    //获取类的属性
    [self lg_class_copyPropertyList:LGPerson.class];
    //获取类的实例方法
    [self lg_class_copyMethodList:LGPerson.class];
    //获取类的类方法
    [self lg_class_copyMethodList:objc_getMetaClass("LGPerson")];

    [self methodTest:LGPerson.class];
    
    [self impTest:LGPerson.class];
}

#pragma mark - 获取类的成员变量和类型
-(void)lg_class_copyIvarList:(Class)pClass {
    unsigned int  outCount = 0;
    Ivar *ivars = class_copyIvarList(pClass, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char *cName =  ivar_getName(ivar);
        const char *cType = ivar_getTypeEncoding(ivar);
        NSLog(@"name = %s type = %s",cName,cType);
    }
    free(ivars);
}

#pragma mark - 获取类的属性
-(void)lg_class_copyPropertyList:(Class)pClass {
    unsigned int outCount = 0;
    objc_property_t *perperties = class_copyPropertyList(pClass, &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = perperties[i];
        const char *cName = property_getName(property);
        const char *cType = property_getAttributes(property);
        NSLog(@"name = %s type = %s",cName,cType);
    }
    free(perperties);
}

#pragma mark - 获取方法列表
-(void)lg_class_copyMethodList:(Class)pClass {
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(pClass, &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSString *name = NSStringFromSelector(method_getName(method));
        const char *cType = method_getTypeEncoding(method);
        NSLog(@"name = %@ type = %s",name,cType);
    }
    free(methods);
}

#pragma mark - 获取协议列表
- (void)lg_class_copyProtocolList:(Class)pClass {
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
}

#pragma mark - 获取实例方法和类方法
-(void)methodTest:(Class)pClass {
    const char *className = class_getName(pClass);
    Class metaClass = objc_getMetaClass(className);
    
    Method method1 = class_getInstanceMethod(pClass, @selector(instanceMethod));
    Method method2 = class_getInstanceMethod(metaClass, @selector(instanceMethod));
    Method method3 = class_getInstanceMethod(pClass, @selector(classMethod));
    Method method4 = class_getInstanceMethod(metaClass, @selector(classMethod));
    NSLog(@"%p - %p - %p - %p",method1,method2,method3,method4);
}

#pragma mark - 获取方法实现
-(void)impTest:(Class)pClass {
    const char *className = class_getName(pClass);
    Class metaClass = objc_getMetaClass(className);
    
    IMP imp1 = class_getMethodImplementation(pClass, @selector(instanceMethod));
    IMP imp2 = class_getMethodImplementation(metaClass, @selector(instanceMethod));
    IMP imp3 = class_getMethodImplementation(pClass, @selector(classMethod));
    IMP imp4 = class_getMethodImplementation(metaClass, @selector(classMethod));
    NSLog(@"%p - %p - %p - %p",imp1,imp2,imp3,imp4);
    //isa---
    
    //isa --
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
