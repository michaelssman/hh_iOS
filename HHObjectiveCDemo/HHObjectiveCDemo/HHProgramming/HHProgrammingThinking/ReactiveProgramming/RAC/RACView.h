//
//  RACView.h
//  HHMVX
//
//  Created by FN-116 on 2021/11/4.
//  Copyright © 2021 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACView : UIView
@property (nonatomic, strong)RACSubject *btnClickSignal;

- (void)testRACView:(RACView *)view par:(NSString *)par;
@end

NS_ASSUME_NONNULL_END
