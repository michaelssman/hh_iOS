//
//  FileGroupViewController.m
//  FileManager
//
//  Created by laouhn on 15/10/27.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "FileGroupViewController.h"

@interface FileGroupViewController ()

@end

@implementation FileGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//创建文件夹
- (void)creatFile:(id)sender {
    //1:获取创建文件夹的路径
    NSString *filePath = [self getGroupFilePath];
    //2:创建文件夹管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //3:判断指定路径下是否含有该文件夹，如果没有就创建该文件夹
    if (![fileManager fileExistsAtPath:filePath]) {
        //创建文件夹
        BOOL result = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (result) {
            NSLog(@"文件夹创建成功  %@",filePath);
        }
        
    }
}
//删除文件夹
- (void)deleteFileGroup:(id)sender {
    //1:获取文件夹路径
    NSString *filePath = [self getGroupFilePath];
    //2:创建文件夹管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager removeItemAtPath:filePath error:nil];
    if (result) {
        NSLog(@"文件夹删除成功");
    }
}
//拷贝文件夹
- (void)copyFile:(id)sender {
    //1:获取文件夹的资源路径
    NSString *sourceFilPath = [self getGroupFilePath];
    //2：获取目的路径
    NSString *destinationPath = [self getDocumentsPath];
    //3:创建文件夹管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //4:开始拷贝文件夹
    BOOL result = [fileManager copyItemAtPath:sourceFilPath toPath:destinationPath error:nil];
    if (result) {
        NSLog(@"文件夹拷贝成功");
    }
}
- (void)moveFile:(id)sender {
    //1：获取资源路径
    NSString *sourcePath = [self getGroupFilePath];
    //2:获取目的路径
    NSString *destinationPath = [self getDocumentsPath];
    //3:创建文件管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //4:执行移动操作
    BOOL result = [fileManager moveItemAtPath:sourcePath toPath:destinationPath error:nil];
    if (result) {
        NSLog(@"文件夹移动成功");
    }
    
}
//获取文件夹属性
- (void)attributeFile:(id)sender {
    //1:获取文件夹路径
    NSString *filePath = [self getDocumentsPath];
    //2:创建文件夹管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attribute = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSLog(@"%@",attribute);
}

//获取文件夹路径   (NSCachesDirectory)获取的文件夹是电脑上的  不是真正的手机上的
- (NSString *)getGroupFilePath {
//    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = NSHomeDirectory();
    filePath = [NSString stringWithFormat:@"%@/Library/Caches",filePath];
    return [filePath stringByAppendingPathComponent:@"image"];
}
//获取Documents文件夹路径
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
    return [filePath stringByAppendingPathComponent:@"image"];
}

@end
