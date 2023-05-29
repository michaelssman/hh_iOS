//
//  HHEmojiView.m
//  HHCollectionView
//
//  Created by FN-116 on 2021/12/15.
//

#import "HHEmojiView.h"
#import "YHLongPressPhotoBrowser.h"

@interface HHEmojiViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation HHEmojiViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.frame = self.bounds;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end

@interface HHEmojiHeaderView ()
@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation HHEmojiHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.frame = self.bounds;
        [self addSubview:self.titleLab];
    }
    return self;
}

@end

@implementation HHEmojiFooterView

@end

@interface HHEmojiView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) YHLongPressPhotoBrowser *photoBrowser;

/// 保存上次选中的cell，如果是同一个就不需要重新显示
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end
@implementation HHEmojiView

#pragma mark - lazyLoad
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //1:创建一种布局(UICollectionViewFlowLayout是系统为我们提供的一种具体的布局样式)
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //修改每一个cell的尺寸
        flowLayout.itemSize = CGSizeMake(36, 36);
        //设置每一个分区展示的边缘范围
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        //设置行和列之间的最小边距
        flowLayout.minimumLineSpacing = 6;
        flowLayout.minimumInteritemSpacing = 9;//列和列之间的间距 竖线和竖线的间距
        //返回集合视图每一个分区的区头（区尾）的尺寸
        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 34);
        flowLayout.footerReferenceSize = CGSizeMake(self.frame.size.width, 20);
        //设置集合视图的滚动方向
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //2:创建集合视图
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //修改集合视图的背景颜色-默认颜色黑色
        self.collectionView.backgroundColor = [UIColor whiteColor];
        //VIP:指定集合视图的dataSource和delegate
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //4:注册对应的cell
        [self.collectionView registerClass:[HHEmojiViewCell class] forCellWithReuseIdentifier:@"HHEmojiViewCell"];
        //为集合视图每一个分区设置区头或区尾的过程中首先需要注册区头（区尾）然后通过对应的协议方法在该方法中按照注册的区头（区尾）获得对应的区头（区尾）
        //5:注册对应的区头（区尾）
        /*
         UICollectionElementKindSectionHeader:代表注册的是分区的区头
         UICollectionElementKindSectionFooter：代表注册的是分区的区尾
         */
        [self.collectionView registerClass:[HHEmojiHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHEmojiHeaderView"];
        [self.collectionView registerClass:[HHEmojiFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HHEmojiFooterView"];
    }
    return _collectionView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.backgroundColor = [UIColor blueColor];
        self.deleteButton.layer.masksToBounds = YES;
        self.deleteButton.layer.cornerRadius = 14.0;
        self.deleteButton.layer.borderColor = [UIColor redColor].CGColor;
        self.deleteButton.layer.borderWidth = 0.5;
    }
    return _deleteButton;
}

- (YHLongPressPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        _photoBrowser = [[YHLongPressPhotoBrowser alloc]initWithGestureView:self.collectionView];
        //设置长按大图弹窗宽高
        _photoBrowser.exWidth = 74;
        _photoBrowser.exHeight = 95;
    }
    return _photoBrowser;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}
- (void)setUpSubViews {
    [self addSubview:self.collectionView];
    __weak typeof(self) weakself = self;
    self.photoBrowser.bz_dataSource = ^(UILongPressGestureRecognizer * _Nonnull recognizer, LocationInTarget  _Nonnull locationInTarget) {
        [weakself locationInImageView:recognizer
                     locationInTarget:locationInTarget];
    };
//    self.photoBrowser.bz_expression = ^(UIImageView * _Nonnull displayView, YHExpression * _Nonnull expression) {
//        //设置图片，网络
//
//    };
    self.photoBrowser.endGestureRecognizer = ^{
        weakself.lastIndexPath = nil;
    };
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"boss_emoji" ofType:@"plist"]];
    
    [dataDict enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        YHExpression *e = [YHExpression new];
        e.exImage = obj;
        e.exTitle = key;
        [self.dataList addObject:e];
    }];
    [self.collectionView reloadData];
    [self addSubview:self.deleteButton];
}

//把点击的cell的view和数据通过block代码块保存传给YHLongPressPhotoBrowser里面
- (void)locationInImageView:(UILongPressGestureRecognizer*)recognizer
           locationInTarget:(LocationInTarget)locationInTarget {
    CGPoint locationTable = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:locationTable];
    if (self.lastIndexPath != indexPath) {
        HHEmojiViewCell *targetCell = (HHEmojiViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        YHExpression *e = self.dataList[indexPath.item];
        locationInTarget(targetCell.imageView,e);
    }
    self.lastIndexPath = indexPath;
}

-(void)dealloc {
    NSLog(@"YHCollectionViewController dealloc");
}

#pragma mark CollectionView DataSource
//返回每一个分区的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}
//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HHEmojiViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHEmojiViewCell" forIndexPath:indexPath];
    YHExpression *e = self.dataList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:e.exImage];
    return cell;
}
//返回每一个分区的区头或者区尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        //返回对应分区的区头
        HHEmojiHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HHEmojiHeaderView" forIndexPath:indexPath];
        header.titleLab.text = @"全部表情";
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        HHEmojiFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HHEmojiFooterView" forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    CGFloat deleteButtonWidth = 54;
    self.deleteButton.frame = CGRectMake(self.bounds.size.width - deleteButtonWidth - 4, self.bounds.size.height - 28 - 8, deleteButtonWidth, 28);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
