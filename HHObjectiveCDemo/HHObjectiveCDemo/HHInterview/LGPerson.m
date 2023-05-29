//
//  LGPerson.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/5/14.
//

#import "LGPerson.h"

@implementation LGPerson
//底层。Method_t 结构体, sel(方法编号) logName:  不能唯一标识方法 需要签名信息
//sel编号 sign签名 imp(地址空间 即函数指针) (共同确定具体的method)

- (void)logName:(NSString *)name
{
    NSLog(@"Person name == %@",name);
}


-(void)instanceMethod {
    NSLog(@"%s",__func__);
}
+(void)classMethod {
    NSLog(@"%s",__func__);
}

@end
