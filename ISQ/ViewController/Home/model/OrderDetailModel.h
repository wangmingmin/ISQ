//
//  OrderDetailModel.h
//  ISQ
//
//  Created by mac on 15-11-1.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

/*
 
 "newsid": "2702",
 "newstitle": "我是小小志愿者 我为苑区做奉献",
 "newstitlepic": "",
 "newssmalltext": "2015年7月21日是四居委会一年一度的夏令营开营第二天，当天的活动主题是“我是小小志愿者，我为苑区做奉献”。",
 "newsaddtime": "2015-07-23 10:55"
 */

@property (nonatomic,copy) NSString *newsid;
@property (nonatomic,copy) NSString *newstitle;
@property (nonatomic,copy) NSString *newssmalltext;
@property (nonatomic,copy) NSString *newsaddtime;
@property (nonatomic,copy) NSString *newstitlepic;

@end
