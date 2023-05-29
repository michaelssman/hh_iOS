//
//  FilePerson.m
//  FileManager
//
//  Created by laouhn on 15/10/27.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "FilePerson.h"

@implementation FilePerson
//实现归档操作的协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    //如果想要对某一个对象执行归档操作，我们必须对该对象中所有的属性分别进行归档操作
    //aCoder:指代需要进行归档的对象
    //对属性（实例变量）进行归档操作的过程中需要为每一个对象设置一个唯一标识，作为区分。
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:@(self.age) forKey:@"age"];
}
//实现反归档操作的协议方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.age = [[aDecoder decodeObjectForKey:@"age"] integerValue];
    }
    return self;
}

@end
