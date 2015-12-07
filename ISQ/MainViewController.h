//
//  MainViewController.h
//  ISQ
//
//  Created by mac on 15-3-31.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController :  UITabBarController
{
    EMConnectionState _connectionState;
}
@property NSString *theAddress;

-(void)getImFriendsData;

/**
 *  分享
 *
 *  @param dic 参数
 
 parame[@"img"]    图片
 parame[@"title"]  标题
 parame[@"desc"]   描述
 parame[@"url"]    要分享的URL（不能为空）
 */

+(void)theShareSDK:(NSDictionary  *)dic;


@end
