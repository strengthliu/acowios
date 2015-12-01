//
//  CCUserInfoAPI.h
//  SuperStar
//
//  Created by lucifer on 15/11/20.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"
#import "YTKBaseRequest.h"
#import "Jastor.h"
#import "CCParams-NSDictionary.h"


@interface ACNetWorkAPI : YTKRequest
/**
 *  json校验
 */
@property (nonatomic, copy) NSMutableDictionary *validatorJson; //
/**
 *  网络请求参数
 */
@property (nonatomic, strong) CCParams *params; //
/**
 *  特殊格式时，要增加的参数，暂时只有getUserInfo里，有一个冗余的user_id。
 */
@property (nonatomic, strong) CCParams *additionParams;
/**
 *  返回数据模型
 */
@property (nonatomic, strong) Jastor *model; //
@property (nonatomic, copy) NSString *methodName; //
@property (nonatomic, assign) YTKRequestMethod methodType; //

//- (id)initWithUserId:(NSString *)userId andToken:(NSString*)token;

- (void)addArgument:(id)argument forKey:(NSString*)key;
- (id)getDataModel;
- (void)setDataModel:(Jastor*)model;
@end
