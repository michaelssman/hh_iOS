//
//  ViewController.m
//  PdfLooker
//
//  Created by apple on 2016/12/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HHPDFViewController.h"
#import "HHPDFView.h"
#import "CatalogueViewController.h"
#import "PageNumberTool.h"
#import "PdfBottomView.h"
#import <SCM-Swift.h>

#define BOOK_NAME                       @"book"

@interface HHPDFViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong)UIPageViewController *pageVC;
@property (nonatomic, strong)NSMutableArray *pdfArr;
@property (nonatomic, strong)CatalogueViewController *catalogueVC;
@property (nonatomic, strong)PdfBottomView *pdfBottomV;
@property (nonatomic, strong)HHNavBarView *navBarView;
@end

@implementation HHPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pdfArr = [NSMutableArray array];
    NSDictionary *options = [NSDictionary  dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [self addChildViewController:_pageVC];
    
    HHPDFView *testPdf = [[HHPDFView alloc]initWithFrame:self.view.frame atPage:1 andFileName:BOOK_NAME];
    CGPDFDocumentRef pdfRef = [testPdf createPDFFromExistFile];
    size_t count = CGPDFDocumentGetNumberOfPages(pdfRef);//这个位置主要是获取pdf页码数；
    
    for (int i = 0; i < count; i++) {
        UIViewController *pdfVC = [[UIViewController alloc] init];
        HHPDFView *pdfView = [[HHPDFView alloc] initWithFrame:self.view.frame atPage:(i+1) andFileName:BOOK_NAME];
        [pdfVC.view addSubview:pdfView];
        
        [_pdfArr addObject:pdfVC];
    }
    
    
    [_pageVC setViewControllers:[NSArray arrayWithObject:_pdfArr[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:_pageVC.view];
    
    
    self.pdfBottomV = [[PdfBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - PdfFlipPageHeight - PdfBottomHeight, SCREEN_WIDTH, PdfFlipPageHeight + PdfBottomHeight)];
    [self.pdfBottomV.catalogueBtn addTarget:self action:@selector(showCatalogueView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pdfBottomV];

    self.pdfBottomV.pageLab.text = [NSString stringWithFormat:@"1/%zu",count];
    self.pdfBottomV.pageSlider.minimumValue = 1.0;
    self.pdfBottomV.pageSlider.maximumValue = count;
    self.pdfBottomV.pageSlider.value = 1.0;
    [self.pdfBottomV.pageSlider addTarget:self action:@selector(handleSliderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navBarView = [[HHNavBarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_AND_NAVIGATION_HEIGHT)];
    self.navBarView.backgroundColor = [UIColor themeColor];
    [self.view addSubview:self.navBarView];
    [self.view bringSubviewToFront:self.navBarView];
    self.navBarView.titleLab.text = @"音准";
    [self.navBarView.leftItem setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [self setUpLockButton];
    
    self.catalogueVC = [[CatalogueViewController alloc]init];
    [self addChildViewController:self.catalogueVC];
    [self.view addSubview:self.catalogueVC.view];
    [self.view bringSubviewToFront:self.catalogueVC.view];
    self.catalogueVC.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    PageNumberTool *pageNumberT = [[PageNumberTool alloc]init];
    NSArray *contents = [pageNumberT getPDFContents:[NSString stringWithFormat:@"%@.pdf",BOOK_NAME]];
    self.catalogueVC.contents = contents;
    __weak typeof(self) weakSelf = self;
    self.catalogueVC.hiddenCatalogueView = ^ {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.catalogueVC.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    };
    self.catalogueVC.jumpToControllerAtIndex = ^ (NSInteger index) {
        [UIView animateWithDuration:0.3 animations:^{
            UIViewController *controller = [weakSelf viewControllerAtIndex:index];
            [weakSelf.pageVC setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }];
    };
}
#pragma mark setUpLockButton
- (void)setUpLockButton {
    UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lockBtn setImage:[UIImage imageNamed:@"icon_Open"] forState:UIControlStateNormal];
    [lockBtn setImage:[UIImage imageNamed:@"icon_Lock"] forState:UIControlStateSelected];
    [lockBtn addTarget:self action:@selector(handleEdgeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lockBtn];
    [self.view insertSubview:lockBtn aboveSubview:self.navBarView];
    [lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-10);
    }];
}
//委托方法；
- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    //Create a new view controller and pass suitable data.
    
    if (([_pdfArr count] == 0 )|| (index > [_pdfArr count]) ) {
        return nil;
    }
    
    
    NSLog(@"index = %ld",(long)index);
    
    return (UIViewController *)_pdfArr[index];
}


- (NSUInteger) indexOfViewController:(UIViewController *)viewController
{
    return [self.pdfArr indexOfObject:viewController];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [_pdfArr count]){
        return  nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if ((index == 0 ) || (index == NSNotFound)){
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

#pragma mark
- (void)showCatalogueView {
    [UIView animateWithDuration:0.3 animations:^{
        self.catalogueVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
#pragma mark
- (void)handleEdgeView:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        if (sender.selected) {
            self.navBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, STATUS_AND_NAVIGATION_HEIGHT);
            self.pdfBottomV.frame = CGRectMake(0, SCREEN_HEIGHT - PdfFlipPageHeight - PdfBottomHeight, SCREEN_WIDTH, PdfFlipPageHeight + PdfBottomHeight);
        } else {
            self.navBarView.frame = CGRectMake(0, -STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, STATUS_AND_NAVIGATION_HEIGHT);
            self.pdfBottomV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PdfFlipPageHeight + PdfBottomHeight);
        }
        sender.selected = !sender.selected;
    }];
}
#pragma mark
- (void)handleSliderAction:(UISlider *)sender {
    self.pdfBottomV.pageLab.text = [NSString stringWithFormat:@"%.0f/%.0f",sender.value,sender.maximumValue];
    UIViewController *controller = [self viewControllerAtIndex:((int)sender.value - 1)];
    [self.pageVC setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
