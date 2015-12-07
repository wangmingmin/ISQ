//
//  CmdDealWith.h
//  ISQ
//
//  Created by mac on 15-7-17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmdDealWith : NSObject

+(void)cmdToDealWith:(NSString *)action:(NSString*)to_id;
+(void)cmdToDealWithGroup:(NSString *)action:(NSDictionary*)dic:(NSString*)groupOwner;

@end
