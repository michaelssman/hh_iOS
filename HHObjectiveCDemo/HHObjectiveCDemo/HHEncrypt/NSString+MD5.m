//
//  NSString+MD5.m
//  HHEncrypt
//
//  Created by FN-116 on 2021/12/13.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
//#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (MD5)

- (NSString *)md5_decrypt:(NSString *)key {
    if(self == nil || [self length] == 0)
        return nil;
    
    //MD5是基于C语言的，先转化为C字符串
    const char * str = [self UTF8String];
    //创建一个数组，接受MD5加密的值
    uint8_t outputBuffer[CC_MD5_DIGEST_LENGTH];
    //把str字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    CC_MD5(str, (CC_LONG)strlen(str), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    //把C字符串取出来，转化成NSString类型
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    NSString *result = [outputString copy];
    return result;
}
- (NSString *)md5_encrypt:(NSString *)key {
    return @"";
}

@end
