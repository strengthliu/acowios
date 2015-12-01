//
//  NSString+CCExtension.m
//  SuperStar
//
//  Created by heysound on 15/11/6.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import "NSString+CCExtension.h"
#import "NSNull+CCExtension.h"

@implementation NSString (CCExtension)

+ (NSString *)jsonString:(id)obj
{
    if ([obj isMemberOfClass:[NSNull class]]) {
        return @"";
    }
    
    return (NSString *)obj;
}

@end
