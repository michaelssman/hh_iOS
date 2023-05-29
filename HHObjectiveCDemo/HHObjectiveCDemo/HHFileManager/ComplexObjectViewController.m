//
//  ComplexObjectViewController.m
//  FileManager
//
//  Created by laouhn on 15/10/27.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "ComplexObjectViewController.h"
#import "FilePerson.h"
@interface ComplexObjectViewController ()

@end

@implementation ComplexObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//归档操作
- (void)archiverAction:(id)sender {
    //创建Person对象
    FilePerson *person = [[FilePerson alloc]init];
    person.name = @"hells";
    person.gender = @"man";
    person.age = 18;
    //1:创建归档对象
    NSMutableData *mutableData = [[NSMutableData alloc]initWithCapacity:0];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:mutableData];
    //2:开始进行归档操作
    [archiver encodeObject:person forKey:@"person"];
    //3:结束归档操作
    [archiver finishEncoding];
    //4:将mutableData写入到文件中
    NSString *filePath = [self getDocumentsPath];
    BOOL result = [mutableData writeToFile:filePath atomically:YES];
    if (result) {
        NSLog(@"数据写入成功 %@",filePath);
    }
    
}
- (void)unarchiverAcion:(id)sender {
    //1:读取文件中的数据
    NSString *filePath = [self getDocumentsPath];
    NSMutableData *mutableData = [NSMutableData dataWithContentsOfFile:filePath];
    //2:创建一个反归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:mutableData];
    //3:开始进行反归档操作
    FilePerson *person = [unArchiver decodeObjectForKey:@"person"];
}

//获取Documents文件夹的路径
- (NSString *)getDocumentsPath {
    //下面的方法专门用来搜索指定文件夹的路径，因为该方法之前应用于Mac系统，Mac系统下支持多个用户存在，因此搜索的结果是一个数组。但是现在我们将其应用于手机，手机支持一个用户存在，因此数组中只有一个对象。
    /*
     方法参数的说明：
     参数1：代表要搜索的文件夹的名字
     参数2：代表搜索的范围（一般是用户 ）
     参数3：是否展示详细路径信息。
     */
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [filePath stringByAppendingPathComponent:@"content.text"];
}

@end
