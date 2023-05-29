//
//  SearchTextField.m
//  LemonCloud
//
//  Created by Michael on 2018/2/24.
//  Copyright © 2018年 sunny. All rights reserved.
//

#import "SearchTextField.h"

@interface SearchTextField ()
@property (nonatomic, strong)UIView *borderView;

@end
@implementation SearchTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuotool"]];
    
    /*
     下面可以设置图片的大小，但是修改位置坐标不管用。
     图片是紧紧贴在输入框的边缘的，那么该怎么设置边距呢？我们可以子类化一个TextField，去复写它的leftViewRectForBounds方法来设置leftView的位置
     */
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(15, 7.5, 15, 14.3)];
    [leftView addSubview:imgView];
    imgView.frame = leftView.bounds;
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    //去除键盘上面的工具栏
    self.inputAccessoryView = [UIView new];
    _placeholderString = @"请输入关键字";
    _placeholderFont = [UIFont systemFontOfSize:12];
    _placeholderColor = [UIColor redColor];
}

#pragma mark 占位文字样式
- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    [self setUpPlaceholder];
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self setUpPlaceholder];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setUpPlaceholder];
}
- (void)setUpPlaceholder
{
    
    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    
    style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - _placeholderFont.lineHeight) / 2.0;
    
    NSDictionary *attr=[NSDictionary dictionaryWithObjectsAndKeys:_placeholderColor,NSForegroundColorAttributeName,_placeholderFont,NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
    
    NSAttributedString * attributeStr = [[NSAttributedString alloc]initWithString:_placeholderString attributes:attr];
    
    self.attributedPlaceholder = attributeStr;
}

#pragma mark 设置圆角
/*
 实在找不到什么有用的方法，所以干脆在UITextField控件底部添加一个view，设置底部的view的圆角和边线的样式。
 */
- (UIView *)borderView {
    if (!_borderView) {
        self.borderView = [[UIView alloc]init];
        [self addSubview:self.borderView];
        self.borderView.layer.masksToBounds = YES;
        ///必须设置这一个 不然点击输入框 不会成为第一响应者
        self.borderView.userInteractionEnabled = NO;
        [self sendSubviewToBack:self.borderView];
    }
    return _borderView;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.borderView.layer.cornerRadius = cornerRadius;
    _cornerRadius = cornerRadius;
}
- (void)setCornerBackgroundColor:(UIColor *)cornerBackgroundColor {
    self.borderView.backgroundColor = cornerBackgroundColor;
    _cornerBackgroundColor = cornerBackgroundColor;
}
#pragma mark设置leftView的位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    CGRect iconRect = [self leftViewRectForBounds:bounds];
    
    placeholderRect.origin.x = CGRectGetMaxX(iconRect) + 20; //像右边偏15
    return placeholderRect;
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect editingRect = [super editingRectForBounds:bounds];
    CGRect iconRect = [self leftViewRectForBounds:bounds];
    
    editingRect.origin.x = CGRectGetMaxX(iconRect) + 20; //像右边偏15
    return editingRect;
}

/**
 输入完成，取消编辑之后，文字的frame。

 @param bounds <#bounds description#>
 @return <#return value description#>
 */
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRect = [super textRectForBounds:bounds];
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    
    textRect.origin.x = CGRectGetMaxX(iconRect) + 20; //像右边偏15
    return textRect;
}

#pragma mark 设置frame
- (void)layoutSubviews {
    [super layoutSubviews];
    self.borderView.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
