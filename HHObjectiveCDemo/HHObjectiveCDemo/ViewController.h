//
//  ViewController.h
//  HHObjectiveCDemo
//
//  Created by FN-116 on 2021/12/30.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VCType) {
    VC_Study = 0,
    VC_Demos = 1,            
};

@interface ViewController : UIViewController

- (instancetype)initWithType:(VCType)vcType;

@end

