//
//  HHIAPManager.h
//  HHPayDemo
//
//  Created by FN-116 on 2021/11/26.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHIAPManager : NSObject<SKPaymentTransactionObserver>
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
