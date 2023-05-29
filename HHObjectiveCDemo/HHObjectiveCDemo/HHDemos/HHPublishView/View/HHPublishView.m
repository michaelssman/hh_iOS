//
//  HHPublishView.m
//  HHPublishDemo
//
//  Created by Michael on 2018/8/6.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHPublishView.h"
#import <SCM-Swift.h>
#import "HHMacros.h"
#import <Masonry.h>
#define kEdg    5
@interface HHPublishView() <UITextViewDelegate>
@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, assign)CGFloat textHeight;

/// 字数label
@property (nonatomic, strong)UILabel *countLab;
@end
@implementation HHPublishView
static CGFloat  const textFont = 16;
static int      const textLimit = 1000;
static CGFloat  const animateDuration = 0.05;
- (HHPlaceHolderTV *)textView {
    if (!_textView) {
        _textView = [HHPlaceHolderTV new];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeHolder = @"输入内容";
        _textView.font = [UIFont systemFontOfSize:textFont];
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.delegate = self;
        _textView.scrollEnabled = NO;
    }
    return _textView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceVertical = YES;
        self.contentSize = CGSizeMake(0, self.imgHeight + self.textHeight);
        [self addSubview:self.textView];
        self.textView.frame = CGRectMake(kEdg, kEdg, SCREEN_WIDTH - 2 * kEdg, _textView.font.lineHeight + kEdg);
        
        self.countLab = [[UILabel alloc] initWithTextColor:[UIColor blueColor] fontSize:12];
        [self addSubview:self.countLab];
        [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(0);
            make.right.equalTo(self.textView);
        }];
        
        self.imgV = [[UIImageView alloc]init];
        self.imgV.userInteractionEnabled = YES;
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imgV];
        [self.imgV addSubview:self.deleteBtn];
        WEAKSELF
        [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.textView.mas_bottom).offset(0);
            make.left.mas_equalTo(kEdg);
            make.width.mas_equalTo(SCREEN_WIDTH - 2 * kEdg);
            make.height.mas_equalTo(0);
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        
    }
    return self;
}

- (void)deleteImage {
    self.imgHeight = 0;
    self.contentSize = CGSizeMake(0, self.imgHeight + self.textHeight);
    WEAKSELF
    [self.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.imgHeight);
    }];
    [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeZero);
    }];
    if (self.addSPV) {
        self.addSPV();
    }
}
- (void)reloadDataWithImage:(UIImage *)image {
    [self.imgV setImage:image];
    self.imgHeight = (SCREEN_WIDTH - 2 * kEdg) * 1.0 * image.size.height / image.size.width;
    self.contentSize = CGSizeMake(0, self.imgHeight + self.textHeight);
    WEAKSELF
    [self.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.imgHeight);
    }];
    [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}
#pragma mark - 代理
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    //    NSLog(@"%s   %@",__FUNCTION__,textView.text);
    if (textView.text.length > textLimit) {
        textView.text = [textView.text substringToIndex:textLimit];
    }
    NSString *countStr = [NSString stringWithFormat:@"%ld/%d", textView.text.length,textLimit];
    self.countLab.text = countStr;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //    NSLog(@"%s    %@  %@",__FUNCTION__,textView.text,text);
    
    //更新高度
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        //粘贴文字
        NSString *textViewText = [NSString stringWithFormat:@"%@%@",textView.text,text];
        if (textViewText.length > textLimit) {
            textViewText = [textViewText substringToIndex:textLimit];
        }
        
        height = [self heightForTextView:textView WithText:textViewText];
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:animateDuration animations:^{
        
        textView.frame = frame;
        
    } completion:nil];
    
    //
    NSLog(@"----%f",height);

    self.textHeight = height;
    self.contentSize = CGSizeMake(0, self.imgHeight + self.textHeight);
    
    //限制字数
    if (1 == range.length) {
        return YES;
    }
    if (textView.text.length >= textLimit) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark 根据光标位置设置偏移量
- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSRange range = textView.selectedRange;
    float height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@",[textView.text substringToIndex:range.location > textLimit ? textLimit : range.location]]];
    
    CGFloat selectPicHeight = kSelectPicHeight;
    if (self.imgHeight > 0) {
        selectPicHeight = 0;
    } else {
        selectPicHeight = kSelectPicHeight;
    }
    if (height > SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - self.keyboardHeight - kToolBarHeight - selectPicHeight) {
        [UIView animateWithDuration:animateDuration animations:^{
            self.isEditingScroll = YES;
            self.contentOffset = CGPointMake(0, (height - (SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - self.keyboardHeight - kToolBarHeight - selectPicHeight)));
            //        self.contentInset = UIEdgeInsetsMake(-(height - (SCREEN_HEIGHT - StatusAndNavHeight - self.keyboardHeight - kToolBarHeight - selectPicHeight)),0,0,0);
        } completion:nil];
    }
    NSLog(@"hhhhh---%f",height);
}

//计算评论框文字的高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    
    //多留一行的高度 不然文字可能显示不全
    float padding = textView.font.lineHeight;
    
    CGSize constraint = CGSizeMake(textView.contentSize.width, CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:textFont]}
                                        context:nil];
    float textHeight = size.size.height;
    return textHeight + padding;
}

#pragma mark 设置高度
- (void)setUpFrame {
    CGRect frame = self.textView.frame;
    float height = [self heightForTextView:self.textView WithText:[NSString stringWithFormat:@"%@",self.textView.text]];
    frame.size.height = height;
    [UIView animateWithDuration:animateDuration animations:^{
        
        self.textView.frame = frame;
        
    } completion:nil];
    self.textHeight = height;
    self.contentSize = CGSizeMake(0, self.imgHeight + self.textHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
