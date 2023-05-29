//
//  TeacherViewController.m
//  LessonCoredataDemo
//
//  Created by laouhn on 15/12/1.
//  Copyright (c) 2015年 hehe. All rights reserved.
//

#import "HHCDTeacherViewController.h"
#import <SCM-Swift.h>
@interface HHCDTeacherViewController ()
@property (nonatomic, strong)NSMutableArray *teacherArray;
@end

@implementation HHCDTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //写完属性后,立马初始化数组.
    self.teacherArray = [NSMutableArray array];
    self.teacherArray = [[[CoreDataHelper shared] fetchTeachers] mutableCopy];
    //数据重新赋值后一定要刷新列表
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(addTeacher)];
}


- (void)addTeacher {
    NSLog(@"添加老师");
    int num = arc4random() % 100 + 1;
    NSString *name = [NSString stringWithFormat:@"讲师%d号",num];
    Teacher *teacher = [[CoreDataHelper shared] insertDataWithName:name address:@"北极"];
    //先添加数据源
    [self.teacherArray addObject:teacher];
    //再添加UI
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.teacherArray.count - 1 inSection:0];
    //    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    
    //tableview滚动到最底部.
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.teacherArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teacherCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"teacherCell"];
    }
    // Configure the cell...
    cell.textLabel.text = ((Teacher *)[self.teacherArray objectAtIndex:indexPath.row]).address;
    cell.detailTextLabel.text = ((Teacher *)[self.teacherArray objectAtIndex:indexPath.row]).name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"//打印老师下的所有学生");
    Teacher *teacher = [self.teacherArray objectAtIndex:indexPath.row];
    
//   NSArray *students = [[CoreDataHelper shared] fetchStudentWithTeacher:teacher];
    for (Student *stu in teacher.relationship) {
        NSLog(@"xs: %@",stu.name);
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //先删除数据源  然后删除UI
        //数据源包括 teacherArray还有我们的coredata 沙盒路径下的文件数据.
        Teacher *teacher = [self.teacherArray objectAtIndex:indexPath.row];
        [[CoreDataHelper shared] deleteDataWithTeacher:teacher];
        [self.teacherArray removeObjectAtIndex:indexPath.row];
        //删除UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
