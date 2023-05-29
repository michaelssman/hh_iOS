//
//  CalculateManager.h
//  HHProgrammingThinking
//
//  Created by Michael on 2020/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HHBlock)(NSString *parm1, NSString *parm2);

@interface CalculateManager : NSObject

//分工明确 代码集中
@property (nonatomic, copy)void (^testB)(NSString *testBParm, HHBlock hhblock);

@property (nonatomic, assign)int result;

- (instancetype)manager:(int(^)(int result))block;

- (void)testFunc;
@end

NS_ASSUME_NONNULL_END
