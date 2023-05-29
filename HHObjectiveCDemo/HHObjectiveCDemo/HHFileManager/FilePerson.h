//
//  FilePerson.h
//  FileManager
//
//  Created by laouhn on 15/10/27.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import <Foundation/Foundation.h>
//复杂对象-自定义的类创建的对象如果想要实现持久化存储，必须通过归档/反归档操作将其转换成简单对象（NSData）.但是前提该对象遵循NSCoding协议并且实现对应的协议方法
@interface FilePerson : NSObject<NSCoding>
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *gender;
@property (nonatomic)NSInteger age;
@end
