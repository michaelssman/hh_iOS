//
//  HHChapterView.m
//  HHChapterDemo
//
//  Created by Michael on 2021/3/2.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHChapterView.h"
#import "HHChapterCell.h"
@interface HHChapterView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end
@implementation HHChapterView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpConfig];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpConfig];
    }
    return self;
}
- (void)setUpConfig
{
    [self addSubview:self.tableView];
}
- (void)setDataSource
{
    self.objects = [self getJsonData];
}
- (NSMutableArray *)getJsonData {
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chapterDataSource" ofType:@"json"];
    fileData = [NSData dataWithContentsOfFile:path];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dict in jsonArray) {
        //数据处理
        HHChapterModel *model = [HHChapterModel new];
        model.grade = 1;
        [model setValuesForKeysWithDictionary:dict];
        [array addObject:model];
    }
    HHChapterModel *model = array.firstObject;
    model.selected = YES;
    return array;
}
#pragma mark lazy load
- (NSMutableArray *)objects {
    if (!_objects) {
        self.objects = [NSMutableArray arrayWithCapacity:0];
    }
    return _objects;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        [self.tableView registerClass:[HHChapterCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark tableView delegate & dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HHChapterModel *model = self.objects[indexPath.row];
    [cell setData:model];
    cell.openOrClose = ^{
        [self openOrCloseWithTableView:tableView indexPath:indexPath];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消之前选中的
    for (HHChapterModel *model in self.objects) {
        [self cancelSelected:model];
    }
    self.objects[indexPath.row].selected = YES;
    [tableView reloadData];
    if (self.refreshData) {
        self.refreshData(self.objects);
    }
    if (self.didSelectRow) {
        self.didSelectRow(indexPath.row);
    }
    NSLog(@"就这个");
}
#pragma mark - 取消之前选中的
- (void)cancelSelected:(HHChapterModel *)model
{
    model.selected = NO;
    for (HHChapterModel *subM in model.ChildrenModels) {
        [self cancelSelected:subM];
    }
}

- (void)openOrCloseWithTableView:(UITableView *)tableView
                       indexPath:(NSIndexPath *)indexPath
{
    HHChapterModel *model = self.objects[indexPath.row];
    if (model.ChildrenModels.count) {
        if (model.isOpen) {
            //合闭
            //        [self.objects removeObjectsInRange:NSMakeRange(indexPath.row + 1, model.ChildrenModels.count)];
            [self removeSubModels:model];
        } else {
            //展开
            [self.objects insertObjects:model.ChildrenModels atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, model.ChildrenModels.count)]];
        }
        model.isOpen = !model.isOpen;
        [tableView reloadData];
    } else {
        NSLog(@"就这个");
    }
    if (self.refreshData) {
        self.refreshData(self.objects);
    }
}
- (void)removeSubModels:(HHChapterModel *)model
{
    for (HHChapterModel *subM in model.ChildrenModels) {
        subM.isOpen = NO;
        [self removeSubModels:subM];
        [self.objects removeObject:subM];
    }
}

- (void)hiddenAction
{
    [self removeFromSuperview];
    if (self.didHidden) {
        self.didHidden();
    }
}


- (void)layoutSubviews
{
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
