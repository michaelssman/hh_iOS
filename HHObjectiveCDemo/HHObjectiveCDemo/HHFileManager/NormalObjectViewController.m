//
//  NormalObjectViewController.m
//  FileManager
//
//  Created by laouhn on 15/10/27.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "NormalObjectViewController.h"

@interface NormalObjectViewController ()
@end

@implementation NormalObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",[self getDocumentsPath]);
}
//字符串写入
- (void)stringWite:(id)sender {
    NSString *string = @"附近的时刻了；附近的时刻了附近的实力；附近的实力";
    //1:获取写入文件的路径
    NSString *filePath = [self getDocumentsPath];
    //2：将字符串写入指定的文件
    /*
     atomically：数据每次写入文件之前都会写写入一个临时文件，然后将临时文件中的内容替换掉原文件中的内容，这样可以保证每次写入的数据都是完整的。
     */
    BOOL result1 = [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (result1) {
        NSLog(@"字符串写入成功  %@", filePath);
    } else {
        NSLog(@"字符串写入失败");
    }
}
//字符串读取
- (NSString *)stringRead:(id)sender {
    //从指定文件中读取数据
    //1:获取文件的路径
    NSString *filePath = [self getDocumentsPath];
//    //2:开始读取数据
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    //3：将二进制数据转换成字符串
//    self.secondTextField.text = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
//从文档里面直接读取
    NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return string;
}
- (void)arrayWrite:(id)sender {
    //1:获取文件路径
    NSString *filePath = [self getDocumentsPath];
    //创建数组对象（将数组/字典中的内容写入到文件的时候必须保证数组/字典中的对象必须是简单对象）
    NSArray *contents = @[@"房东家酸辣粉", @"房东伤口恢复第四节课"];
    BOOL result = [contents writeToFile:filePath atomically:YES];
    if (result) {
        NSLog(@"数组数据写入成功  %@",filePath);
    }
}
- (NSArray *)arrayRead:(id)sender {
    //1:获取文件路径
    NSString *filePath = [self getDocumentsPath];
    //2:读取文件中数据
    NSArray *contents = [NSArray arrayWithContentsOfFile:filePath];
    return contents;
}

- (void)dictionaryWrite:(id)sender {
    //1:获取文件路径
    NSString *filePath = [self getDocumentsPath];
    NSDictionary *contents = [NSDictionary dictionaryWithObject:@"hehe" forKey:@"nicai"];
    BOOL result = [contents writeToFile:filePath atomically:YES];
    if (result) {
        NSLog(@"字典写入成功  %@",filePath);
    }
}
- (NSDictionary *)dictionaryRead:(id)sender {
    //1：获取文件路径
    NSString *filePath = [self getDocumentsPath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
- (void)dataWrite:(id)sender {
    //1:获取文件的路径
    NSString *filePath = [self getDocumentsPath];
    //2：将字符串转换成二进制数据
    NSData *dataText = [@"房东还是空间里发的" dataUsingEncoding:NSUTF8StringEncoding];
    //3:将二进制数据写入文件
    BOOL result = [dataText writeToFile:filePath atomically:YES];
    if (result) {
        NSLog(@"数据写入成功  %@",filePath);
    }
}
- (NSString *)dataRead:(id)sender {
    //
    NSString *filePath = [self getDocumentsPath];
    //2：从文件中读取数据
    NSData *dataText = [NSData dataWithContentsOfFile:filePath];
    //3：将NSData转换成NSString
    NSString *result = [[NSString alloc]initWithData:dataText encoding:NSUTF8StringEncoding];
    return result;
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
