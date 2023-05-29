//
//  GCDCancelViewController.m
//  HHMultiThread
//
//  Created by michael on 2021/6/21.
//  Copyright © 2021 michael. All rights reserved.
//

#import "GCDCancelViewController.h"

@interface GCDCancelViewController ()

@end

@implementation GCDCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self dispatchBlockCancel];
}
/**
 如果是已经开始的任务 则cancel不了
 */
-(void)dispatchBlockCancel
{
    dispatch_queue_t queue = dispatch_queue_create("QiShareQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t block = dispatch_block_create(0, ^{
        while (1) {
            NSLog(@"gcdgcd");
        }
    });
    dispatch_async(queue, block);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_block_cancel(block);
    });
//    dispatch_block_cancel(block);
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
