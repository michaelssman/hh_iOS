//
//  HHEmojiViewController.m
//  HHCollectionView
//
//  Created by Michael on 2021/1/4.
//

#import "HHEmojiViewController.h"
#import "CellAnimateViewController.h"
#import "HHEmojiView.h"
@interface HHEmojiViewController ()

@end

@implementation HHEmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    HHEmojiView *emojiView = [[HHEmojiView alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 400)];
    [self.view addSubview:emojiView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.navigationController pushViewController:[[CellAnimateViewController alloc]init] animated:YES];
}
@end
