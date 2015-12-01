//
//  NSNull+CCExtension.h
//  SuperStar
//
//  Created by heysound on 15/11/6.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (CCExtension)

- (float)floatValue;
- (double)doubleValue;
- (NSInteger)integerValue;
- (NSUInteger)unsignedIntegerValue;
- (NSString *)string;
- (unsigned long long)unsignedLongLongValue;

@end
