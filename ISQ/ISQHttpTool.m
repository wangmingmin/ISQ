//
//  ISQHttpTool.m
//  ISQ
//
//  Created by Mac_SSD on 15/10/18.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "ISQHttpTool.h"
#import "AFNetworking.h"
@implementation ISQHttpTool

/**
 *  发送get请求
 *
 *  @param url     请求地址
 *  @param parames 参数
 *  @param success 成功
 *  @param failure 失败
 */
+(void)getHttp:(NSString *)url contentType:(NSString*)contentType params:(NSDictionary *)parames success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (contentType==nil) {
        
        
    }else {
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:contentType];
    }
   
    [manager GET:url parameters:parames success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
        
        
    }];
    
}

/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param parames 参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)post:(NSString *)url contentType:(NSString*)contentType params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *))failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (contentType==nil) {
        
        
    }else {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:contentType];
    }
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
        
        
    }];
}


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
+(void)upload:(NSString* )url fielName:(NSString *)fielName params:(NSDictionary *)params data:(NSData*)data succsee:(void (^)(id responseObject))succes failure:(void (^) (NSError *error))failure{
    
//     1.获得请求管理者
//
//    
//        // 2.封装请求参数
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"access_token"] = [HMAccountTool account].access_token;
//        params[@"status"] = self.textView.text;
    
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        [manager POST:@"url" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    
//    #warning 目前新浪开放的发微博接口 最多 只能上传一张图片
//            UIImage *image = [self.photosView.images firstObject];
//    
//            NSData *data = UIImageJPEGRepresentation(image, 1.0);
//    
//            // 拼接文件参数
//            [formData appendPartWithFileData:data name:@"pic" fileName:@"status.jpg" mimeType:@"image/jpeg"];
//    
//        } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
//            [MBProgressHUD showSuccess:@"发表成功"];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [MBProgressHUD showError:@"发表失败"];
//        }];
//    
    
}

@end
