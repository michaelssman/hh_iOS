//
//  HHSpringAnimationViewController.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2022/1/12.
//

#import "HHSpringAnimationViewController.h"
#import "UIView+HHAnimation.h"
@interface HHSpringAnimationViewController ()<CAAnimationDelegate>
// 动画视图
@property(nonatomic,strong)UIView *animationView;
@end

@implementation HHSpringAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *vvv = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
    [self.view addSubview:vvv];
    vvv.backgroundColor = [UIColor cyanColor];
    
    self.animationView = vvv;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20.0;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"开始动画" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnA) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 400, 100, 80);
}

- (void)btnA {
    [self.animationView scaleForeverAnimation];
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
