//
//  NSNull+CCExtension.m
//  SuperStar
//
//  Created by heysound on 15/11/6.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import "NSNull+CCExtension.h"

@implementation NSNull (CCExtension)

- (float)floatValue
{
    return 0.0f;
}

- (double)doubleValue
{
    return 0.0;
}

- (NSInteger)integerValue
{
    return 0;
}

- (NSUInteger)unsignedIntegerValue
{
    return 0;
}

- (NSString *)string
{
    return @"";
}

- (unsigned long long)unsignedLongLongValue
{
    return 0;
}


@end
