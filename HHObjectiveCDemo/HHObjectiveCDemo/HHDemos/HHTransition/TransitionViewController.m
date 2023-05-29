//
//  ViewController.m
//  HHVCAnimatedTransitioning
//
//  Created by michael on 2021/8/24.
//

#import "TransitionViewController.h"
#import "HHTransitionAnimator.h"
#import "AViewController.h"
#import <SCM-Swift.h>
@interface TransitionViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong)HHPresentAnimator *persentAnimator;
@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationController.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    AViewController *vc = [AViewController new];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    AViewController *categoryVC = [[AViewController alloc]init];
    categoryVC.modalPresentationStyle = UIModalPresentationCustom;
    categoryVC.transitioningDelegate = self.persentAnimator;
    [self presentViewController:categoryVC animated:YES completion:nil];
}

- (HHPresentAnimator *)persentAnimator
{
    if (!_persentAnimator) {
        self.persentAnimator = [HHPresentAnimator new];
    }
    return _persentAnimator;
}
#pragma mark - 导航控制器的代理

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [[HHTransitionAnimator alloc] init];
}

@end
