//
//  HHModuleViewController.m
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/5/21.
//

#import "HHModuleViewController.h"
#import <HHCat/HHCat-umbrella.h>

//@import HHCat;

//@import Cat.HHCat;

@interface HHModuleViewController ()

@end

@implementation HHModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HHCat *cat = [[HHCat alloc] init];
    [cat catSpeak];
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
