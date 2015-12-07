//
//  RegisterController.h
//  ISQ
//
//  Created by mac on 15-4-22.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber_tv;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumber_bt_ol;
- (IBAction)agreement_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreement_bt_ol;
- (IBAction)use_agreement_bt:(id)sender;
- (IBAction)phoneNumber_next_bt:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *message_lable;
@property (weak, nonatomic) IBOutlet UITextField *message_code_tv;
@property (weak, nonatomic) IBOutlet UIButton *again_send_code_ol;
- (IBAction)again_send_code_bt:(id)sender;
- (IBAction)message_next_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *message_next_ol;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;

@property (weak, nonatomic) IBOutlet UITextField *nikname_tv;
@property (weak, nonatomic) IBOutlet UITextField *passWord_tv;
- (IBAction)registerOK_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerOK_ol;
@property (weak, nonatomic) IBOutlet UILabel *theTimeLable;

- (IBAction)registerBack_bt:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *phoneView1;
@property (weak, nonatomic) IBOutlet UIView *messageView1;
@property (weak, nonatomic) IBOutlet UIView *passview1;
@property (weak, nonatomic) IBOutlet UIView *passview2;
@property (weak, nonatomic) IBOutlet UIView *messageview2;




@end
