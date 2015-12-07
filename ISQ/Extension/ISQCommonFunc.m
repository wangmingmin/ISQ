//
//  ISQCommonFunc.m
//  ISQ
//
//  Created by mac on 15-10-29.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ISQCommonFunc.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation ISQCommonFunc

static Byte iv[] = {1,2,3,4,5,6,7,8};

 - (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key{
    
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    
        if (cryptStatus == kCCSuccess){
        
            NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
            ciphertext = [data base64Encoding];
        }
    
        return ciphertext;
}


@end
