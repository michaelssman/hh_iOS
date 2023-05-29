//
//  BottomBarViewController.m
//  ExcellentArtProject
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BottomBarViewController.h"
#import "EditingBar.h"
#import <SCM-Swift.h>

#define iPhoneX_BottomHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 34 : 0) //iPhone X适配
#define kMinWordNumber  2

static NSString *const kText = @"text";

@interface BottomBarViewController ()<UITextViewDelegate>

@end

@implementation BottomBarViewController

- (instancetype)initWithModeSwitchButton {
    self = [super init];
    if (self) {
        _editingBar = [[EditingBar alloc] initWithModeSwitchButton];
        _editingBar.editView.delegate = self;
        [_editingBar.editView addObserver:self forKeyPath:kText options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self addDismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)setup
{
    [self addBottomBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //更新输入框高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdate:)    name:UITextViewTextDidChangeNotification object:nil];
}

- (void)addBottomBar
{
    _editingBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_editingBar.inputViewButton addTarget:self action:@selector(switchInputView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editingBar];
    //底部y坐标
    _editingBarYConstraint = [NSLayoutConstraint constraintWithItem:self.view    attribute:NSLayoutAttributeBottom   relatedBy:NSLayoutRelationEqual
                                                             toItem:_editingBar  attribute:NSLayoutAttributeBottom   multiplier:1.0 constant:iPhoneX_BottomHeight];
    
    //评论条高
    _editingBarHeightConstraint = [NSLayoutConstraint constraintWithItem:_editingBar attribute:NSLayoutAttributeHeight         relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self minimumInputbarHeight]];
    
    [self.view addConstraint:_editingBarYConstraint];
    [self.view addConstraint:_editingBarHeightConstraint];
    
}


- (void)switchInputView
{
    [_editingBar.editView becomeFirstResponder];
    
//    [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji"] forState:UIControlStateNormal];
}

#pragma mark - textView的基本设置

- (HHGrowingTextV *)textView
{
    return _editingBar.editView;
}

- (CGFloat)minimumInputbarHeight
{
    return _editingBar.intrinsicContentSize.height;
}

- (CGFloat)deltaInputbarHeight
{
    return _editingBar.intrinsicContentSize.height - self.textView.font.lineHeight;
}

- (CGFloat)barHeightForLines:(NSUInteger)numberOfLines
{
    CGFloat height = [self deltaInputbarHeight];
    
    height += roundf(self.textView.font.lineHeight * numberOfLines);
    
    return height;
}





#pragma mark - 调整bar的高度

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _editingBarYConstraint.constant = keyboardBounds.size.height;
    
//    [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji"] forState:UIControlStateNormal];
    
    [self setBottomBarHeight];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _editingBarYConstraint.constant = iPhoneX_BottomHeight;
    
    [self setBottomBarHeight];
    
}

- (void)setBottomBarHeight
{
#if 0
    NSTimeInterval animationDuration;
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    UIViewKeyframeAnimationOptions animationOptions;
    animationOptions = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
#endif
    // 用注释的方法有可能会遮住键盘
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateKeyframesWithDuration:0.25       //animationDuration
                                   delay:0
                                 options:7 << 16    //animationOptions
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:nil];
}



#pragma mark - 编辑框相关

- (void)textDidUpdate:(NSNotification *)notification
{
    [self updateInputBarHeight];
}

- (void)updateInputBarHeight
{
    CGFloat inputbarHeight = [self appropriateInputbarHeight];
    
    if (inputbarHeight != self.editingBarHeightConstraint.constant) {
        self.editingBarHeightConstraint.constant = inputbarHeight;
        
        [self.view layoutIfNeeded];
    }
}

- (CGFloat)appropriateInputbarHeight
{
    CGFloat height = 0;
    CGFloat minimumHeight = [self minimumInputbarHeight];
    CGFloat newSizeHeight = [self.textView measureHeight];
    CGFloat maxHeight     = self.textView.maxHeight;
    
    self.textView.scrollEnabled = newSizeHeight >= maxHeight;
    
    if (newSizeHeight < minimumHeight) {
        height = minimumHeight;
    } else if (newSizeHeight < self.textView.maxHeight) {
        height = newSizeHeight;
    } else {
        height = self.textView.maxHeight;
    }
    
    return roundf(height);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString: @"\n"]) {
        //判断是否登录  没有登录则进入登录 登录进入详情
//        if ([Utils userIsLogin]) {
            [self judgeSend];
//            [textView resignFirstResponder];
//        } else {
            //进入用户登录界面
//            [Utils login:self];
//        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > kMinWordNumber) {
        _editingBar.inputViewButton.enabled = YES;
    } else {
        _editingBar.inputViewButton.enabled = NO;
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kText]) {
        if (_editingBar.editView.text.length > kMinWordNumber) {
            _editingBar.inputViewButton.enabled = YES;
        } else {
            _editingBar.inputViewButton.enabled = NO;
        }
    }
}

#pragma mark - 收起表情面板

- (void)hideEmojiPageView
{
    if (_editingBarYConstraint.constant != iPhoneX_BottomHeight) {
//        _emojiPageVC.view.hidden = YES;
//        _isEmojiPageOnScreen = NO;
        
//        [_editingBar.inputViewButton setImage:[UIImage imageNamed:@"toolbar-emoji"] forState:UIControlStateNormal];
        _editingBarYConstraint.constant = iPhoneX_BottomHeight;
        [self setBottomBarHeight];
    }
}

- (void)judgeSend {
    if (_editingBar.inputViewButton.enabled) {
        [self sendContent];
    }
}

- (void)sendContent
{
    NSAssert(false, @"Over ride in subclasses");
}

- (void)dealloc
{
    [self removeDismissKeyboard];
    [self.editingBar.editView removeObserver:self forKeyPath:kText];
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
