//
//  AppDelegate.h
//  ISQ
//
//  Created by mac on 15-3-11.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface AppDelegate : UIResponder<UIApplicationDelegate, IChatManagerDelegate,UIAlertViewDelegate>
{
    EMConnectionState _connectionState;
}


@property (strong, nonatomic) UIWindow *window;
@property NSString *theAddress;
@property NSString *theAddress_city;
@property NSString *theDistrict;
@property CGFloat theLa;
@property CGFloat theLo;
@property (strong,nonatomic) NSString *isWIFI;
@property BOOL isBackground;
@property (strong, nonatomic) HomeViewController *homeController;
@property (strong ,nonatomic) NSString *networkStatic;
-(void)warning2:(NSString *)warString;
-(void)ToObtainInfo:(NSString *)str;

@end

