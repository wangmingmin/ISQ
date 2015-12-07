//
//  HMAC-SHA1.h
//  HMAC-SHA1
//
//  Created by Mac_SSD on 10/30/15.
//  Copyright © 2015 Mac_SSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMAC_SHA1 : NSObject
/**
 *  HMAC_SHA1 加密
 *
 *  @param key     秘钥
 *  @param parames 进行加密的参数
 *
 *  @return 返回加密后的字符
 */
+(NSString *)hmac_sha1:(NSString *)key parames:(NSArray *)parames url:(NSString *)url;
/**
 *  url转码
 *
 *  @param input 要进行转换的字符
 *
 *  @return 返回一个字符串
 */
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;


/**
 *  产生随机的字符串 5-15个字符
 *
 *  @return 返回一个字符串
 */
+(NSString *)randomNonce;

/**
 *  获取当前时间
 *
 *  @return 时间戳
 */
+(NSString *)getTime;
@end
