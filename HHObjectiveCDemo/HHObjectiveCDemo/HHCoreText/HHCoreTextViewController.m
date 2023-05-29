//
//  HHCoreTextViewController.m
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2022/1/26.
//

#import "HHCoreTextViewController.h"
#import "HHCoreTextView.h"
@interface HHCoreTextViewController ()

@end

@implementation HHCoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HHCoreTextView *v = [[HHCoreTextView alloc]initWithFrame:self.view.bounds];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
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
