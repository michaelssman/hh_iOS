
#import "HHGroupShadowTableViewController.h"
#import "GroupShadowTableView.h"
@interface HHGroupShadowTableViewController ()<GroupShadowTableViewDelegate,GroupShadowTableViewDataSource>
@property (nonatomic, strong)GroupShadowTableView *tableView;

@end

@implementation HHGroupShadowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.tableView = [[GroupShadowTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.groupShadowDelegate = self;
    self.tableView.groupShadowDataSource = self;
    //要设置separatorStyle
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showSeparator = YES;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorColor = [UIColor redColor];
    [self.view addSubview:self.tableView];

}

#pragma mark delegate datasource
- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView {
    return 6;
}

- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellcell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"icon"];
    cell.textLabel.text = [NSString stringWithFormat:@"section=%zd, row=%zd", indexPath.section, indexPath.row];
    return cell;
}

- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)groupShadowTableView:(GroupShadowTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - header
- (UIView *)groupShadowTableView:(GroupShadowTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        lab.textColor = [UIColor purpleColor];
        lab.text = @"负电荷方式即可";
        return lab;
    } else {
        return nil;
    }
}
- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 60;
    } else {
        return 10;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
