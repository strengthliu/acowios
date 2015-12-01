//
//  CCParams.m
//  SuperStar
//
//  Created by lucifer on 15/11/23.
//  Copyright © 2015年 heysound. All rights reserved.
//

#import <objc/runtime.h>

#import <Foundation/NSObject.h>
#import <Foundation/NSEnumerator.h>

#import "CCParams-NSDictionary.h"
#import "CCMD5.h"

/**
 =============== NSDictionary (CCParams) ================
 */

@implementation NSDictionary (CCParams)
CCParams *__self;

- (id)initToOrderedAbility {
    if (!self) {
        self = [super init];
    }
    if (!__self) {
        __self = [[CCParams alloc] initWithDictionary:self];
        [self override:self from:__self];
    }
    return self;
}

-(id)override:(NSDictionary*)nsd from:(CCParams*)param {
    if (self && param) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class nsdclass = [NSDictionary class];
            Class paramclass = [CCParams class];
            SEL _s_selectors[] = {
                @selector(setValue:forKey:),
                @selector(sortByBlock_:),
                @selector(addKeyList_:),
                @selector(getKeyList_),
                @selector(rebuildMd5Sign)
            };
            SEL _t_selectors[] = {
                @selector(_setValue:forKey:),
                @selector(sortByBlock:),
                @selector(addKeyList:),
                @selector(getKeyList),
                @selector(rebuildDd5Sign)
            };
            
            for (int i=0, len=sizeof(_s_selectors)/sizeof(_s_selectors[0]); i<len; i++) {
                SEL _s_selector = _s_selectors[i];
                SEL _t_selector = _t_selectors[i];
                
                [self redirectMethod:nsdclass andMethodSEL:_s_selector replaceWithClass:paramclass andOtherMethodSEL:_t_selector];
            }
        });
    }
    return self;
}

