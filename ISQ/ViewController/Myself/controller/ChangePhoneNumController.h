//
//  ChangePhoneNumController.h
//  ISQ
//
//  Created by mac on 15-4-24.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhoneNumController : UIViewController

- (IBAction)changePhoneBack_bt:(id)sender;
- (IBAction)changePhoneNext_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changePhoneNext_ol;
@property (weak, nonatomic) IBOutlet UILabel *changePhoneNext_lable;
@property (weak, nonatomic) IBOutlet UIView *changePhonenextView1;
@property (weak, nonatomic) IBOutlet UIView *changePhonenextView2;
- (IBAction)Confirm_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Confirm_ol;
- (IBAction)sendMessageCode_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageCode_ol;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end
