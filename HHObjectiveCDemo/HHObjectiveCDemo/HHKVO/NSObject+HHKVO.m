//
//  NSObject+HHKVO.m
//  KVODemo
//
//  Created by Michael on 2020/8/5.
//  Copyright © 2020 michael. All rights reserved.
//

/**
 OC的方法
 1.SEL。目录
 2.IMP。页码
 代码     内容
 */

#import "NSObject+HHKVO.h"
#import <objc/message.h>//message里面包含runtime，还有一些起它消息机制

static NSString *const HHKVOClassPrefix = @"HHKVONotifying_";
static NSString *const HHKVOAssiociateKey = @"HHKVO_AssiociateKey";

@implementation HHKVOInfo
- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(HHKeyValueObservingOptions)options handleBlock:(nonnull HHKVOBlock)block
{
    if (self = [super init]) {
        self.observer = observer;
        self.keyPath  = keyPath;
        self.options  = options;
        self.handleBlock = block;
    }
    return self;
}
@end

@implementation NSObject (HHKVO)

#pragma mark - 自定义KVO
- (void)hh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(HHKeyValueObservingOptions)options block:(HHKVOBlock)block
{
    //1. 验证是否存在setter方法：不让实例进来。成员变量无法观察，只观察属性。
    [self judgeSetterMethodFromKeyPath:keyPath];
    //2. 动态生成子类 核心 isa_siwziling
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    //3. 修改对象的isa的指向 : HHKVONotifying_LGPerson
    object_setClass(self, newClass);
    // 4: 保存观察者信息 数组集合
    HHKVOInfo *info = [[HHKVOInfo alloc] initWitObserver:observer forKeyPath:keyPath options:options handleBlock:block];
    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(HHKVOAssiociateKey));
    if (!observerArr) {
        observerArr = [NSMutableArray arrayWithCapacity:1];
    }
    [observerArr addObject:info];
    //4. 绑定属性，把观察者observer绑定在子类，属性改变时通知observer。setter业务逻辑。
    //引用 vc->self(HHPerson对象)->observerArr->info->observe(vc)   info->observe要打破循环链接，使用weak
    objc_setAssociatedObject(self, /*常量指针*/(__bridge const void * _Nonnull)(HHKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hh_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {}

#pragma mark - 移除观察者  全部移除时要指回给父类
- (void)hh_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(HHKVOAssiociateKey));
    if (observerArr.count<=0) {
        // 指回给父类
        Class superClass = [self class];
        object_setClass(self, superClass);
        return;
    }
    
    for (HHKVOInfo *info in observerArr) {
        if ([info.keyPath isEqualToString:keyPath]) {
            [observerArr removeObject:info];
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(HHKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
    }

    if (observerArr.count<=0) {
        // 指回给父类
        Class superClass = [self class];
        object_setClass(self, superClass);
    }
}

#pragma mark - 验证是否存在setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath{
    Class superClass    = object_getClass(self);
    SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"老铁没有当前%@的setter",keyPath] userInfo:nil];
    }
}

