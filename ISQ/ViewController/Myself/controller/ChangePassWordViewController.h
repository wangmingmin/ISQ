//
//  ForgotPassWordViewController.h
//  ISQ
//
//  Created by mac on 15-10-18.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassWordViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pw;
@property (weak, nonatomic) IBOutlet UITextField *pwagain;

@end