- (BOOL) swithMethod:(Class)_clazz andMethodSEL:(SEL)_methodSEL replaceWithClass:(Class)_otherClass andOtherMethodSEL:(SEL)_otherMethodSEL{
    Method originalMethod = class_getInstanceMethod(_clazz, _methodSEL);
    Method swizzledMethod = class_getInstanceMethod(_otherClass, _otherMethodSEL);
    
    NSLog(@"originalMethod: %p",originalMethod);
    NSLog(@"swizzledMethod: %p",swizzledMethod);
    
    BOOL didAddMethod =
    class_addMethod(_clazz,
                    _methodSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
                class_replaceMethod(_clazz,
                                    _otherMethodSEL,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
        NSLog(@"originalMethod: %p",originalMethod);
        NSLog(@"swizzledMethod: %p",swizzledMethod);
        return true;
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
        NSLog(@"originalMethod: %p",originalMethod);
        NSLog(@"swizzledMethod: %p",swizzledMethod);
        return true;
    }
    return false;
}

- (BOOL) redirectMethod:(Class)_clazz andMethodSEL:(SEL)_methodSEL replaceWithClass:(Class)_otherClass andOtherMethodSEL:(SEL)_otherMethodSEL{
    Method originalMethod = class_getInstanceMethod(_clazz, _methodSEL);
    Method swizzledMethod = class_getInstanceMethod(_otherClass, _otherMethodSEL);
    BOOL didAddMethod =
    class_addMethod(_clazz,
                    _methodSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
        return true;
    else {
        @throw [[NSException alloc] initWithName:@"NSDictionary redirectMethod." reason:@"创建方法时出错，是否已经存在同名方法了？" userInfo:nil];
    }
    return false;
}

@end

/**
 ================ NSMutableDictionary (CCParams) =============
 */

@implementation CCParams : NSMutableDictionary

bool orderedAble;
bool md5Signed;
NSMutableArray *paramsKey;
NSMutableDictionary *_super;

- (void) test{
    NSLog(@"Here's CCParams : NSMutableDictionary.");
}

- (void)addParam:(NSDictionary*)value {
    NSInteger count = [value count];
    NSArray *keyList;
    if ([value isKindOfClass:[CCParams class]])
        keyList = [(CCParams*)value getKeyList];
    else
        keyList = [value allKeys];

    for (int i =0; i<count; i++) {
        NSString *key = [keyList objectAtIndex:i];
        id para = [value objectForKey:key];
        [self addParam:para forKey:key];
    }
}

- (void)addParam:(id)value forKey:(NSString *)key{
    @try {
        [self setValue:value forKey:key];
        
        NSMutableArray *__keyList = (NSMutableArray *)[self getKeyList];
        [__keyList addObject:key];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
}

/**
 *  用块方法对keyList排序。
 *
 *  @param sortBlock 用于排序的块，参数为NSArray*。
 */
- (void)sortByBlock:(void (^)(NSArray*))sortBlock{
    if (!paramsKey)
        paramsKey = [[NSMutableArray alloc]initWithArray:[self allKeys]];
    sortBlock(paramsKey);
}

/**
 *  增加一个keyList。
 *  从NSDictionary转过来的实例，是没有keyList的，默认生成的，也是无序的。
 *  这个方法是人工给出一个keyList。
 *
 *  @param keyList <#keyList description#>
 */
- (void)addKeyList:(NSArray*)keyList{
    int (^containsObjectByValue)(NSArray* ,id) = ^(NSArray* array,id object)
    {
        if (array) {
            NSInteger count  = [array count];
            for (int i=0; i<count; i++) {
                id key = [array objectAtIndex:i];
                if([key isEqual:object])
                    return true;
            }
        }
        return false;
    };
    NSArray *allkeys = [self allKeys];
    NSInteger count = [keyList count];
    for (int i=0; i<count; i++) {
        id key = [keyList objectAtIndex:i];
        if ([allkeys containsObject:key] || containsObjectByValue(allkeys,key)) {
            [paramsKey addObject:key];
        } else {
            // 如果不包含key，就是给key错了。
            @throw [[NSException alloc] initWithName:@"CCParams-NSDictionary addKeyList." reason:@"给出的参数里含有不合法的key，在Dictionary里没有这个key." userInfo:nil];
        }
    }
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (NSArray*)getKeyList{
    if (!paramsKey) {
        void (^sortBlock)(NSArray*) = ^(NSArray* array) {};
        paramsKey = [[NSMutableArray alloc]init];
        // 使用一个空块做参数，调用sortByBlock，只是为了取出allKeys。
        [self sortByBlock:sortBlock];
    }
    return paramsKey;
}


- (NSString*)getParamString{
    NSString *ret = @"";
    NSUInteger count = [[self getKeyList] count];
    for (int i=0; i<count; i++) {
        NSString *key = (NSString*)[[self getKeyList] objectAtIndex:i];
        id param = [self valueForKey:key];
        //        if ([param isKindOfClass:[CCParams class]]) { // 如果参数是一个参数
        //            CCParams *_param = (CCParams *)param;
        //            ret = [ret stringByAppendingString:[_param getParamString]];
        //        } else {
        //            NSObject *_param = (NSObject *)param;
        NSString *_str_param = [self getStringFromID:param withType:CCCommonParamType];
        ret = [ret stringByAppendingString:_str_param];
        //        }
    }
    return ret;
}

- (NSString*)jsonDescription {
    // 如查没有paramKey，就按普通NSDictionary来处理。
    if (![self getKeyList]) {
        return @"";
    }
    NSString *ret = @"{";
    NSUInteger count = [[self getKeyList] count];
    for (int i=0; i<count; i++) {
        ret = [ret stringByAppendingString:@"\""];
        NSString *key = (NSString*)[[self getKeyList] objectAtIndex:i];
        ret = [ret stringByAppendingString:key];
        ret = [ret stringByAppendingString:@"\": "];
        id param = [self valueForKey:key];
        
        if ([param isKindOfClass:[CCParams class]])
        { // 如果参数是一个参数
//            self = [[NSMutableDictionary alloc] init];
            CCParams *param = (CCParams *)param;
            ret = [ret stringByAppendingString:[param jsonDescription]];
            if(i<count-1)
                ret = [ret stringByAppendingString:@", "];
        } else if([param isKindOfClass:[NSArray class]]){
            ret = [ret stringByAppendingString:@"["];
            
            // 判断数组类型。
            NSArray *_param = (NSArray *)param;
            NSInteger cparam = [_param count];
            for (int i_param = 0; i_param < cparam; i_param++) {
                NSObject *obj = [_param objectAtIndex:i_param];
                if (([obj isKindOfClass:[CCParams class]])) {//|| ([obj isKindOfClass:[NSArray class]])) { // 如果参数是一个参数
                    CCParams *_paramobj = (CCParams *)obj;
                    ret = [ret stringByAppendingString:[_paramobj jsonDescription]];
                } else {
                    NSString *_str_param = [self getStringFromID:param withType:CCJsonParamType];
                    ret = [ret stringByAppendingString:_str_param];
                }
                if(i_param<cparam-1)
                    ret = [ret stringByAppendingString:@", "];
            }
            ret = [ret stringByAppendingString:@"]"];
            
        } else {
            //            NSObject *_param = (NSObject *)param;
            NSString *_str_param = [self getStringFromID:param withType:CCJsonParamType];
            ret = [ret stringByAppendingString:_str_param];
            if(i<count-1)
                ret = [ret stringByAppendingString:@", "];
        }
    }
    ret = [ret stringByAppendingString:@"}"];
    return ret;
}

- (NSDictionary*)dictionaryDescription{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc]init];
    NSUInteger count = [[self getKeyList] count];
    for (int i=0; i<count; i++) {
        NSString *key = (NSString*)[[self getKeyList] objectAtIndex:i];
        id param = [self valueForKey:key];
        
        if ([param isKindOfClass:[CCParams class]]) { // 如果参数是一个参数
            CCParams *_param = (CCParams *)param;
            CCParams *dictParam = [_param dictionaryDescription];
            [ret setObject:dictParam forKey:key];
        } else {
            [ret setObject:param forKey:key];
        }
    }
    
    return ret;
}

/**
 *  把任意ID类型，按照规则，转换为字符串。
 *
 *  @param _id <#_id description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)getStringFromID:(id)_id withType:(CCParamStringType)_type {
    NSString *ret = @"";
    
    // 如果是对象，可以用description方法。
    if ([_id isKindOfClass:[NSObject class]] ) {
        // 不需要加“的类型
        if ([_id isKindOfClass:[NSNumber class]] // 数字类型
            ) {
            ret = [_id description];
        } // 如果是json格式，其它都需要加”
        else {
            ret = [_id description];
            switch (_type) {
                case CCJsonParamType:
                    ret = [@"\"" stringByAppendingString:ret];
                    ret = [ret stringByAppendingString:@"\""];
                    //                    self
                    break;
            }
        }
    } else {
        // 否则就是基本数据类型
        ret = [_id description];
        //        if([_id isKindOfClass:[NSInteger class]]) return [NSString stringWithFormat:@"%ld", (long)_id];
    }
    return ret;
}

- (BOOL)isEncode {
    return false;
}

- (NSData*)toJSONSerializationData{
    NSString *query = [self jsonDescription];
    NSData *nsd = [query dataUsingEncoding:NSUTF8StringEncoding];
    return nsd;
}


- (void)rebuildDd5Sign{

//    NSDictionary *params = @{
//                             kAppKey    :   APP_KEY,
//                             kSign      :   md5Sign,
//                             kTime      :   timeStr,
//                             kUserPhone :   phone,
//                             kUsage     :   use
//                             };
//    NSDictionary *jsonObj = @{
//                              kJsonRPC  :   JSON_RPC,
//                              kMethod   :   POST_SENDCAPTCHA,
//                              kParams   :   params,
//                              kUserID   :   userID
//                              };

    // 时间
    NSDate* dat = [NSDate date];//[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000000;
    NSString *timeString = [NSString stringWithFormat:@"%llf", a];
    NSRange range = [timeString rangeOfString:@"."];
    int location = range.location;
    timeString = [timeString substringToIndex:location];
    NSString *timeStr = [NSString stringWithFormat:@"%@", timeString];

    // 取params
    NSMutableDictionary *_params,*_params1;
    NSDictionary *params;
    NSString *md5Sign;
    // 有没有kParams？
    params = [self objectForKey:kParams];
    // 如果有，目标设置为kParams
    if (params) { // 是最终的jsonObj
        _params = [[CCParams alloc]initWithDictionary:params];
        _params1 = [[CCParams alloc]initWithDictionary:params];
        md5Sign = [params objectForKey:kSign];
        // 如果有kSign
        if (md5Sign){
            [_params removeObjectForKey:kAppKey];
            [_params removeObjectForKey:kSign];
            [_params removeObjectForKey:kTime];
            md5Sign = [self getSignString:_params withTimeString:timeStr];
        } else {
            md5Sign = [self getSignString:_params1 withTimeString:timeStr];
        }
        [_params1 removeObjectForKey:kSign];
        [_params1 setObject:md5Sign forKey:kSign];
        [self removeObjectForKey:kParams];
        [self setValue:_params1 forKey:kParams];
    } else { // 如果没有
        md5Sign = [params objectForKey:kSign];
        // 如果有kSign
        if (md5Sign){ // 自己是kParams
            _params1 = [self copy];
            
            [_params1 removeObjectForKey:kAppKey];
            [_params1 removeObjectForKey:kSign];
            [_params1 removeObjectForKey:kTime];
            md5Sign = [self getSignString:_params withTimeString:timeStr];
            
            [self removeObjectForKey:kSign];
            [self setValue:md5Sign forKey:kSign];
        } else {
            md5Sign = [self getSignString:self withTimeString:timeStr];
            [self setValue:APP_KEY forKey:kAppKey];
            [self setValue:md5Sign forKey:kSign];
            [self setValue:timeStr forKey:kTime];
        }
    }
    md5Signed = true;
}

- (NSString *)getSignString:(CCParams*)param withTimeString:(NSString*)timeString {
    NSString *timeStr = [NSString stringWithFormat:@"%@", timeString];
    
    NSString *paramString1 = [param getParamString];
    NSString *paramString = [paramString1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 生成签名
    NSMutableString *sign = [NSMutableString string];
    [sign appendString:APP_KEY];
    [sign appendString:timeStr];
    [sign appendString:paramString];
    [sign appendString:MD5_SUF];
    NSString *md5Sign = [CCMD5 md5WithString:sign];

    return md5Sign;
}

//================================ 重载方法 ==========================

- (void)_setValue:(id)value forKey:(NSString *)key {
    NSLog(@"Here's CCParams's setValue. ");
    [_super setValue:value forKey:key];
    [paramsKey addObject:key];
}

-(void)setValue:(id)value forKey:(NSString *)key {
    [self _setValue:value forKey:key];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    [_super setObject:anObject forKey:aKey];
    [paramsKey addObject:aKey];
}

- (id)valueForKey:(NSString *)key {
    return [_super valueForKey:key];
}

- (id)init
{
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self != nil)
    {
        _super = [[NSMutableDictionary alloc]initWithCapacity:capacity];
        paramsKey = [[NSMutableArray alloc] initWithCapacity:capacity];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    self = [super init];
    if (self) {
        _super = [[NSMutableDictionary alloc]initWithDictionary:otherDictionary];
        paramsKey = [[NSMutableArray alloc]initWithArray:[_super allKeys]];
    }
    return self;
}


- (id)copy
{
    return [self mutableCopy];
}

- (void)removeObjectForKey:(id)aKey
{
    [_super removeObjectForKey:aKey];
    [paramsKey removeObject:aKey];
}

- (NSUInteger)count
{
    return [_super count];
}

- (id)objectForKey:(id)aKey
{
    return [_super objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
    CCSortAbleEnumerator *ret = [[CCSortAbleEnumerator alloc]initWithArray:[self getKeyList]];
    return ret;
}

- (NSEnumerator *)reverseKeyEnumerator
{
    return [[self getKeyList] reverseObjectEnumerator];
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex
{
    if ([_super objectForKey:aKey])
    {
        [self removeObjectForKey:aKey];
    }
    [paramsKey insertObject:aKey atIndex:anIndex];
    [self setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex
{
    return [[self getKeyList] objectAtIndex:anIndex];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *indentString = [NSMutableString string];
    NSUInteger i, count = level;
    for (i = 0; i < count; i++)
    {
        [indentString appendFormat:@"    "];
    }
    
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@{\n", indentString];
//    for (NSObject *key in self)
//    {
//        [description appendFormat:@"%@    %@ = %@;\n",
//         indentString,
//         DescriptionForObject(key, locale, level),
//         DescriptionForObject([self objectForKey:key], locale, level)];
//    }
    [description appendFormat:@"%@}\n", indentString];
    return description;
}

// 不常用的初始化方法，没实现完，先空着。这样调用下面的方法会报错，到时再实现。
- (instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys{
    
    return nil;
}

- (instancetype)initWithObjectsAndKeys:(id)firstObject, ... {
    NSMutableArray* sortableItems = [[NSMutableArray alloc] init];
    id values = firstObject;
    if( values == nil )
        return sortableItems;
    
    va_list args;
    va_start(args, values);
    
    NSString* str = values;
    do
    {
        [sortableItems addObject:str];
        NSLog(@"%@",str);
    }
    while( (str = va_arg(args,NSString*)) );
    
    va_end(args);
    
    NSLog([firstObject description]);
    NSLog([[firstObject class]description]);
    NSLog(@"%@",firstObject );
    
    //    return super ;
    return [sortableItems sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag {
    return nil;
}

- (instancetype)initWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    return nil;
}


- (NSArray*)allKeys {
    NSLog(@"CCParams's allKeys.");
    return [self getKeyList];
}

/**=============== 临时实现，非优化方案，下面这段别删。 ====================
 下面代码是采用对NSMutableDictionary进行扩展，由于setValue:forKey是NSObject
 及一个不知道的类实现过，导致该方法的引用还未能准确定位到NSMutableDictionary的
 实现上，现象是Value值出错。现在先采用继承NSMutableDictionary的方法。
 //====================================================================*/
//void _setValueForKey(id value,NSString *key) {
//    //    [self setValue:value forKey:key];
//    NSLog(@"asdf");
//    [_self setValue:value forKey:key];
//    [paramsKey addObject:key];
//}
//void (*gOrigSetObject)(id,NSString*);
//-(id)initWithDictionary:(NSDictionary*)otherDictionary {
//    self = [super initWithDictionary:otherDictionary];
//    if (self) {
//        orderedAble = true;
//        if(!paramsKey) {
//            paramsKey = [[NSMutableArray alloc]init];
//        }
//
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            //        // 因为setValue:forKey是NSObject的方法，并且，还不是NSDictionary实现的重载（估计是他的子类实现的），所以下面这段执行时，会导致取到函数_setValueForKey的地址后，却无法访问。
//            //        Method origMethod = class_getInstanceMethod([self class],@selector(setObject:forKey:));
//            //        gOrigSetObject = (void*)method_getImplementation(origMethod);
//            //
//            //        gOrigSetObject = (void *)class_replaceMethod([self class],@selector(setValue:forKey:), (IMP)(_setValueForKey),method_getTypeEncoding(origMethod));
//
//            Class class = [self class];
//            SEL originalSelector = @selector(setObject:forKey:);
//            SEL swizzledSelector = @selector(_setValue:forKey:);
//            Method originalMethod = class_getInstanceMethod(class, originalSelector);
//            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//            NSLog(@"originalMethod: %p",originalMethod);
//            NSLog(@"swizzledMethod: %p",swizzledMethod);
//
//            BOOL didAddMethod =
//            class_addMethod(class,
//                            originalSelector,
//                            method_getImplementation(swizzledMethod),
//                            method_getTypeEncoding(swizzledMethod));
//
//            if (didAddMethod) {
//                class_replaceMethod(class,
//                                    swizzledSelector,
//                                    method_getImplementation(originalMethod),
//                                    method_getTypeEncoding(originalMethod));
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod);
//            }
//
//            NSLog(@"originalMethod: %p",originalMethod);
//            NSLog(@"swizzledMethod: %p",swizzledMethod);
//            NSLog(@"");
//        });
//    }
//    return self;
//}
//
//
//- (void)_setValue:(id)value forKey:(NSString *)key {
//
//    NSLog(@"_setValue");
//    //    NSLog(@"%p",_setValue:forKey:);
////    NSDictionary* at = self;
//    [self _setValue:value forKey:key];
//
////    NSString* _id = [self objectForKey:key];
////    NSLog(@"%@",_id);
//    [paramsKey addObject:key];
//    return;
//}
//====================================================================

@end

//@interface CCSortAbleEnumerator : NSEnumerator
//
//@end

@implementation CCSortAbleEnumerator : NSEnumerator
NSArray *objs;
NSInteger _index;

- (instancetype)initWithArray:(NSArray*)array {
        self = [super init];
        if(self){
            objs = array;
            _index = 0;
        }
    return self;
}

- (id)nextObject {
    // TODO: 需要判读结尾。
    id ret = [objs objectAtIndex:_index];
    _index++;
    return ret;
}


@end
