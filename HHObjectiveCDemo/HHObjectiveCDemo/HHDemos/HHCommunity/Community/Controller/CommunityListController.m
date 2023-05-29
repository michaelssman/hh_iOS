//
//  CommunityListController.m
//  MyCommunity
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "CommunityListController.h"
#import "CommunityModel.h"
#import "CommunityCell.h"
#import "UITableView+HeightCache.h"
#import <HJCornerRadius.h>

@interface CommunityListController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *objects;

@end
@implementation CommunityListController
- (NSMutableArray *)objects {
    if (!_objects) {
        self.objects = [NSMutableArray arrayWithCapacity:0];
    }
    return _objects;
}

- (void)getJsonData {
    NSData *fileData = [[NSData alloc]init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dataSource" ofType:@"json"];
    fileData = [NSData dataWithContentsOfFile:path];

    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];

    NSArray *data = responseObject[@"data"][@"data"];
    for (NSDictionary *object in data) {
        CommunityModel *model = [[CommunityModel alloc] init];
        [model setValuesForKeysWithDictionary:object];
        [self.objects addObject:model];
    }
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT + 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CommunityCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    [self getJsonData];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView DW_CalculateCellWithIdentifier:@"cell" indexPath:indexPath configuration:^(CommunityCell * cell) {
        CommunityModel *model = self.objects[indexPath.row];
        [cell setDataWithModel:model];//一定要在返回高度时将内容注入，否则返回高度无效
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CommunityModel *model = self.objects[indexPath.row];
    [cell setDataWithModel:model];
    cell.communityView.avatarView.aliCornerRadius = AvatarSize / 2;//需要在这里设置，因为cell的height里面会模拟填充cell的数据
    cell.communityView.supportBtn.tag = indexPath.row;
    cell.communityView.commentCntBtn.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setLayoutMargins:UIEdgeInsetsZero];//cell取消内距，联合对其cell的分割线
    [cell.communityView.supportBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.communityView.commentCntBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)likeAction:(UIButton *)sender {
}

- (void)commentAction:(UIButton *)sender {
    NSLog(@"comment");
}

@end
