//
//  AccountDetailController.m
//  ISQ
//
//  Created by mac on 15-4-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "AccountDetailController.h"
#import "CustomIOSAlertView.h"
@interface AccountDetailController ()<CustomIOSAlertViewDelegate>{
    
    
    NSArray *newAccountData;
    UILabel *alerLable1;
    UILabel *alerLable2;
    CustomIOSAlertView *customAler;
    UITextField *alerPass;
    NSDictionary *returnString;
   
    
}

@end

@implementation AccountDetailController
@synthesize accountNext_ol;
@synthesize changeView3,changeView5,changePass1,changePass2,changIsqCode;
@synthesize email_tv,emailLable,emailTvView,emailView,passwordView;

-(void)setFromAccountData:(NSArray *)oldFromAccountData{
    
    if (_fromAccountData!=oldFromAccountData) {
        _fromAccountData=oldFromAccountData;
        newAccountData=[self.fromAccountData copy];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
   
    if ([[newAccountData objectAtIndex:0] isEqualToString:@"邮箱地址"]){
        self.title=@"修改邮箱地址";
        [self.accountNext_ol setTitle:@"保存" forState:UIControlStateNormal];
        self.emailView.hidden=NO;
        self.passwordView.hidden=YES;
        self.emailTvView.layer.borderWidth=0.5f;
        self.emailTvView.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
        
        
    }else if ([[newAccountData objectAtIndex:0] isEqualToString:@"账号密码"]){
        
        self.changeView5.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.4f].CGColor;
        self.changeView5.layer.borderWidth=0.5f;
        self.changeView3.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.4f].CGColor;
        self.changeView3.layer.borderWidth=0.5f;
        
        
        changIsqCode.text=[user_info objectForKey:userIsqCode];
        self.title=@"设置爱社区密码";
        self.passwordView.hidden=NO;
        self.emailView.hidden=YES;
         customAler=[[CustomIOSAlertView alloc]init];
        [customAler setButtonTitles:@[@"取消",@"确定"]];
        customAler.delegate=self;
        
        UIView *alerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 140)];
        alerLable1=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, 230, 60)];
        alerLable1.text=@"为保障你的数据安全，修改密码前验证原密码。";
        alerLable1.font=[UIFont fontWithName:@"Marion" size:16];
        alerLable1.numberOfLines=2;
        
        
        alerLable2=[[UILabel alloc]initWithFrame:CGRectMake(30, 80, 200, 15)];
        
        alerLable2.textColor=[UIColor redColor];
        alerLable2.font=[UIFont fontWithName:@"Marion" size:12];
        alerLable2.hidden=YES;
        
        alerPass=[[UITextField alloc]initWithFrame:CGRectMake(30, 95, 200, 30)];
        alerPass.borderStyle=UITextBorderStyleNone;
        alerPass.placeholder=@"请输入密码";
        alerPass.font=[UIFont fontWithName:@"Marion" size:12];
        alerPass.secureTextEntry=YES;
        alerPass.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
        alerPass.layer.borderWidth=0.3f;
        
        [alerView addSubview:alerLable2];
        [alerView addSubview:alerPass];
        [alerView addSubview:alerLable1];
        [customAler setContainerView:alerView];
        [customAler show];
    }
}

#pragma mark CustomIOSAlertViewDelegate
-(void)clickToChange{
    
    NSLog(@"更改的协议方法");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//自定义aler代理方法
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
   
   
    
    if (buttonIndex==0) {
        
        [customAler close];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(buttonIndex==1){
        
       
        
        //验证密码的正确性http
        [self validationPassWord];
        [self hideHud];        
    }
    
}

//验证密码的正确性http
-(void)validationPassWord{
    
    
    //提示框
    [self showHudInView:self.view hint:@"正在验证..."];
    NSString *http=[requestTheCodeURL stringByAppendingString:@"login"];
    NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pwd":alerPass.text};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSData *thaData = responseObject;
        returnString=  [NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil];
        
        if ([[user_info objectForKey:userIsqCode] isEqualToString:returnString[userIsqCode]]) {
            
            
            [customAler close];
            [self hideHud];
            
            
        }else {
            
            alerLable2.hidden=NO;
            alerLable2.text=@"密码错误，请重新输入...";
            [self hideHud];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self hideHud];
        alerLable2.hidden=NO;
        alerLable2.text=@"网络异常，请稍后再试...";

    }];
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)accountNext_bt:(id)sender {
    
    
        if ([[newAccountData objectAtIndex:0] isEqualToString:@"邮箱地址"]){
        self.resendEmail_ol.hidden=NO;
        self.accountNext_ol.hidden=YES;
        self.emailLable.text=@"该邮箱未验证，请登录您的邮箱查收并验证。";
        
            
            
            //更改邮箱网络请求
            [self changeHttpClink];
        
    }else if ([[newAccountData objectAtIndex:0] isEqualToString:@"账号密码"]){
        
        //更改密码网络请求
        [self changeMeth];
        
    }
    
    }


//更改邮箱请求
-(void)changeHttpClink{
    
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"changeproperty"];
    NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pnum":@"3",@"pv":self.email_tv.text};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSData *thaData = responseObject;
        returnString=  [NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil];
        
        
        
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"一封邮件已经发送至%@，请登录你的邮箱查收并通过邮件验证。",self.email_tv.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        
//        if ([returnString[@"userAccount"] isEqualToString:self.loginPhoneNumber_tv.text] ) {
//            
//           
//            
//        }else {
//            
////            [self warning2:@"密码/手机号 错误"];
//            
//        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        NSLog(@"Error:%@",error);
//        warInt=false;
//        [self warning2:@"服务器未响应，请检查网络" ];
    }];
    
    
    
}

//执行更改密码请求
-(void)changeMeth{
    
    
    
    NSLog(@"更改密码，要重新记录好本地的密码");
    
    
    if ([self.changePass1.text isEqualToString:self.changePass2.text]) {
        
        
        
        NSString *http=[requestTheCodeURL stringByAppendingString:@"registsteptwo"];
        NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pwd":self.changePass1.text
                             
                             };
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSData *thaData = responseObject;
            returnString=  [NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil];
            
            
            if ([returnString isEqual:@"1"]) {
                
                UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"社区号设置成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aler show];
                
                
            }else {
                
                UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"社区号设置失败，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aler show];
                
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //        NSLog(@"Error:%@",error);
            //        warInt=false;
            //        [self warning2:@"服务器未响应，请检查网络" ];
            
            
        }];
        
        
    }else if(self.changePass1.text.length==0||self.changePass2.text.length==0){
        
        
        customAler=[[CustomIOSAlertView alloc]init];
        alerLable1=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, 230, 60)];
        alerLable1.text=@"密码不能为空！";
        alerLable1.textAlignment=1;//居中
        alerLable1.font=[UIFont fontWithName:@"Marion" size:13];
        [customAler setButtonTitles:@[@"确定"]];
        [customAler setContainerView:alerLable1];
        [customAler show];

        
    }
    else {
        
        
        customAler=[[CustomIOSAlertView alloc]init];
        alerLable1=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, 230, 60)];
        alerLable1.text=@"两次输入的密码不一致！";
        alerLable1.textAlignment=1;//居中
        alerLable1.font=[UIFont fontWithName:@"Marion" size:13];
        [customAler setButtonTitles:@[@"确定"]];
        [customAler setContainerView:alerLable1];
        [customAler show];
    }
    
    
    
    
    
    
}
- (IBAction)accountBack_bt:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resendEmail_bt:(id)sender {
    
    
    
}
@end
