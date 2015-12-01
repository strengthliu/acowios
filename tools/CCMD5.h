//
//  CCMD5.h
//  SuperStar
//
//  Created by heysound on 15/10/28.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMD5 : NSObject

// 32位MD5加密
+ (NSString *)md5WithString:(NSString *)str;

@end
