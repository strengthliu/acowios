//
//  CCMD5.m
//  SuperStar
//
//  Created by heysound on 15/10/28.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import "CCMD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CCMD5

#pragma mark 32位MD5数据加密
+ (NSString *)md5WithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char md5_dat[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), md5_dat);
    
    NSMutableString *retStr = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [retStr appendString:[NSString stringWithFormat:@"%02x", *(md5_dat+i)]];
    }
    
    return retStr;
}

@end
