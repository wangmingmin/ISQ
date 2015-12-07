//
//  LoginViewController.h
//  ISQ
//
//  Created by mac on 15-4-22.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *loginPhoneNumber_tv;
@property (weak, nonatomic) IBOutlet UITextField *loginPassWord_tv;
- (IBAction)login_bt:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *loginPassView;

@property (weak, nonatomic) IBOutlet UIView *loginLoginView;
- (IBAction)greenAdmin:(id)sender;


@end
