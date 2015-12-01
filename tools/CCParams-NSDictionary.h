//
//  CCParams.h
//  SuperStar
//  顺序化的NSDictionary
//  Created by lucifer on 15/11/23.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import <Foundation/Foundation.h>

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


typedef NS_ENUM(NSInteger, CCParamStringType){
    CCCommonParamType = 0,
    CCJsonParamType
};

@interface NSDictionary ()
/**
 *  使用NSDictionary具有有序能力。
 *
 *  @return 具有有序能力的NSDictionary -- CCParams
 */
- (id)initToOrderedAbility;

/**
 *  用指定块对key排序。
 *  必须是initToOrderedAbility后执行。
 *  @param sortBlock 用于排序的块，参数是NSArray。
 */
- (void)sortByBlock_:(void (^)(NSArray*))sortBlock;

/**
 *  NSDictionary在initToOrderedAbility后，系统并知道正确的key顺序是什么。
 *  我们可以使用默认的(allKeys)，也可以手动添加一个key的有序列表。
 *  必须是initToOrderedAbility后执行。
 *  这个keyList必须包含原NSDictionary的keys，如果没有，将抛出异常。
 *  @param keyList 待加入的keyList。
 */
- (void)addKeyList_:(NSArray*)keyList;

/**
 *  获取得有序keyList。如果
 *  必须是initToOrderedAbility后执行。
 *  @return <#return value description#>
 */
- (NSArray*)getKeyList_;

- (void)rebuildMd5Sign;
@end

@interface CCParams : NSMutableDictionary
- (void) test;
/**
 *  返回按顺序拼起来的参数字符串，用于签名使用。
 *  @return 拼好的字符串。
 */
- (NSString*)getParamString;

/**
 *  增加一个子参数。可以是任意类型，包括也是CCParam参数类型。
 *  @param value 参数值
 *  @param key   参数key值，NSString*类型
 */
- (void)addParam:(id)value forKey:(NSString *)key;
- (void)addParam:(CCParams*)value ;

- (BOOL)isEncode;
/**
 *  返回该参数的描述，以json字符串形式。
 *  @return 字符串
 */
- (NSString*)jsonDescription;

/**
 *  返回该参数的描述，以字典形式。
 *  @return <#return value description#>
 */
- (NSDictionary*)dictionaryDescription;

- (void)sortByBlock:(void (^)(NSArray*))sortBlock;

/**
 *  添加一个key的有序列表。
 *
 *  @param keyList <#keyList description#>
 */
- (void)addKeyList:(NSArray*)keyList;

- (NSArray*)getKeyList;

- (void)rebuildDd5Sign;

@end


/**
 为实现NSJSONSerialization dataWithJSONObject也有序，实现一个NSEnumerator的有序子类。
 */
@interface CCSortAbleEnumerator : NSEnumerator
- (instancetype)initWithArray:(NSArray*)array;
@end
