//
//  CCEnv.h
//  SuperStar
//
//  Created by lucifer on 15/11/24.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import "Foundation/Foundation.h"
//#import "CCNetWorkAPI.h"

#import "CCMD5.h"
#define APP_KEY @"ios_6c0ed5b15c21f77b"
#define MD5_SUF @"7309411ef89c88a914e2d69c1857a645"
#define POST_LOGIN @"login"
#define POST_SENDCAPTCHA @"sendCaptcha"
#define POST_CHECKCAPTCHA @"checkCaptcha"
#define POST_REGISTER @"register"
#define POST_RESET @"resetPwd"
#define POST_USERINFO @"getUserInfo"
#define JSON_RPC @"2.0"
#define kAppKey @"app_key"
#define kSign   @"sign"
#define kTime   @"time"
#define kUserPhone @"user_phone"
#define kPassword @"user_pwd"
#define kNickname @"nickname"
#define kSex @"sex"
#define kJsonRPC @"jsonrpc"
#define kMethod @"method"
#define kParams @"params"
#define kUserID @"id"
#define kUsage  @"usage"
#define kCaptcha @"captcha"
#define kPicUrl @"pic_url"
#define kUserMeta @"user_meta"

#define kUserIDInfo @"user_id"
#define kToken @"token"


typedef NS_ENUM(NSInteger,ProductEnvMode) {
    ProductDevMode = 0, // 开发状态
//    ProductDebugMode, // 自测、调试状态
    ProductTestMode, // 集成测试
//    ProductAlaphaMode, //
    ProductReleaseMode
};

@interface CCEnv : NSObject
@property (nonatomic, assign) ProductEnvMode envMode;
@property (nonatomic, assign) NSDictionary *devURLs;
@property (nonatomic, assign) NSDictionary *testURLs;
@property (nonatomic, assign) NSDictionary *releaseURLs;
+ (instancetype)sharedInstancde;

/**
 *  根据调用方法名，及envMode，取服务地址。
 *
 *  @param byMethodName <#byMethodName description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)getServerURL:(NSString*)byMethodName;

@end
