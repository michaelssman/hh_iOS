//
//  HHIsaViewController.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/6/8.
//

#import "HHIsaViewController.h"
#import <objc/runtime.h>
#import "LGPerson.h"
#import "LGTeacher.h"
@interface HHIsaViewController ()

@end

@implementation HHIsaViewController
//MARK: - 分析类对象内存存在个数
void lgTestClassNum(void){
    Class class1 = [LGPerson class];
    Class class2 = [LGPerson alloc].class;
    Class class3 = object_getClass([LGPerson alloc]);
    NSLog(@"\n%p-\n%p-\n%p",class1,class2,class3);//打印都是同一个
}

#pragma mark - 继承链
void lgTestSuperClass(void){
    LGTeacher *t = [LGTeacher alloc];
    LGPerson  *p = [LGPerson alloc];
    NSLog(@"%@-%@",t,p);
    
    NSLog(@"%@",class_getSuperclass(LGTeacher.class));
    NSLog(@"%@",class_getSuperclass(LGPerson.class));
    NSLog(@"%@",class_getSuperclass(NSObject.class));
}

#pragma mark - NSObject 元类链
void lgTestNSObject(void){
    // NSObject实例对象
    NSObject *object1 = [NSObject alloc];
    // NSObject类对象
    Class class = object_getClass(object1);
    // NSObject元类(根元类)
    Class metaClass = object_getClass(class);
    
    NSLog(@"NSObject实例对象:%p",object1);
    NSLog(@"NSObject类对象:%p",class);
    NSLog(@"NSObject元类(根元类):%p",metaClass);
    
    // LGPerson  -- 元类的父类就是父类的元类
    Class pMetaClass = objc_getMetaClass("LGPerson");
    Class psuperClass = class_getSuperclass(pMetaClass);
    NSLog(@"%@ - %p",pMetaClass,pMetaClass);
    NSLog(@"%@ - %p",psuperClass,psuperClass);
    
    // LGTeacher继承自LGPerson
    // LGTeacher元类的父类 就是 LGPerson(LGPerson的元类)
    Class tMetaClass = objc_getMetaClass("LGTeacher");
    Class tsuperClass = class_getSuperclass(tMetaClass);
    NSLog(@"%@ - %p",tsuperClass,tsuperClass);
    
    // NSObject的父类
    Class nsuperClass = class_getSuperclass(NSObject.class);
    NSLog(@"%@ - %p",nsuperClass,nsuperClass);
    
    // 根元类的父类 -- NSObject
    Class rnsuperClass = class_getSuperclass(metaClass);
    NSLog(@"%@ - %p",rnsuperClass,rnsuperClass);

}

#pragma mark - 各种类型编码
void lgTypes(void){
    NSLog(@"char --> %s",@encode(char));
    NSLog(@"int --> %s",@encode(int));
    NSLog(@"short --> %s",@encode(short));
    NSLog(@"long --> %s",@encode(long));
    NSLog(@"long long --> %s",@encode(long long));
    NSLog(@"unsigned char --> %s",@encode(unsigned char));
    NSLog(@"unsigned int --> %s",@encode(unsigned int));
    NSLog(@"unsigned short --> %s",@encode(unsigned short));
    NSLog(@"unsigned long --> %s",@encode(unsigned long long));
    NSLog(@"float --> %s",@encode(float));
    NSLog(@"bool --> %s",@encode(bool));
    NSLog(@"void --> %s",@encode(void));
    NSLog(@"char * --> %s",@encode(char *));
    NSLog(@"id --> %s",@encode(id));
    NSLog(@"Class --> %s",@encode(Class));
    NSLog(@"SEL --> %s",@encode(SEL));
    int array[] = {1,2,3};
    NSLog(@"int[] --> %s",@encode(typeof(array)));
    typedef struct person{
        char *name;
        int age;
    }Person;
    NSLog(@"struct --> %s",@encode(Person));
    
    typedef union union_type{
        char *name;
        int a;
    }Union;
    NSLog(@"union --> %s",@encode(Union));

    int a = 2;
    int *b = {&a};
    NSLog(@"int[] --> %s",@encode(typeof(b)));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //nonpointerIsa
    //isa --> 内存地址
    
    //objc_class -- 实例对象 isa + 成员变量的值
    //实例对象 isa -->类对象 isa -->元类对象 isa -->根元类 isa -->根元类自己 --
    
    //
    
    //根类NSObject isa -->根元类
    
    //(lldb) po 0x0000000209e241a0
    //NSObject 根元类
    
    //(lldb) po 0x00000001000082c8
    //LGPerson的元类
    //0x007ffffffffffff8ULL
    LGPerson *p = [LGPerson alloc];
//        NSLog(@"%@",p);
//        lgTestClassNum();
    lgTestNSObject();
    lgTypes();
    NSLog(@"Hello World!");
}

@end
