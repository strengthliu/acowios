//
//  CCUserInfoAPI.m
//  SuperStar
//
//  Created by lucifer on 15/11/20.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import "ACNetWorkAPI.h"
//#import "CCPersonalDocument.h"
//#import "CCUrlRequest.h"
#import "CCMD5.h"
#import "CCEnv.h"


@implementation ACNetWorkAPI

@synthesize methodName;

/**
 *  使用Post方法
 *  在AFURLResponseSerialization中，访问类型默认值没有@"application/json-rpc"，导致正确返回，也报错。有两种办法，一是修改YTK，二是修改AFURLResponseSerialization。
     在下面的方法中，加入@"application/json-rpc"，不能用，因为在这个时候，还没有构造responseSerializer，所以不能执行。
     现在先修改AFURLResponseSerialization，简单点，但改动底层，不利维护。以后再修改吧。
 *  @return <#return value description#>
 */
- (YTKRequestMethod)requestMethod {
    return _methodType;
}

- (id)init {
    self = [super init];
    if (self) {
        _validatorJson = [[NSMutableDictionary alloc] init];
        _methodType = YTKRequestMethodPost;
    }
    return self;
}

- (CCParams *)additionParams {
    @try {
        if (!_additionParams) {
            _additionParams = [[CCParams alloc] init];
        }
        return _additionParams;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
    }
}

- (CCParams *)params {
    @try {
        if (!_params) {
            _params = [[CCParams alloc] init];
        }
        return _params;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
//        NSLog(@"(CCParams *)params : return nil.");
//        return nil;
    }
}


- (NSString *)requestUrl {
    return [CCEnv getServerURL:[self methodName]];
}

/**
 *  添加网络请求参数
 *
 *  @param argument <#argument description#>
 */
// TODO: argument不是指针，可能会出错。
- (void)addArgument:(id)argument forKey:(NSString*)key {
    [self.params addParam:argument forKey:key];
}

/**
 *  设置返回数据模型。必须是Jastor类型，要不然就没法自动包装了。
 *
 *  @param model <#model description#>
 */
- (void)setDataModel:(Jastor*)model{
    self.model = model;
}

/**
 *  返回网络请求参数
 *
 *  @return 网络请求参数
 */
- (id)requestArgument {
    
    // 时间
    NSDate* dat = [NSDate date];//[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000000;
    NSString *timeString = [NSString stringWithFormat:@"%llf", a];
    
    NSRange range = [timeString rangeOfString:@"."];
    int location = range.location;
    timeString = [timeString substringToIndex:location];
    NSString *timeStr = [NSString stringWithFormat:@"%@", timeString];
//    NSString *timeStr = [NSString stringWithFormat:@"%lld", time];
//    NSLog(@"current timeStr : %@",timeStr);
    NSString *paramString1 = [self.params getParamString];
    NSString *paramString = [paramString1 stringByReplacingOccurrencesOfString:@" " withString:@""];  
//    // ID
//    NSString *userID = [NSString stringWithFormat:@"%lld", userid];
//    NSString *userToken = [NSString stringWithFormat:@"%lld", token];
    // 生成签名
    NSMutableString *sign = [NSMutableString string];
    [sign appendString:APP_KEY];
    [sign appendString:timeStr];
    [sign appendString:paramString];
    [sign appendString:MD5_SUF];
//    NSLog([sign description]);
    NSString *md5Sign = [CCMD5 md5WithString:sign];
//    NSLog(md5Sign);
//    NSDictionary *userMeta = @{
//                               kToken :   token,
//                               kUserIDInfo :   userid
//                               };
    CCParams *_p_param = [[CCParams alloc] init];
    [_p_param addParam:APP_KEY forKey:kAppKey];
    [_p_param addParam:md5Sign forKey:kSign];
    [_p_param addParam:timeStr forKey:kTime];
    [_p_param addParam:_params];
    CCParams *addp = self.additionParams;
    [_p_param addParam:addp];
    
    CCParams *ret = [[CCParams alloc] init];
    [ret addParam:JSON_RPC forKey:kJsonRPC];
    [ret addParam:methodName forKey:kMethod];
    [ret addParam:_p_param forKey:kParams];
    [ret addParam:@"" forKey:kUserID];
    
    return ret;
}

/**
 *  返回json检查格式。
 *  如果设置了数据模型，解析数据模型，返回根据他生成的检查格式。
 *  @return <#return value description#>
 */
- (id)jsonValidator {
    return nil;
//    NSDictionary *validatorJsont;
//    validatorJsont = [CCUrlRequest mobileCheckUserInfoResult];
//    validatorJson = validatorJsont objectForKey:<#(nonnull id)#>
//    return validatorJsont;
//    return @{
//             @"nick": [NSString class],
//             @"level": [NSNumber class]
//             };
}

- (NSInteger)cacheTimeInSeconds {
    return 60 * 3;
}


/**
 *  获取取从网络取到的数据模式。
 *
 *  @return <#return value description#>
 */
- (id)getDataModel {
    id rsj = [self responseJSONObject];
    if (rsj){
        if (self.model) {
            NSDictionary *nsd = [rsj objectForKey:@"result"];
            return [self.model initWithJsonDictionary:nsd];
        } else {
        return nil;
        }
    }
    return nil;
}


- (id)getDataModel:(id)json {
    id rsj = json;
    if (rsj){
        if (self.model) {
            NSDictionary *nsd = [rsj objectForKey:@"result"];
            return [self.model initWithJsonDictionary:nsd];
        }
        else {
            return nil;
        }
    }
    return nil;
}

//- (CCPersonalDocument *)userInfo {
//    CCPersonalDocument *ret = [[CCPersonalDocument alloc] init];
//    ret.userId = [[[self responseJSONObject] objectForKey:@"userId"] stringValue];
//    
//    return ret;
//}

//- (id)buildByJson:(id)json withInstance:(id)instance {
//
////    instance setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>
//    if ([json isKindOfClass:[NSDictionary class]] &&
//        [validatorJson isKindOfClass:[NSDictionary class]]) {
//        NSDictionary * dict = json;
//        NSDictionary * validator = validatorJson;
//        BOOL result = YES;
//        NSEnumerator * enumerator = [validator keyEnumerator];
//        NSString * key;
//        while ((key = [enumerator nextObject]) != nil) {
//            id value = dict[key];
//            id format = validator[key];
//            if ([value isKindOfClass:[NSDictionary class]]
//                || [value isKindOfClass:[NSArray class]]) {
//                result = [self checkJson:value withValidator:format];
//                if (!result) {
//                    break;
//                }
//            } else {
//                if ([value isKindOfClass:format] == NO &&
//                    [value isKindOfClass:[NSNull class]] == NO) {
//                    result = NO;
//                    break;
//                }
//            }
//        }
//        return result;
//    } else if ([json isKindOfClass:[NSArray class]] &&
//               [validatorJson isKindOfClass:[NSArray class]]) {
//        NSArray * validatorArray = (NSArray *)validatorJson;
//        if (validatorArray.count > 0) {
//            NSArray * array = json;
//            NSDictionary * validator = validatorJson[0];
//            for (id item in array) {
//                BOOL result = [self checkJson:item withValidator:validator];
//                if (!result) {
//                    return NO;
//                }
//            }
//        }
//        return YES;
//    } else if ([json isKindOfClass:validatorJson]) {
//        return YES;
//    } else {
//        return NO;
//    }
//}



@end
