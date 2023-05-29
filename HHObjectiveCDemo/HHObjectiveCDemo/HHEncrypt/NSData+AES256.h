//
//  NSData+AES256.h
//  ios-test
//
//  Created by ebsinori on 2016/12/16.
//  Copyright © 2016年 bnqc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(AES256)
-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;
@end
