//
//  AccountDetailController.h
//  ISQ
//
//  Created by mac on 15-4-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountDetailController : UIViewController

@property(strong,nonatomic) NSArray *fromAccountData;
- (IBAction)accountNext_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *accountNext_ol;

- (IBAction)accountBack_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UITextField *email_tv;
@property (weak, nonatomic) IBOutlet UILabel *emailLable;
@property (weak, nonatomic) IBOutlet UIButton *resendEmail_ol;
- (IBAction)resendEmail_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *emailTvView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIView *changeView3;
@property (weak, nonatomic) IBOutlet UIView *changeView5;
@property (weak, nonatomic) IBOutlet UITextField *changePass1;
@property (weak, nonatomic) IBOutlet UITextField *changePass2;
@property (weak, nonatomic) IBOutlet UILabel *changIsqCode;



@end
