//
//  ForgetPasswordController.m
//  ISQ
//
//  Created by mac on 15-6-9.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
@interface ForgetPasswordController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    
    NSTimer *confirmTiemr;
    NSInteger codeTime;
    MBProgressHUD *HUD;
}

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden=NO;
    self.showDetailLabel.hidden = YES;
    self.confirmButton.enabled = NO;
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)setUpView{
    
    self.phoneNumberTextField.delegate = self;
    self.PassWordTextField.delegate = self;
    self.againNewPasswordTextfield.delegate = self;
    self.phoneNumberTextField.tag = 700;
    self.PassWordTextField.tag = 701;
    self.againNewPasswordTextfield.tag = 702;
    self.phoneNumberTextField.keyboardType = UIReturnKeyDone;
    self.PassWordTextField.keyboardType = UIReturnKeyDone;
    self.againNewPasswordTextfield.keyboardType = UIReturnKeyDone;
    [self.confirmButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.tag == 700) {
        if (textField.text.length == 10) {
            
            self.confirmButton.enabled = YES;
            
        }else if (textField.text.length <10 || textField.text.length >10){
            
            self.confirmButton.enabled = NO;
        }
        
        if (self.confirmButton.enabled == YES) {
            [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

-(void)warning2:(NSString *)warString2{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode=MBProgressHUDModeText;
    HUD.labelText =[NSString stringWithFormat:@"%@",warString2];
    HUD.margin = 8.f;
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:1.5];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    confirmTiemr = nil;

}


#pragma mark - click

- (void)confirmAction:(UIButton *)sender{
    
    self.showDetailLabel.hidden = NO;
    codeTime = 60;
    confirmTiemr = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",getCode,@"?phone=",self.phoneNumberTextField.text];
    [ISQHttpTool getHttp:str contentType:nil params:nil success:^(id responseObject) {
        
    } failure:^(NSError *erro) {
        
    }];
}


- (void)timerAction{
    
    codeTime = codeTime - 1;
    [self.confirmButton setTitle:[NSString stringWithFormat:@"%@%d%@",@"获取验证码(",codeTime,@")"] forState:UIControlStateNormal];
    if (codeTime <= 0) {
        [self.confirmButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        self.showDetailLabel.hidden = YES;
        [confirmTiemr invalidate];
    }
}


- (void)saveAction:(UIButton *)sender{

    if (self.codeTextField.text.length > 0 && self.PassWordTextField.text.length >=5 && self.PassWordTextField.text.length <=9 && [self.againNewPasswordTextfield.text isEqualToString:self.PassWordTextField.text]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        dic[@"vcode"] = self.codeTextField.text;
        dic[@"npwd"] = self.PassWordTextField.text;
        dic[@"phone"] = self.phoneNumberTextField.text;
        
        [ISQHttpTool getHttp:forgetPassWord contentType:nil params:dic success:^(id responseObject) {
    
            [self showHudInView:self.view hint:NSLocalizedString(@"正在跳转登录", @"登录...")];
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
            LoginViewController *loginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
            
            [self.navigationController pushViewController:loginVC animated:YES];
            
        } failure:^(NSError *erro) {
            
            [self hideHud];
            [self warning2:@"提交失败，请检查您当前网络!"];
        }];

    }else{
    
        if (self.PassWordTextField.text.length >9 || self.PassWordTextField.text.length < 5) {
            
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"请输入6~10位数字的密码！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];

            [alertView1 show];
        
        }else if (![self.againNewPasswordTextfield.text isEqualToString:self.PassWordTextField.text]){
            
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"两次输入密码不一致！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView2 show];
            
        }else {
        
            UIAlertView *alertView3 = [[UIAlertView alloc] initWithTitle:@"请检查验证码是否输入正确！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView3 show];
        }
    }
}


@end
