//
//  ViewController.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2021/12/30.
//

#import "ViewController.h"
#import "LMDataSource.h"
#import <SCM-Swift.h>
#import <ReactiveObjC.h>//面向信号
@interface ViewController ()<UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong) LMDataSource *dataSource;
@end

@implementation ViewController
static const NSString *title = @"title";
static const NSString *vc = @"vc";

- (instancetype)initWithType:(VCType)vcType {
    if (self = [super init]) {
        switch (vcType) {
            case VC_Study:
                self.objects = [NSMutableArray arrayWithObjects:
                                @{title:@"HHRuntimeViewController", vc:@"HHRuntimeViewController"},
                                @{title:@"crash收集分析保存", vc:@"HHCrashTestViewController"},
                                @{title:@"framework的module", vc:@"HHModuleViewController"},
                                @{title:@"alloc", vc:@"HHAllocViewController"},
                                @{title:@"tableview加载图片优化", vc:@"OptimizeListController"},
                                @{title:@"多线程_锁", vc:@"HHMultiThreadViewController"},
                                @{title:@"webView", vc:@"HHWKWebViewController"},
                                @{title:@"编程思想", vc:@"HHProgrammingViewController"},
                                @{title:@"XMPP", vc:@"HHXMPPViewController"},
                                @{title:@"XMPP多播", vc:@"HHMulDelegateVC"},
                                @{title:@"HHTraceViewController", vc:@"HHTraceViewController"},
                                @{title:@"HHMemoryViewController", vc:@"HHMemoryViewController"},
                                @{title:@"HHRouterViewController", vc:@"HHRouterViewController"},
                                @{title:@"HHEncryptViewController", vc:@"HHEncryptViewController"},
                                @{title:@"HHFishHookViewController", vc:@"HHFishHookViewController"},
                                @{title:@"手势，左滑下滑返回", vc:@"HHGestureRecognizerViewController"},
                                @{title:@"HHSpringAnimationViewController", vc:@"HHSpringAnimationViewController"},
                                @{title:@"coredata",vc:@"HHCDTeacherViewController"},
                                @{title:@"CoreText",vc:@"HHCoreTextViewController"},
                                @{title:@"BaseViews",vc:@"HHBaseViewsController"},
                                @{title:@"block",vc:@"HHBlockViewController"},
                                @{title:@"图片/离屏渲染",vc:@"HHImageViewController"},
                                nil];
                break;
            case VC_Demos:
                self.objects = [NSMutableArray arrayWithObjects:
                                @{title:@"音视频", vc:@"THViewController"},
                                @{title:@"仿头条栏目", vc:@"HHViewController"},
                                @{title:@"列表封装", vc:@"ListTestViewController"},
                                @{title:@"弹幕", vc:@"BulletViewController"},
                                @{title:@"画图", vc:@"DrawingViewController"},
                                @{title:@"键盘", vc:@"HHKeyBoardViewController"},
                                @{title:@"HHPDFViewController", vc:@"HHPDFViewController"},
                                @{title:@"下拉框", vc:@"HHPopViewViewTestController"},
                                @{title:@"转场动画", vc:@"TransitionViewController"},
                                @{title:@"瀑布流", vc:@"FallViewController"},
                                @{title:@"仿京东的地区选择",vc:@"HHProvinceAndCityViewController"},
                                @{title:@"文件下载，多文件队列下载",vc:@"HHDownloadViewController"},
                                @{title:@"卡片滑动",vc:@"HHCardViewController"},
                                @{title:@"社区贴吧九宫格",vc:@"CommunityListController"},
                                @{title:@"章节目录",vc:@"HHChapterViewController"},
                                @{title:@"贴吧微博发布页面",vc:@"HHPublishController"},
                                @{title:@"相册图片选择",vc:@"HHSelectPHDemoViewController"},
                                @{title:@"贴吧、微博 发帖动画",vc:@"HHPlusPopViewController"},
                                @{title:@"评论输入框",vc:@"HHCommentInputBoxViewController"},
                                nil];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //2. 数据业务处理层
    self.dataSource = [[LMDataSource alloc]initWithIdentifier:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, NSDictionary *model, NSIndexPath *indexPath) {
        cell.textLabel.text = model[@"title"];
    }];
    [self.dataSource addDataArray:self.objects];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}

#pragma mark lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
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
    [self.navigationController pushViewController:[[NSClassFromString(self.objects[indexPath.row][vc]) alloc]init] animated:YES];
}
@end
