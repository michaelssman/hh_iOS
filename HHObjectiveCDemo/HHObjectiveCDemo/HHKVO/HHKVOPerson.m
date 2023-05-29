//
//  HHPerson.m
//  KVODemo
//
//  Created by Michael on 2020/7/20.
//  Copyright © 2020 michael. All rights reserved.
//

#import "HHKVOPerson.h"

@implementation HHKVOPerson
- (NSMutableArray *)mArray{
    if (!_mArray) {
        _mArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _mArray;
}

#pragma mark - 一对多
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"downloadProgress"]) {
        NSArray *affectingKeys = @[@"totalData", @"writtenData"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

- (NSString *)downloadProgress{
    if (self.writtenData == 0) {
        self.writtenData = 10;
    }
    if (self.totalData == 0) {
        self.totalData = 100;
    }
    return [[NSString alloc] initWithFormat:@"%f",1.0f*self.writtenData/self.totalData];
}

#pragma mark - 往复改变 观察不观察的情况，可以手动观察
// 自动开关。关闭之后需要手动观察
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    return NO;
}

//手动观察
- (void)setNick:(NSString *)nick
{
    [self willChangeValueForKey:@"nick"];
    _nick = nick;
    [self didChangeValueForKey:@"nick"];
}

@end
