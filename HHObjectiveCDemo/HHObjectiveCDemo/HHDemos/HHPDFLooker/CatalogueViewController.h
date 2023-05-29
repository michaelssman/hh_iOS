//
//  CatalogueViewController.h
//  PdfLooker
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalogueViewController : UIViewController
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, copy) void (^hiddenCatalogueView)();
@property (nonatomic, copy) void (^jumpToControllerAtIndex)(NSInteger index);
@end
