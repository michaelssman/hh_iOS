//
//  ViewController.m
//  PuBuLiu
//
//  Created by 王艳清 on 16/7/1.
//  Copyright © 2016年 王艳清. All rights reserved.
//

#import "FallViewController.h"
#import "HHFallFlowLayout.h"
#import "ToViewController.h"
#import "CustomTransition.h"
#define DMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define DMRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DMRandColor DMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface FallViewController () <FallFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation FallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HHFallFlowLayout *layout = [[HHFallFlowLayout alloc] init];
    layout.columnCount = 2;
    layout.delegate = self;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 20, 5);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 60;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = DMRandColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ToViewController *toVC = [[ToViewController alloc] init];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    toVC.color = cell.backgroundColor;
    self.currentIndexPath = indexPath;
    self.navigationController.delegate = toVC;
    [self.navigationController pushViewController:toVC animated:YES];
}

#pragma mark - layout的代理事件

- (CGFloat)fallFlowLayout:(HHFallFlowLayout *)fallFlowLayout
       itemHeightForWidth:(CGFloat)itemWidth
              atIndexPath:(NSIndexPath *)indexPath {
    return arc4random_uniform(80) + 120;
}



@end
