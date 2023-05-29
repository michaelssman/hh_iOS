//
//  MyViewController.m
//  MyCommentInputBox
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHCommentInputBoxViewController.h"

@interface HHCommentInputBoxViewController ()

@end

@implementation HHCommentInputBoxViewController
- (instancetype)init {
    self = [super initWithModeSwitchButton];
    if (self) {
        self.editingBar.editView.placeHolder = @"发表看法";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *views = @{@"editingBar": self.editingBar};
    
    //必须设置约束 不然输入框宽度很短
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[editingBar]|" options:0 metrics:nil views:views]];
    
    //必须调用这个才可以输入
    [self.editingBar.editView becomeFirstResponder];

}

- (void)sendContent {
    [self.editingBar.editView resignFirstResponder];
    self.editingBar.editView.placeHolder = @"发表看法";
    self.editingBar.editView.text = @"";

    [self updateInputBarHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
