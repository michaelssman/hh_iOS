//
//  HHChapterModel.m
//  HHChapterDemo
//
//  Created by Michael on 2019/8/6.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHChapterModel.h"

@implementation HHChapterModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"Children"]) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in value) {
            HHChapterModel *m = [[HHChapterModel alloc]init];
            m.grade = self.grade + 1;
            [m setValuesForKeysWithDictionary:dic];
            [arr addObject:m];
        }
        self.ChildrenModels = arr;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
