//
//  HHCamera.h
//  HHSelectPhoto
//
//  Created by Michael on 2018/9/11.
//  Copyright © 2018年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHNative : NSObject

/**
 创建单利

 @return <#return value description#>
 */
+ (nonnull instancetype)sharedInstance;

/**
 打开摄像头

 @param vc <#vc description#>
 */
- (void)openCameraWithController:(UIViewController *)vc;

/**
 打开相册

 @param vc <#vc description#>
 */
- (void)openPhotoWithController:(UIViewController *)vc;
@property (nonatomic, copy)void (^resultAsset)(PHAsset *asset, NSError *error);

@end

NS_ASSUME_NONNULL_END
