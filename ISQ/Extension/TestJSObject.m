//
//  TestJSObject.m
//  TestJSOC
//
//  Created by Mac_SSD on 15/11/17.
//  Copyright © 2015年 Mac_SSD. All rights reserved.
//

#import "TestJSObject.h"
#import "MainViewController.h"
#import "HMAC-SHA1.h"

@implementation TestJSObject

-(void)passShareParams:(NSString*)str {
    
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic=[[NSDictionary alloc] init];
    dic =[NSJSONSerialization JSONObjectWithData:data options:NSJapaneseEUCStringEncoding error:nil];
   
    if (dic[@"url"]) {
        
        [MainViewController  theShareSDK:dic];
    }
}

- (void)passBillParams:(NSString *)str{
    
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic=[[NSDictionary alloc] init];
    dic =[NSJSONSerialization JSONObjectWithData:data options:NSJapaneseEUCStringEncoding error:nil];
    if (dic[@"name"]&&dic[@"action"]) {
        
        //获取随机字符
        NSString *nonce = [NSString stringWithFormat:@"nonce=%@",[HMAC_SHA1 randomNonce]];
        //获取时间戳
        NSString *timestamp = [NSString stringWithFormat:@"timestamp=%@",[HMAC_SHA1 getTime]];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:timestamp];
        [array addObject:nonce];
        [array addObject:[NSString stringWithFormat:@"name=%@",dic[@"name"]]];
        [array addObject:[NSString stringWithFormat:@"action=%@",dic[@"action"]]];
        //加密
        NSString *signature = [HMAC_SHA1 hmac_sha1:@"Q2sE#FeNK8%6awIO" parames:array url:@"http://webapp.wisq.cn/api"];
        NSString *url = [NSString stringWithFormat:@"%@?%@&%@&name=%@&action=%@&signature=%@&year=%@&id=%@",@"http://webapp.wisq.cn/api",timestamp,nonce,dic[@"name"],dic[@"action"],signature,@"1",@"2"];
        [ISQHttpTool getHttp:url contentType:nil params:nil success:^(id responseObject) {
            
            NSDictionary *dic = [[NSDictionary alloc] init];
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
            NSLog(@"dic--%@",dic);
            
        } failure:^(NSError *erro) {
            
            NSLog(@"error--%@",erro);
        }];
    }
    
}


@end
