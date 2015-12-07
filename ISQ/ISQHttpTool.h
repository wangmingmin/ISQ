//
//  ISQHttpTool.h
//  ISQ
//
//  Created by Mac_SSD on 15/10/18.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISQHttpTool : NSObject

/**
 *  发送get请求
 *
 *  @param url     请求地址
 *  @param parames 参数
 *  @param success 成功
 *  @param failure 失败
 *  @param contentType contentType
 */
+(void)getHttp:(NSString *)url contentType:(NSString*)contentType params:(NSDictionary*)parames success:(void (^)(id))success failure:(void (^)(NSError *erro))failure;

/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param params 参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)post:(NSString *)url contentType:(NSString*)contentType params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  文件上传
 *
 *  @param url      url
 *  @param fielName 文件名
 *  @param params   参数
 *  @param succes   成功
 *  @param failure  失败
 *  @param data     文件数据
 */
+(void)upload:(NSString* )url fielName:(NSString *)fielName params:(NSDictionary *)params data:(NSData*)data succsee:(void (^)(id responseObject))succes failure:(void (^) (NSError *error))failure;

@end
