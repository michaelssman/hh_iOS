//
//  HHTabContentSubView.m
//  HHTabBarController_Example
//
//  Created by FN-116 on 2021/12/14.
//  Copyright © 2021 888888888@qq.com. All rights reserved.
//

#import "HHTabContentSubView.h"
@interface HHTabContentSubView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation HHTabContentSubView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView = tableView;
        [self addSubview:tableView];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *array = @[@"带回家",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好",@"反倒是",@"北方的",@"发的",@"更好"];

    cell.textLabel.text = array[tableView.tag];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
