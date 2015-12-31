//
//  HMAC-SHA1.m
//  HMAC-SHA1
//
//  Created by Mac_SSD on 10/30/15.
//  Copyright © 2015 Mac_SSD. All rights reserved.
//

#import "HMAC-SHA1.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation HMAC_SHA1


+(NSString *)hmac_sha1:(NSString *)key parames:(NSArray *)parames url:(NSString *)url{
    
    
    /**
     *  拼接要加密的字符串
     */
    NSString *theEndStr=@"";
    
    for ( NSString * str in [parames sortedArrayUsingSelector:@selector(compare:)]) {
        
        theEndStr=[NSString stringWithFormat:@"%@&%@",theEndStr,str];
        
    }
    
    
    theEndStr=[NSString stringWithFormat:@"%@?%@",url,[theEndStr substringFromIndex:1]];
    //进行URL转码
    theEndStr=[self encodeToPercentEscapeString:theEndStr];
    //再拼接字符串
    theEndStr=[NSString stringWithFormat:@"GET&%@",theEndStr];
 
    
    
    
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [theEndStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [HMAC base64Encoding];//base64Encoding函数在NSData+Base64中定义
    
    
    return [self encodeToPercentEscapeString:hash];
    
    
    
}

//进行URL转码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{

    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+(NSString *)randomNonce{
    
  
    int n =arc4random()%10;
   
    NSString *str=@"";
    for (int i=n; i<15; i++) {

        int r=arc4random()%3;
        
        if (r==0) {
            //小写
            str=[NSString stringWithFormat:@"%@%c",str,(char)('a'+arc4random()%26)];
            
        }else if(r==1){
            //大写
            str=[NSString stringWithFormat:@"%@%c",str,(char)('A'+arc4random()%26)];
            
        }else if(r==2){
            //数字
            str=[NSString stringWithFormat:@"%@%u",str,arc4random()%10];
        }else {
            
            //数字
            str=[NSString stringWithFormat:@"%@%u",str,arc4random()%10];
        } 
        
    }
    
    
    return str;
}

//当前时间的时间戳
+(NSString*)getTime{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    
   return [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
}


@end
