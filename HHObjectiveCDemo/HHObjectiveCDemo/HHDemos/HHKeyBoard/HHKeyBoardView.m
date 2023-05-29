//
//  HHKeyBoardView.m
//  HHKeyboard
//
//  Created by Michael on 2020/1/7.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHKeyBoardView.h"
#import "UIResponder+HHFirstResponder.h"
@interface HHKeyBoardView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *objects;

@property (nonatomic, strong)UIButton *delBtn;
@property (nonatomic, strong)UIButton *okBtn;

@end
@implementation HHKeyBoardView
static const CGFloat btnW = 93;
const CGFloat collectionViewH = 220;

- (UIButton *)delBtn
{
    if (!_delBtn) {
        self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delBtn setTitle:@"X" forState:UIControlStateNormal];
        [self.delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}
- (UIButton *)okBtn
{
    if (!_okBtn) {
        self.okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.okBtn setTitle:@"OK" forState:UIControlStateNormal];
        [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.okBtn.titleLabel.font = [UIFont systemFontOfSize:23];
        self.okBtn.backgroundColor = [UIColor blueColor];
        [self.okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
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
- (void)setUpSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.delBtn];
    [self addSubview:self.okBtn];
}
#pragma mark Create CollectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - btnW) / 3, collectionViewH / 4.0);
        //设置每一个分区展示的边缘范围
        flowLayout.sectionInset = UIEdgeInsetsZero;
        //设置行和列之间的最小边距
        flowLayout.minimumLineSpacing = 0;
        ///最小的竖着的间距 横向的相邻的cell之间的间距
        flowLayout.minimumInteritemSpacing = 0;
        //创建集合视图
        self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
        //修改集合视图的背景颜色-默认颜色黑色
        self.collectionView.backgroundColor = [UIColor redColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        self.collectionView.layer.masksToBounds = YES;
        self.collectionView.layer.borderWidth = 0.25;
        self.collectionView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _collectionView;
}
- (NSMutableArray *)objects
{
    if (!_objects) {
        self.objects = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".",@"0",@"-"]];
    }
    return _objects;
}
#pragma mark CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.objects.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *lab = [[UILabel alloc]init];
    
    lab.layer.masksToBounds = YES;
    lab.layer.borderWidth = 0.25;
    lab.layer.borderColor = [UIColor blackColor].CGColor;

    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:24];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = self.objects[indexPath.row];
    [cell.contentView addSubview:lab];
    lab.frame = cell.contentView.bounds;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 输入
    [UIResponder inputText:self.objects[indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == self.objects.count - 1) {
//        return CGSizeMake(([UIScreen mainScreen].bounds.size.width - btnW) / 3.0 * 2, collectionViewH / 4.0);
//    }
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - btnW) / 3, collectionViewH / 4.0);
}

#pragma mark - action
- (void)delAction
{
    [UIResponder hh_deleteBackward];
    // 删除
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDeleteButton:)]) {
        [self.delegate didSelectDeleteButton:self];
    }
}
- (void)okAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSureButton:)]) {
        [self.delegate didSelectSureButton:self];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat collectionViewY = 0;
    self.collectionView.frame = CGRectMake(0, collectionViewY, [UIScreen mainScreen].bounds.size.width - btnW, collectionViewH);
    self.delBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - btnW, collectionViewY, btnW, collectionViewH / 2.0);
    self.okBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - btnW, collectionViewY + collectionViewH / 2.0, btnW, collectionViewH / 2.0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
