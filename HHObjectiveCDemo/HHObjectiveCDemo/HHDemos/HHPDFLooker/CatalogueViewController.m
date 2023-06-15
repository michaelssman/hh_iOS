//
//  CatalogueViewController.m
//  PdfLooker
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CatalogueViewController.h"
#import <SCM-Swift.h>
#define SectionHeaderHeight 60
@interface CatalogueViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CatalogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
        make.width.mas_equalTo(300);
    }];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    UIView *tapView = [[UIView alloc]init];
    [self.view addSubview:tapView];
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableView.mas_right).offset(0);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenCatalogueViewAction)];
    [tapView addGestureRecognizer:tapG];
}
- (void)hiddenCatalogueViewAction {
    if (self.hiddenCatalogueView) {
        self.hiddenCatalogueView();
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contents.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SectionHeaderHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc]init];
    headerV.tag = section;
    UILabel *titleLabel = [[UILabel alloc] initWithTextColor:[UIColor hexColor:0x404548] fontSize:30];
    [headerV addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(200);
    }];
    UILabel *numberLabel = [[UILabel alloc] initWithTextColor:[UIColor hexColor:0x404548] fontSize:26];
    numberLabel.textAlignment = NSTextAlignmentRight;
    [headerV addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(0);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    
    NSDictionary *dict = self.contents[section];
    titleLabel.text = [NSString stringWithFormat:@"   %@",dict[@"Title"]];
    numberLabel.text = [NSString stringWithFormat:@"%@", dict[@"Index"]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleJumpToControllerAtIndex:)];
    [headerV addGestureRecognizer:tapGesture];
    return headerV;
}
- (void)handleJumpToControllerAtIndex:(UITapGestureRecognizer *)sender {
    UIView *sectionV = sender.view;
    NSDictionary *dict = self.contents[sectionV.tag];
    NSInteger index = [dict[@"Index"] integerValue] - 1;
    [self jumpToControllerAtIndex:index];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.contents[section];
    NSArray *subContents = dict[@"SubContents"];
    return [subContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    NSDictionary *dictJJJJ = self.contents[indexPath.section];
    NSArray *subContents = dictJJJJ[@"SubContents"];
    NSDictionary *dict = subContents[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"     %@",dict[@"Title"]];
    cell.textLabel.textColor = [UIColor hexColor:0x404548];
    cell.textLabel.font = [UIFont systemFontOfSize:30];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", dict[@"Index"]];
    cell.detailTextLabel.textColor = [UIColor hexColor:0x404548];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:26];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger index = [cell.detailTextLabel.text integerValue] - 1;
    [self jumpToControllerAtIndex:index];
}
- (void)jumpToControllerAtIndex:(NSInteger)index {
    if (self.jumpToControllerAtIndex) {
        self.jumpToControllerAtIndex(index);
    }
    if (self.hiddenCatalogueView) {
        self.hiddenCatalogueView();
    }
}
//UITableView的plain样式下，取消区头停滞效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= SectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if(scrollView.contentOffset.y >= SectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-SectionHeaderHeight, 0, 0, 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
