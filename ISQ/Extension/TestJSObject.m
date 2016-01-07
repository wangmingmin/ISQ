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

@implementation TestJSObject{

    NSDictionary *dic2;
}

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
    dic2 = [[NSDictionary alloc] init];
    dic =[NSJSONSerialization JSONObjectWithData:data options:NSJapaneseEUCStringEncoding error:nil];
    if (dic[@"name"]&&dic[@"action"]) {
        
        //获取随机字符
        NSString *nonce = [NSString stringWithFormat:@"nonce=%@",[HMAC_SHA1 randomNonce]];
        //获取时间戳
        NSString *timestamp = [NSString stringWithFormat:@"timestamp=%@",[HMAC_SHA1 getTime]];
        NSMutableArray *array = [NSMutableArray array];
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSString *uid = [userInfo objectForKey:MyUserID];
        
         /****************************接口1******************************/
        
        [array addObject:timestamp];
        [array addObject:nonce];
        [array addObject:[NSString stringWithFormat:@"name=%@",dic[@"name"]]];
        [array addObject:[NSString stringWithFormat:@"action=%@",dic[@"action"]]];
        //加密
        NSString *signature = [HMAC_SHA1 hmac_sha1:@"Q2sE#FeNK8%6awIO" parames:array url:@"http://webapp.wisq.cn/api"];
        NSString *url = [NSString stringWithFormat:@"%@?%@&%@&name=%@&action=%@&signature=%@&year=%@&id=%@&uid=%@",@"http://webapp.wisq.cn/api",timestamp,nonce,dic[@"name"],dic[@"action"],signature,@"1",@"2",uid];
        [ISQHttpTool getHttp:url contentType:nil params:nil success:^(id responseObject) {
            
            NSDictionary *dic = [[NSDictionary alloc] init];
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
            dic2 = dic;
            self.passBill(dic);
            
        } failure:^(NSError *erro) {
            
            NSLog(@"error--%@",erro);
            self.passBill(nil);

        }];
        

        
    }
    
}

-(void)passPayResFiveTimes
{
    //获取随机字符
    NSString *nonce = [NSString stringWithFormat:@"nonce=%@",[HMAC_SHA1 randomNonce]];
    //获取时间戳
    NSString *timestamp = [NSString stringWithFormat:@"timestamp=%@",[HMAC_SHA1 getTime]];

    /****************************接口2******************************/
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:timestamp];
    [array2 addObject:nonce];
    [array2 addObject:[NSString stringWithFormat:@"name=%@",@"property"]];
    [array2 addObject:[NSString stringWithFormat:@"action=%@",@"pay_confirm"]];
    //加密
    NSString *signature2 = [HMAC_SHA1 hmac_sha1:@"Q2sE#FeNK8%6awIO" parames:array2 url:@"http://webapp.wisq.cn/api"];
    NSString *url2 = [NSString stringWithFormat:@"%@?%@&%@&name=%@&action=%@&signature=%@&order_no=%@",@"http://webapp.wisq.cn/api",timestamp,nonce,@"property",@"pay_confirm",signature2,dic2[@"order_no"]];
    [ISQHttpTool getHttp:url2 contentType:nil params:nil success:^(id responseObject) {
        
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
        NSLog(@"dicc ----%@",dic);
        self.passPayRes(dic);
    } failure:^(NSError *erro) {
        
        NSLog(@"error--%@",erro);
        self.passPayRes(nil);
    }];

}
@end
