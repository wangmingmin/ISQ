//
//  BDMLocationController.h
//  ISQ
//
//  Created by mac on 15-6-19.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface BDMLocationController : NSObject<BMKLocationServiceDelegate,CLLocationManagerDelegate>

-(void)baiduMapLocationL;
-(void)startLocation;
@end
