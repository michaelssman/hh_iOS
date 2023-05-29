//
//  LGPerson.h
//  HHObjectiveCDemo
//
//  Created by Michael on 2022/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGPerson : NSObject

// 16倍数。48字节
//isa 8字节
@property (nonatomic ,copy) NSString *name;//8字节
@property (nonatomic ,copy) NSString *hobby;//8字节
@property (nonatomic ,assign) int age;//4字节
@property (nonatomic ,assign) double hight;//8字节
@property (nonatomic ,assign) short number;//2字节
@property (nonatomic ,assign) char a;//1字节

-(void)instanceMethod;
+(void)classMethod; //rw -- ro // NSObject -- --

@end

NS_ASSUME_NONNULL_END
