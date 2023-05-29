//
//  HHAddressTool.m
//  ProvinceAndCity
//
//  Created by Michael on 2019/11/25.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHAddressTool.h"

@implementation HHAddressTool
+ (nonnull instancetype)shareTool {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}
- (NSArray *)dataSource0
{
    NSArray *a = @[@"0梵蒂冈",@"0太热话题",@"0太容易"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *s in a) {
        HHAddressModel *model = [[HHAddressModel alloc]init];
        model.title = s;
        [array addObject:model];
    }
    return array;
}
- (NSArray *)dataSource1
{
    NSArray *a = @[@"1反倒是",@"1更好",@"1果然天",@"1反倒是",@"1更好",@"1果然天",@"1反倒是",@"1更好",@"1果然天",@"1反倒是",@"1更好",@"1果然天",@"1反倒是",@"1更好",@"1果然天",@"1反倒是",@"1更好",@"1果然天"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *s in a) {
        HHAddressModel *model = [[HHAddressModel alloc]init];
        model.title = s;
        [array addObject:model];
    }
    return array;
}
- (NSArray *)dataSource2
{
    NSArray *a = @[@"2范德萨",@"2房三大",@"2反倒是"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *s in a) {
        HHAddressModel *model = [[HHAddressModel alloc]init];
        model.title = s;
        [array addObject:model];
    }
    return array;
}
@end
