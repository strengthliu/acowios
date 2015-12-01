//
//  CCEnv.m
//  SuperStar
//
//  Created by lucifer on 15/11/24.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import "CCEnv.h"

@interface CCEnv()
//@property (nonatomic,assign) NSDictionary *devURLs;
//@property (nonatomic,assign) NSDictionary *testURLs;
//@property (nonatomic,assign) NSDictionary *releaseURLs;
@end

static CCEnv *instance = nil;

@implementation CCEnv {
}

+ (NSDictionary*)devURLs {
    NSDictionary* _devURLs = @{
                     @"sendCaptcha"     :   @"http://192.168.199.223:8080/superstar.rpc/userRpc",
                     @"checkCaptcha"    :   @"http://192.168.199.223:8080/superstar.rpc/userRpc",
                     @"register"        :   @"http://192.168.199.223:8080/superstar.rpc/userRpc",
                     @"login"           :   @"http://192.168.199.223:8080/superstar.rpc/userRpc",
                     @"getUserInfo"     :   @"http://192.168.199.223:8080/superstar.rpc/userRpc",
                     @"updateUserInfo"  :   @"http://192.168.199.223:8080/superstar.rpc/userRpc",
                     @"resetPwd"        :   @"http://192.168.199.223:8080/superstar.rpc/userRpc",
                     @"getMyTicketInfos":   @"http://192.168.199.223:8080/superstar.rpc/userRpc"
                     };
    return _devURLs;
}

+ (NSDictionary*)testURLs {
    NSDictionary* _testURLs = @{
                      @"sendCaptcha"     :   @"http://120.55.197.183:8092/superstar.rpc/userRpc",
                      @"checkCaptcha"    :   @"http://120.55.197.183:8092/superstar.rpc/userRpc",
                      @"register"        :   @"http://120.55.197.183:8092/superstar.rpc/userRpc",
                      @"login"           :   @"http://120.55.197.183:8092/superstar.rpc/userRpc",
                      @"getUserInfo"     :   @"http://120.55.197.183:8092/superstar.rpc/userRpc",
                      @"updateUserInfo"  :   @"http://120.55.197.183:8092/superstar.rpc/userRpc",
                      @"resetPwd"        :   @"http://120.55.197.183:8092/superstar.rpc/userRpc",
                      @"getMyTicketInfos":   @"http://120.55.197.183:8092/superstar.rpc/userRpc"
                      };
    return _testURLs;
}

+ (NSDictionary*)releaseURLs {
    NSDictionary* _releaseURLs = @{
                    @"sendCaptcha"     :   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc",
                    @"checkCaptcha"    :   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc",
                    @"register"        :   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc",
                    @"login"           :   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc",
                    @"getUserInfo"     :   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc",
                    @"updateUserInfo"  :   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc",
                    @"resetPwd"        :   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc",
                    @"getMyTicketInfos":   @"http://rpc.livehey.com:8092/superstar.rpc/userRpc"
                         };
    
    return _releaseURLs;
}

+ (ProductEnvMode)envMode {
    return ProductDevMode;
}

- (instancetype)init{
    self = [super init];
    if (self){
        _envMode = ProductDevMode;
    }
    return self;
}

+ (instancetype)sharedInstancde {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

/**
 *  根据调用方法名，及envMode，取服务地址。
 *
 *  @param byMethodName <#byMethodName description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getServerURL:(NSString*)byMethodName{
    switch (CCEnv.envMode) {
        case ProductDevMode:
            return [CCEnv.devURLs valueForKey:byMethodName];
            break;

        case ProductTestMode:
            return [CCEnv.testURLs valueForKey:byMethodName];
            break;

        case ProductReleaseMode:
            return [CCEnv.releaseURLs valueForKey:byMethodName];
            break;

        default:
            break;
    }
    return nil;
}


@end
