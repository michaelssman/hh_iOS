//
//  UMShareUtil.h
//  UMDemo
//
//  Created by Michael on 2020/11/27.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMShareUtil : NSObject

+ (void)shareToPlatformType:(UMSocialPlatformType)platformType
              umShareObject:(UMShareObject *)umShareObject;

@end

NS_ASSUME_NONNULL_END
