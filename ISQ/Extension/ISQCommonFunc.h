//
//  ISQCommonFunc.h
//  ISQ
//
//  Created by mac on 15-10-29.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISQCommonFunc : NSObject

//使用DES加密
- (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;


@end
