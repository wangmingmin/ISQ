//
//  MyFriendsModle.h
//  ISQ
//
//  Created by mac on 15-7-28.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFriendsModle : NSObject
/**
 昵称
 */
@property(copy,nonatomic) NSString *nick;
/**
 环信id
 */
@property(copy,nonatomic) NSString *hxid;
/**
 头像
 */
@property(copy,nonatomic) NSString *avatar;

/**
 备注
 */
@property(copy,nonatomic) NSString *remark;


@end
