//
//  ViewController.m
//  KVODemo
//
//  Created by Michael on 2020/7/20.
//  Copyright © 2020 michael. All rights reserved.
//

/**
 函数式编程 对KVO改进
 */
#import "HHKVOViewController.h"
#import "HHKVOPerson.h"
#import "NSObject+HHKVO.h"
#import <objc/runtime.h>
#import "KVOArrayViewController.h"


static void *PersonNameContext = &PersonNameContext;

@interface HHKVOViewController ()
@property (nonatomic, strong)HHKVOPerson *person;

@end

@implementation HHKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.person = [[HHKVOPerson alloc]init];
    self.person.dataArray = [NSMutableArray arrayWithCapacity:0];
    /**
     1：context：重要的标识，更安全更便利更直接。
         一个对象 观察多个属性 通过keyPath来判断区分
         如果多个对象 多个观察。如果使用object和keyPath来判断，一层加一层就会很臃肿。
     Person观察name属性，Student也观察name属性，那么就要做两层判断，臃肿。
     2：观察name，age，等，后来又不观察了，后来又观察了。反复更改的情况。
     3：自动开关 手动观察
     4： 一对多：复合观察    keyPathsForValuesAffectingValueForKey
         进度 =  已下载/总共。同时观察已下载和总共两个。是否可以只观察一个，然后触发其他的。
         cell 高度 图文富文本影响高度。
     5：可变数组观察。kvo观察基于set方法观察。改变数组是addobject，
         通过KVC观察
     */
    
    //普通调用
    //    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:PersonNameContext];
    
    /**
     KVO原理：动态添加类
     用到了运行时
     在下面添加person的观察者的方法里做了几件事情：
     1. 动态的创建了一个子类，继承person。在里面重写setName方法。
     2. 动态修改p对象的类型，把p对象的isa指针指向了它的子类。
     这样再调用self.person.name的时候就会走到子类里面去。并不会走person的setName方法。
    */
    [self.person hh_addObserver:self forKeyPath:@"name" options:HHKeyValueObservingOptionNew block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"");
    }];
//    [self.person addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:PersonNameContext];

    
    
    //需要通过这种方法 因为add不可以。通过KVC
    [[self.person mutableArrayValueForKey:@"dataArray"] addObject:@"123"];
    
    /**
     KVO的原理
     1:动态生成子类：NSKVONotifying_xxx
        1.1 动态生成NSKVONotifying_HHPerson
        1.2 HHPerson 和NSKVONotifying_HHPerson  HHPerson子类
        1.3NSKVONotifying_HHPerson有什么东西
     2:动态子类重写了很多方法（不是继承  是重写）
        通过打印class的方法列表
        2.1 setNickName(setter)
        2.2 class   添加观察者之后，打印self.person.class 显示的还是HHPerson，外面看到的还是HHPerson。
        2.3 dealooc 把isa指回去
        2.4 _isKVOA
     3:观察的是setter   所以观察成员变量不走回调 观察不到。
         setter方法是动态子类NSKVONotifying_HHPerson的。
         但是修改的还是HHPerson的name属性
         willChange
         didChange
         发送消息回调通知
     4:移除观察的时候 isa 指向回来
     5:移除观察 动态子类不会销毁（一直在内存中存在）
     */
    //通过打印object_getClassName(self.person) 观察之前是HHPerson，观察之后是NSKVONotifying_HHPerson
    //person对象isa原本指向HHPerson，addObserver添加观察者之后，指向了HHPerson的子类NSKVONotifying_HHPerson,removeObserver之后，isa又重新指向了HHPerson类。不移除观察着 就会一直指向子类NSKVONotifying_HHPerson造成混乱，指针混乱，访问结构意想不到的错误。
    //NSKVONotifying_HHPerson是新创建的子类，和继承不一样。
    /**
     动态生成的类。
     HHPerson是NSKVONotifying_HHPerson的父类
     */
    
    //查看类的关系
    [self printClasses:[HHKVOPerson class]];
    [self.person addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:PersonNameContext];
    [self printClasses:[HHKVOPerson class]];
//    [self printClasses:objc_getClass("NSKVONotifying_HHPerson")];
//    [self printClassAllMethod:objc_getClass("NSKVONotifying_HHPerson")];
    
    //成员变量。属性
    /**
     成员变量和属性 少了一个编译器自动生成的setter方法。
     KVO观察的set方法，观察不了成员变量，只能观察属性。
     */
    
    /**
     成员变量，实例变量 区别
     实例对象和类的关系：isa指向关系
     */
}

//健值观察 回调
/**
 如果有很多的ifelse，编译也会变慢。里面还要进行object匹配和keyPath匹配，底层hash匹配。
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == PersonNameContext) {
//        <#code to be executed upon observing keypath#>
//        change[NSKeyValueChangeNewKey]
//        [change[NSKeyValueChangeNewKey] CGSizeValue]//contentSize
    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    NSLog(@"来了--%@",self.person.name);
}

/**
 移除观察
 一般的push进来 然后pop出去。不会有内存泄露
 */
- (void)dealloc
{
    // 这里我们不想操作了我们的销毁代码
    // 我们就想把销毁的代码隐藏起来
    // 我们就在分类重写dealloc --- 两个问题
    // -| 我们要想dealloc 就需要这个对象销毁 --
    // -| 我们分类重写会导致所有的类都交换了
//进入KVO的时候动态子类添加一个dealloc实现。
    
    //
    [self.person removeObserver:self forKeyPath:@"name"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    KVOArrayViewController *vc = [[KVOArrayViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    return;
    static int a = 0;
    a++;
    self.person.name = [NSString stringWithFormat:@"%d",a];
    NSLog(@"%@",self.person.name);
}


#pragma mark - 遍历方法-ivar-property
- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
    }
    free(methodList);
}
#pragma mark - 遍历类以及子类
- (void)printClasses:(Class)cls{
    
    // 注册类的总数
    int count = objc_getClassList(NULL, 0);
    // 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    // 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}
@end
