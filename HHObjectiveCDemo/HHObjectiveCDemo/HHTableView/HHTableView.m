//
//  HHTableView.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/8/24.
//

#import "HHTableView.h"
#import "LMDataSource.h"
#import <SCM-Swift.h>
@interface HHTableView ()<UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong) LMDataSource *dataSource;
@end

@implementation HHTableView

static const NSString *title = @"title";
static const NSString *vc = @"vc";

- (instancetype)initWithFrame:(CGRect)frame
                   methodNames:(NSArray *)methodNames
{
    self = [super initWithFrame:frame];
    if (self) {
        // Do any additional setup after loading the view.
        self.objects = [NSMutableArray arrayWithCapacity:0];
        for (NSString *methodName in methodNames) {
            [self.objects addObject:@{title:methodName, vc:methodName}];
        }
        //2. 数据业务处理层
        self.dataSource = [[LMDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, NSDictionary *model, NSIndexPath *indexPath) {
            cell.textLabel.text = model[@"title"];
        }];
        [self.dataSource addDataArray:self.objects];
        [self addSubview:self.tableView];
        self.tableView.dataSource = self.dataSource;
    }
    return self;
}

#pragma mark lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self viewController] performSelector:NSSelectorFromString(self.objects[indexPath.row][vc])];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
