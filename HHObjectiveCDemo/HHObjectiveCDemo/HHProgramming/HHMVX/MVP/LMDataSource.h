//
//  LMDataSource.h
//  HHMVX
//
//  Created by Michael on 2021/5/10.
//  Copyright © 2021 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//声明一个block，用于回调cell，model，下标
typedef void (^CellConfigureBefore)(id cell, id model, NSIndexPath * indexPath);

@interface LMDataSource : NSObject<UITableViewDataSource,UICollectionViewDataSource>

@property (nonatomic, strong)  NSMutableArray *dataArray;;

//自定义
- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before;

//sb
@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;

@property (nonatomic, copy) CellConfigureBefore cellConfigureBefore;


- (void)addDataArray:(NSArray *)datas;

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
