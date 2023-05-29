//
//  HHPublishController.m
//  HHPublishDemo
//
//  Created by Michael on 2018/8/6.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHPublishController.h"
#import "HHPublishView.h"
#import "SelectPictureView.h"
#import "HHPublishToolView.h"
#import "HHMacros.h"
#import <Masonry.h>

@interface HHPublishController ()<UIScrollViewDelegate>
@property (nonatomic, strong)HHPublishView *publishView;
@property (nonatomic, strong)SelectPictureView *spV;
@property (nonatomic, strong)HHPublishToolView *toolView;
@end

@implementation HHPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"publish";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpPublishView];
    [self setUpTool];
    [self setUpSelectPictureView];
    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark setUpViews
- (void)setUpPublishView {
    self.publishView = [[HHPublishView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - TAB_BAR_SAFE_BOTTOM_MARGIN)];
    self.publishView.backgroundColor = [UIColor redColor];
    self.publishView.delegate = self;
    [self.view addSubview:self.publishView];
    WEAKSELF
    self.publishView.addSPV = ^{
        CGRect frame = weakSelf.publishView.frame;
        frame.size.height = frame.size.height - kSelectPicHeight;
        weakSelf.publishView.frame = frame;
        [weakSelf.spV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
    };
}

- (void)setUpTool {
    //初始化工具栏
    _toolView  = [[HHPublishToolView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kToolBarHeight)];
    [self.view addSubview:_toolView];
}

- (void)setUpSelectPictureView {
    WEAKSELF
    self.spV = [[SelectPictureView alloc]init];
    //    spV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kToolBarHeight);
    [self.view addSubview:self.spV];
    [self.spV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.equalTo(weakSelf.toolView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kSelectPicHeight));
    }];
    self.spV.selectPictures = ^{
        //        SRAlbumViewController *vc = [[SRAlbumViewController alloc] init];
        //        vc.resourceType = 0;
        //        vc.albumDelegate = weakSelf;
        //        vc.maxItem = 1;
        //        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //大于一行文字的高度,  因为有可能是文字换行, 高度增加.
    NSLog(@"%s %f %f  %f  %f  %f",__FUNCTION__,self.publishView.textView.frame.size.height,scrollView.contentOffset.y, scrollView.contentSize.height,scrollView.frame.size.height,scrollView.contentSize.height - self.publishView.imgHeight - (SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - self.publishView.keyboardHeight - kToolBarHeight));
    
    //    有图片, 文字多已经上移的情况
    if (self.publishView.imgHeight > 0) {
        //文字内容高度不多的情况, 都在可视范围内.
        if (self.publishView.textView.frame.size.height < (SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - self.publishView.keyboardHeight - kToolBarHeight)) {
            //向上滑动, 并且文字高度不高
            if (scrollView.contentOffset.y > 0) {
                [self.publishView.textView resignFirstResponder];
            }
        } else {
            //文字有移动, 超过了可视范围
            if (scrollView.contentOffset.y - (scrollView.contentSize.height - self.publishView.imgHeight - (SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - self.publishView.keyboardHeight - kToolBarHeight)) > 25) {
                [self.publishView.textView resignFirstResponder];
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.publishView.isEditingScroll = NO;
}
- (void)keyboardWillShow:(NSNotification *)note {
    WEAKSELF
    //键盘弹出时显示工具栏
    //获取键盘的高度
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.publishView.keyboardHeight = keyboardSize.height;
    if (self.publishView.imgHeight > 0) {
        self.publishView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - keyboardSize.height - kToolBarHeight);
    } else {
        self.publishView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - keyboardSize.height - kToolBarHeight - kSelectPicHeight);
    }
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.toolView.frame = CGRectMake(0, SCREEN_HEIGHT-keyboardSize.height - kToolBarHeight - STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, kToolBarHeight);
    }];
}
- (void)keyboardWillHide:(NSNotification *)note {
    WEAKSELF
    //键盘消失时 隐藏工具栏
    self.publishView.keyboardHeight = 0;
    self.publishView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - kToolBarHeight);
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.toolView.frame = CGRectMake(0, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT -kToolBarHeight, SCREEN_WIDTH, kToolBarHeight);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.publishView.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
