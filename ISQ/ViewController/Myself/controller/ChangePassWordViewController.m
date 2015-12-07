//
//  ForgotPassWordViewController.m
//  ISQ
//
//  Created by mac on 15-10-18.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "ApplyViewController.h"

@interface ChangePassWordViewController (){

    UIView *clickView;
    NSUserDefaults *userInfo;
    MBProgressHUD *HUD;
    EGOCache *theCache;
}

@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [NSUserDefaults standardUserDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 44, 44);
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    saveButton.highlighted = YES;
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = item;
    [self initView];
}

- (void)initView{
    
    self.pw.delegate = self;
    self.pwagain.delegate = self;
    self.pw.tag = 800;
    self.pwagain.tag = 801;
    self.pw.secureTextEntry = YES;
    self.pwagain.secureTextEntry = YES;
    self.pw.clearButtonMode = UITextFieldViewModeAlways;
    self.pwagain.clearButtonMode = UITextFieldViewModeAlways;
    clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    clickView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [clickView addGestureRecognizer:tapGesture];
    [self.view addSubview:clickView];
    clickView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)warning2:(NSString *)warString2{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode=MBProgressHUDModeText;
    HUD.labelText =[NSString stringWithFormat:@"%@",warString2];
    HUD.margin = 8.f;
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:1.5];
}


#pragma mark - clicks

- (void)saveAction:(UIButton *)sender{

    
    if (self.pw.text.length >9 || self.pw.text.length < 5) {
        
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"请输入6~10位数字的密码！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView1 show];
        
    }else if (![self.pw.text isEqualToString:self.pwagain.text]){
        
        UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"两次输入密码不一致！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView2 show];
        
    }else{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确定修改密码？" message:@"修改后您将需要重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
        
    }
    
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        
        if (self.pw.text.length <=9 && self.pw.text.length >=5 && [self.pwagain.text isEqualToString:self.pw.text]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic[@"npwd1"] = self.pw.text;
            dic[@"npwd2"] = self.pwagain.text;
            dic[@"phone"] = [userInfo objectForKey:userAccount];
            
            [ISQHttpTool post:changePassWord contentType:nil params:dic success:^(id responseObj) {
                
                [self showHudInView:self.view hint:NSLocalizedString(@"密码修改成功，重新登录", @"登录...")];
                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                    [self hideHud];
                    if (error && error.errorCode != EMErrorServerNotLogin) {
                        [self showHint:error.description];
                    }else{
                        //清除用户信息，表示退出登录
                        [userInfo removeObjectForKey:userPassword];
                        [userInfo removeObjectForKey:MyUserID];
                        if([theCache plistForKey:IMCACHEDATA]){
                            [theCache removeCacheForKey:IMCACHEDATA];
                        }
                        //清除UIWebView的缓存
                        [[NSURLCache sharedURLCache] removeAllCachedResponses];
                        //清除cookies
                        NSHTTPCookie *cookie;
                        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                        for (cookie in [storage cookies])
                        {
                            [storage deleteCookie:cookie];
                        }
                        [[ApplyViewController shareController] clear];
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                        UIStoryboard *registerStory=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
                        LoginViewController *loginVC=[registerStory instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
                        [loginVC setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:loginVC animated:NO];
                    }
                } onQueue:nil];
                
                
            } failure:^(NSError *error) {
                
                [self hideHud];
                [self warning2:@"提交失败，请检查您当前网络!"];
            }];
            
        }

    }
}

- (void)resignKeyboard:(UIGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
}


#pragma mark - 键盘通知

- (void)showKeyboard:(NSNotification *)notification{
    
    clickView.hidden = NO;
}


- (void)hideKeyboard:(NSNotification *)notificaiton{
    
    clickView.hidden = YES;
}


@end
