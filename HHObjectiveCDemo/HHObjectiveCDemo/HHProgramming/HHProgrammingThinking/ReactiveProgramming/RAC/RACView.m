//
//  RACView.m
//  HHMVX
//
//  Created by FN-116 on 2021/11/4.
//  Copyright © 2021 michael. All rights reserved.
//

#import "RACView.h"
@implementation RACView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 20.0;
        button.layer.borderColor = [UIColor blueColor].CGColor;
        button.layer.borderWidth = 1.0;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"你点我啊" forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20);
        [self addSubview:button];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"RAC方法调用");
            [self.btnClickSignal sendNext:@"按钮点击了"];
            [self testRACView:self par:@"我是参数"];
        }];
    }
    return self;
}

- (RACSubject *)btnClickSignal {
    if (!_btnClickSignal) {
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
