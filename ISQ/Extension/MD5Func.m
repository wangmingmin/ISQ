//
//  MD5Func.m
//  ISQ
//
//  Created by mac on 16-3-7.
//  Copyright (c) 2016年 cn.ai-shequ. All rights reserved.
//

#import "MD5Func.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Func

+(NSString *) md5: (NSString *) inPutText
{
    const char *original_str = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


@end
