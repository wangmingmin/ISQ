//
//  UserAgreementController.h
//  ISQ
//
//  Created by mac on 15-5-11.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAgreementController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *agreementWebview;
- (IBAction)back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (strong,nonatomic) NSArray *useAgreeData;
-(instancetype)initWithAgreeData:(NSArray*)agreeData;
@property (weak, nonatomic) IBOutlet UILabel *ageemenTitle_label;
@property (weak, nonatomic) IBOutlet UIButton *back_ol;

@end