#pragma mark - 添加类，注册类
- (Class)createChildClassWithKeyPath:(NSString *)keyPath
{
    //1.创建一个类 创建的类有一个类前缀
    //Person    HHKVO_Person
    Class currentClass = object_getClass(self);
    NSString *currentClassName = NSStringFromClass(currentClass);
    //已经有派生子类
    if ([currentClassName hasPrefix:HHKVOClassPrefix]) return currentClass;
    
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"%@%@",HHKVOClassPrefix,oldClassName];
    Class newClass = NSClassFromString(newClassName);
    //检测KVOClass类是否已经被注册 防止重复创建生成新类
    //KVOClass已被注册过,则无须再注册,直接返回
    if (newClass) return newClass;
    
    //如果内存不存在,创建生成
    // 2.1 : 申请类
    //添加创建类 参数一：这个类继承谁。参数二：新类的名字  参数三：新类的开辟的额外空间
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    // 2.2 : 注册类
    objc_registerClassPair(newClass);
    // MARK: 1. 添加class : class的指向是HHPerson
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    const char *classTypes = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, classSEL, (IMP)hh_class, classTypes);
    
    // MARK: 2. 添加setter
    //重写setName 也就是给子类对象添加父类setName方法。
    /**
     MyClass没有setName方法。MyClass继承Person类，就会获取父类中的方法，父类有的子类也有（但其实并不是）。
     但是底层其实是没有的。调用子类的方法，最终会走到父类里面。
     */
    //参数1:给哪个类添加方法 参数2:添加什么方法 参数3:自己写一个函数方法 参数4:方法的参数 "v@:"代表默认参数  "v@:@"代表后面一个@字符串name参数。
    //重写set方法 keyPath就是观察的属性名称
    //获取方法名称
    //获取方法编号
    SEL setterSEL = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterTypes = method_getTypeEncoding(setterMethod);
    //添加方法实现 函数名就是函数地址
    class_addMethod(newClass, setterSEL, (IMP)hh_setter, setterTypes);
    
    // MARK: 3. 添加dealloc
    //2.3.3 :添加dealloc。自动销毁需要交换方法
    SEL deallocSEL = NSSelectorFromString(@"dealloc");
    Method deallocMethod = class_getInstanceMethod([self class], deallocSEL);
    const char *deallocTypes = method_getTypeEncoding(deallocMethod);
    class_addMethod(newClass, deallocSEL, (IMP)hh_dealloc, deallocTypes);

    return newClass;
}

static void hh_dealloc(id self,SEL _cmd){
    Class superClass = [self class];
    object_setClass(self, superClass);
}

//前两个参数是隐式参数 _cmd就是setter方法，第三个才是name
static void hh_setter(id self,SEL _cmd,id newValue){
    //可以先获取旧值 保存。发通知的时候旧值新值都传过去。还可以给self绑定一个集合 存所有的旧值。
    NSLog(@"来了:%@",newValue);
    //判断 自动开关 省略
    // 消息转发 : 转发给父类
    // 改变父类的值 --- 可以强制类型转换
    //setName:
    //key --- name
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    id oldValue       = [self valueForKey:keyPath];

    //调用父类方法
    // void /* struct objc_super *super, SEL op, ... */
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    void (*hh_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
    //1. 调用一下父类的setName方法
    //修改name属性
    //objc_msgSendSuper(&superStruct,_cmd,newValue)
    hh_msgSendSuper(&superStruct, _cmd, newValue);
    
    
    // 既然观察到了,下一步不就是回调 -- 让我们的观察者调用
    // - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
    // 1: 拿到观察者
    //通知observer 观察者   调用observer的方法。
    //拿出上面绑定的观察者
    // 2: 消息发送给观察者 调用observer的observeValueForKeyPath方法。通过发消息
    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(HHKVOAssiociateKey));
    for (HHKVOInfo *info in observerArr) {
        if ([info.keyPath isEqualToString:keyPath] && info.handleBlock) {
            info.handleBlock(info.observer, keyPath, oldValue, newValue);
        }
        //通过消息发送回调
//        if ([info.keyPath isEqualToString:keyPath]) {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSMutableDictionary<NSKeyValueChangeKey,id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
//                // 对新旧值进行处理
//                if (info.options & HHKeyValueObservingOptionNew) {
//                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
//                }
//                if (info.options & HHKeyValueObservingOptionOld) {
//                    [change setObject:@"" forKey:NSKeyValueChangeOldKey];
//                    if (oldValue) {
//                        [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
//                    }
//                }
//                // 2: 消息发送给观察者
//                SEL observerSEL = @selector(hh_observeValueForKeyPath:ofObject:change:context:);
//                objc_msgSend(info.observer,observerSEL,keyPath,self,change,NULL);
//            });
//        }
    }
}

#pragma mark - class返回的还是HHPerson 外界不知道有动态子类的存在
Class hh_class(id self,SEL _cmd){
    return class_getSuperclass(object_getClass(self));
}

#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    if (getter.length <= 0) { return nil;}
    return [NSString stringWithFormat:@"set%@:",getter.capitalizedString];
}
#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *getter = [setter substringWithRange:range];
    //首字母小写
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}

@end
