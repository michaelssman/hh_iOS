//
//  PdfBottomView.h
//  PdfLooker
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PdfBottomHeight   60
#define PdfFlipPageHeight 100

@interface PdfBottomView : UIView
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIButton *catalogueBtn;
@property (nonatomic, strong)UIButton *pageBtn;
@property (nonatomic, strong)UIView *flipPageView;
@property (nonatomic, strong)UILabel *pageLab;
@property (nonatomic, strong)UISlider *pageSlider;
@end
