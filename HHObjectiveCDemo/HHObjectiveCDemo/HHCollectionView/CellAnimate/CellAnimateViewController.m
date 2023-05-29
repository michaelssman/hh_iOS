//
//  CellAnimateViewController.m
//  HHCollectionView
//
//  Created by FN-116 on 2021/12/2.
//

#import "CellAnimateViewController.h"
#import <SCM-Swift.h>
#define kCellSize   53

@implementation AnimateCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lab = [UILabel new];
        self.lab.frame = self.bounds;
        [self.contentView addSubview:self.lab];
        self.lab.textColor = [UIColor blackColor];
        self.lab.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
@end

@interface CellAnimateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong)HHCellAnimateFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign)int aaa;

@end

@implementation CellAnimateViewController
- (NSMutableArray *)objects {
    if (!_objects) {
        self.objects = [NSMutableArray array];
    }
    return _objects;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        // 初始化标准瀑布流类的对象
        HHCellAnimateFlowLayout *flowLayout = [[HHCellAnimateFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 水平滑动
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.minimumLineSpacing = 15;
        flowLayout.itemSize = CGSizeMake(kCellSize, kCellSize);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowLayout.addAnimatedIndex = -1;
        flowLayout.removeAnimatedIndex = -1;
        _flowLayout = flowLayout;
        
        // 初始化CollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 90, 300, 73) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor yellowColor];
        
        // collectionView注册cell
        [_collectionView registerClass:[AnimateCollectionViewCell class] forCellWithReuseIdentifier:@"AnimateCollectionViewCell"];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *buttonInsert = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonInsert.backgroundColor = [UIColor whiteColor];
    buttonInsert.layer.masksToBounds = YES;
    buttonInsert.layer.cornerRadius = 20.0;
    buttonInsert.layer.borderColor = [UIColor blueColor].CGColor;
    buttonInsert.layer.borderWidth = 1.0;
    [buttonInsert setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonInsert setTitle:@"新增" forState:UIControlStateNormal];
    [self.view addSubview:buttonInsert];
    buttonInsert.frame = CGRectMake(50, 330, 100, 50);
    [buttonInsert addTarget:self action:@selector(insertItems) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDelete.backgroundColor = [UIColor whiteColor];
    buttonDelete.layer.masksToBounds = YES;
    buttonDelete.layer.cornerRadius = 20.0;
    buttonDelete.layer.borderColor = [UIColor blueColor].CGColor;
    buttonDelete.layer.borderWidth = 1.0;
    [buttonDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDelete setTitle:@"删除" forState:UIControlStateNormal];
    [self.view addSubview:buttonDelete];
    buttonDelete.frame = CGRectMake(50, 430, 100, 50);
    [buttonDelete addTarget:self action:@selector(deleteItems) forControlEvents:UIControlEventTouchUpInside];
}

- (void)insertItems {
    [self.objects addObject:[NSString stringWithFormat:@"%d",self.aaa++]];
    self.flowLayout.addAnimatedIndex = self.objects.count - 1;
    //必须得最后reloadData一下
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.objects.count - 1 inSection:0]]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}
- (void)deleteItems {
    NSInteger index = 1;
    self.flowLayout.removeAnimatedIndex = index;
    [self.objects removeObjectAtIndex:index];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnimateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimateCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor cyanColor];
    cell.lab.text = self.objects[indexPath.row];
    return cell;
}

//cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.objects.count;
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
