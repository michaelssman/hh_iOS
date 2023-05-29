//
//  HHDetectionDelegate.h
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/12/22.
//  定义公共方法

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HHDetectionDelegate <NSObject>
- (void)didDetect:(NSArray *)metadataObjects;
@end

NS_ASSUME_NONNULL_END
