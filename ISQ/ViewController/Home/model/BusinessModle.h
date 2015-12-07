//
//  BusinessModle.h
//  ISQ
//
//  Created by mac on 15-7-24.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessModle : NSObject

/**
 图片
 */
@property (copy,nonatomic) NSString *companyImage;
/**
 名称
 */
@property (copy,nonatomic) NSString *companyName;
/**
 地址
 */
@property (copy,nonatomic) NSString *companyAddress;
/**
 拨打次数
 */
@property (copy,nonatomic) NSString *companyCallNums;
/**
 上门
 */
@property (copy,nonatomic) NSString *companyIsOnCall;
/**
 审核
 */
@property (copy,nonatomic) NSString *companyChecked;
/**
 星级
 */
@property (copy,nonatomic) NSString *companyLevel;
/**
 商铺id
 */
@property (copy,nonatomic) NSString *companyId;
/**
 商铺电话
 */
@property (copy,nonatomic) NSString *companyFixedphone;

@end
