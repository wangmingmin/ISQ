//
//  RegisterController.m
//  ISQ
//
//  Created by mac on 15-4-22.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "RegisterController.h"
#import "LoginViewController.h"
#import "UserAgreementController.h"
#import "AppDelegate.h"

@interface RegisterController (){
    
    NSInteger numberLoog;
    NSTimer  *sendCodeTiem;
    NSTimer  *textFildTiem;
    NSInteger isSendCodeTime;
    NSString *codeNumber;
    bool isAreement;
    AppDelegate *appDelegete;

}
    
    

@end

@implementation RegisterController
@synthesize phoneNumber_bt_ol,phoneNumber_tv,phoneView,agreement_bt_ol,phoneNumView;
@synthesize messageView,message_code_tv,message_lable,message_next_ol;
@synthesize passwordView,nikname_tv,registerOK_ol;
@synthesize passview1,passview2,messageView1,messageview2,phoneView1;
@synthesize theTimeLable;
bool isphoneNumView=true;
bool isMessageView=false;
bool isPasswordView=false;
bool isNext=false;
bool RegisterwarInt=true;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化UI
    [self initView];
    
    appDelegete=[[AppDelegate alloc]init];
    
}

-(void)initView{
    
    self.navigationController.navigationBar.hidden=NO;
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.phoneNumView.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
    self.phoneNumView.layer.borderWidth=0.5f;
    
    
    [self.phoneNumber_bt_ol setBackgroundImage:[UIImage imageNamed:@"registerRectangle 392"] forState:UIControlStateNormal];
    self.phoneNumber_bt_ol.enabled=NO;
    
    self.phoneNumber_tv.delegate=self;
    self.passWord_tv.delegate=self;
    self.nikname_tv.delegate=self;
    
    self.phoneView1.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.6f].CGColor;
    self.phoneView1.layer.borderWidth=0.8f;
    
    self.messageView1.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.6f].CGColor;
    self.messageView1.layer.borderWidth=0.8f;
    self.messageview2.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.6f].CGColor;
    self.messageview2.layer.borderWidth=0.8f;
    
    self.passview2.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.6f].CGColor;
    self.passview2.layer.borderWidth=0.8f;
    
    self.passview1.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.6f].CGColor;
    self.passview1.layer.borderWidth=0.8f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [sendCodeTiem invalidate];
    textFildTiem=nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==self.phoneNumber_tv) {
        
        textFildTiem= [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(isEnabledtoNext) userInfo:nil repeats:NO];
    }
    else if(textField==self.passWord_tv){
        
        textFildTiem= [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(isEnabledtoNext) userInfo:nil repeats:NO];
    }else if(textField==self.nikname_tv){
        
        //不能输入特殊字符（延迟0.01s）
        
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(niknameTvTest) userInfo:nil repeats:NO];
        
    }
    
    return YES;
}

//昵称输入的特殊字符会过滤掉
-(void)niknameTvTest{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@ ,.!／/：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    
    NSString *trimmedString = [self.nikname_tv.text stringByTrimmingCharactersInSet:set];
    self.nikname_tv.text=trimmedString;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    if(textField==self.phoneNumber_tv){
        [self.phoneNumber_bt_ol setBackgroundImage:[UIImage imageNamed:@"registerRectangle 392"] forState:UIControlStateNormal];
        self.phoneNumber_bt_ol.enabled=NO;
    }
    else if(textField==self.passWord_tv||textField==self.nikname_tv){
        
        [self.registerOK_ol setBackgroundImage:[UIImage imageNamed:@"registerRectangle 392"] forState:UIControlStateNormal];
        self.registerOK_ol.enabled=NO;
    }
    

    return YES;
}

//判断下一步按钮(手机号输入)是否可以按下
-(void)isEnabledtoNext{
    
    //正则表达，密码只能输入a-z,0-9
   
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"([^A-Za-z0-9])"
                                  options:0
                                  error:&error];
    
    NSString *resString = [regex stringByReplacingMatchesInString:self.passWord_tv.text options:0 range:NSMakeRange(0, self.passWord_tv.text.length) withTemplate:@""];
    
    self.passWord_tv.text=resString;
    
    
    
    if (isphoneNumView==true) {
        if(self.phoneNumber_tv.text.length==11){
            isNext=true;
            self.phoneNumber_bt_ol.enabled=YES;
            [self.phoneNumber_bt_ol setBackgroundImage:[UIImage imageNamed:@"Rectangle 961"] forState:UIControlStateNormal];
        }else if (self.phoneNumber_tv.text.length!=11){
            isNext=false;
            [self.phoneNumber_bt_ol setBackgroundImage:[UIImage imageNamed:@"registerRectangle 392"] forState:UIControlStateNormal];
            self.phoneNumber_bt_ol.enabled=NO;
        }
    }
    else if(isPasswordView==true){
        
        if (self.passWord_tv.text.length>=6&&self.passWord_tv.text.length<=16&&self.nikname_tv.text.length>0) {
            
            self.registerOK_ol.enabled=YES;
            [self.registerOK_ol setBackgroundImage:[UIImage imageNamed:@"Rectangle 961"] forState:UIControlStateNormal];
            
        }else {
            
            self.registerOK_ol.enabled=NO;
            [self.registerOK_ol setBackgroundImage:[UIImage imageNamed:@"registerRectangle 392"] forState:UIControlStateNormal];
            
        }
        
    }

}
 //进入验证码的view的初始化工作
-(void)enTheMessageView{
    
    if ([codeNumber isEqualToString:@"3"]) {
        self.again_send_code_ol.enabled=NO;
        codeNumber=@"";
        self.nikname_tv.text=nil;
        self.passWord_tv.text=nil;
        
    }else {
        
        message_lable.text=[NSString stringWithFormat:@"我们已经给你的手机号码%@发送了一条包含验证码的短信。",self.phoneNumber_tv.text];
        self.again_send_code_ol.enabled=NO;
        isSendCodeTime=60;//60s倒计时
        sendCodeTiem=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendCodeTime) userInfo:nil repeats:YES];        
    }
}

//是否可以发送验证码的倒计时
-(void)sendCodeTime{
    
    isSendCodeTime=isSendCodeTime-1;

    self.theTimeLable.text=[NSString stringWithFormat:@"(%ld)",(long)isSendCodeTime];
    
    if (isSendCodeTime<=0) {
        self.theTimeLable.text=@"";
        self.again_send_code_ol.enabled=YES;
        [sendCodeTiem invalidate];
    }
    
}

//验证码正确后进入密码输入的view
-(void) enThePasswordView{
    isPasswordView=true;
    self.passwordView.hidden=NO;
    [self.registerOK_ol setBackgroundImage:[UIImage imageNamed:@"registerRectangle 392"] forState:UIControlStateNormal];
    self.registerOK_ol.enabled=NO;
    
}


//用户协议选框
- (IBAction)agreement_bt:(id)sender {
    
    
    
    if (isAreement) {
        
        [self.agreement_bt_ol setImage:[UIImage imageNamed:@"registerCheckmark"] forState:UIControlStateNormal];
        isAreement=!isAreement;
    }else {
        
        [self.agreement_bt_ol setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        isAreement=!isAreement;
    }
    
   
}

//用户协议按钮
- (IBAction)use_agreement_bt:(id)sender {
    
    [self.view endEditing:YES];
    
}



//手机号输入完成的下一步
- (IBAction)phoneNumber_next_bt:(id)sender {
    
    if (isAreement) {
        
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请阅读爱社区《用户使用协议》,并勾选此项。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        
    }else {
        
        //请求验证码
        [self requestTheCode];
    }
    
 
}

//重新发送验证码的按钮
- (IBAction)again_send_code_bt:(id)sender {
    [sendCodeTiem invalidate];
    
    isSendCodeTime=60;
    sendCodeTiem=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendCodeTime) userInfo:nil repeats:YES];
    self.again_send_code_ol.enabled=NO;
    
    [self requestTheCode];
    
}

//验证码输入后下一步按钮
- (IBAction)message_next_bt:(id)sender {
    
    if(self.message_code_tv.text.length!=0){
        
        self.messageView.hidden=YES;
        //验证码正确后进入密码输入的view
        [self enThePasswordView];
    }else{
        
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入获取到的手机验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        
    }
        
}

//所有一切输入正确后按钮
- (IBAction)registerOK_bt:(id)sender {
    
    //提示框
    [self showHudInView:self.view hint:@"正在注册.."];
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"registsteptwo"];
    NSDictionary *arry=@{@"phone":self.phoneNumber_tv.text,@"nickname":self.nikname_tv.text,@"vcode":self.message_code_tv.text,@"pwd":self.passWord_tv.text};
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id responseObject) {
        
        NSData *data = responseObject;
        codeNumber =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if ([codeNumber isEqualToString:@"9"]) {
            
            [self hideHud];
            [self AleView:[NSString stringWithFormat:@"号码:%@已经被注册！",self.phoneNumber_tv.text]];
            
        }
        else if([codeNumber isEqualToString:@"1"]){
            
            [self hideHud];
            [self AleView:@"注册成功！"];
            
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
            LoginViewController *loginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
            
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }else if([codeNumber isEqualToString:@"3"]){
            
            [self hideHud];
            [self AleView:@"验证码错误！"];
            self.passwordView.hidden=YES;
            self.phoneView.hidden=YES;
            self.messageView.hidden=NO;
            isphoneNumView=false;
            //进入验证码的view
            [self enTheMessageView];
        }
        
        else {
            [self hideHud];
            [self AleView:@"注册失败，昵称似乎已被占用"];
            
        }
        

        
    } failure:^(NSError *erro) {
        
        [self hideHud];
        [self AleView:@"服务器未响应，请稍后再试！"];
        
    }];
   
}
- (IBAction)registerBack_bt:(id)sender {

        self.navigationController.navigationBar.hidden=YES;
    
}


-(void)viewDidDisappear:(BOOL)animated{
    
    isphoneNumView=true;
    isPasswordView=false;
    isMessageView=false;
    
}

 //请求验证码
-(void)requestTheCode{
    
    
    //提示框
     [self showHudInView:self.view hint:@"正在获取.."];     
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"registstepone"];
    NSDictionary *arry=@{@"phone":self.phoneNumber_tv.text};
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id responseObject) {
        
        NSData *data = responseObject;
        codeNumber =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        
        if ([codeNumber isEqualToString:@"9"]) {
            
            [self hideHud];
            [self AleView:[NSString stringWithFormat:@"号码:%@已经被注册！",self.phoneNumber_tv.text]];
            
        }
        else if([codeNumber isEqualToString:@"1"]){
            
            [self hideHud];
            self.phoneView.hidden=YES;
            self.messageView.hidden=NO;
            isphoneNumView=false;
            //进入验证码的view
            [self enTheMessageView];
            
        }else {
            [self hideHud];
            [self AleView:@"获取验证码失败！"];
            
        }
        

        
    } failure:^(NSError *erro) {
        
        [self hideHud];
        [self AleView:@"服务器未响应，请稍后再试！"];

    }];

}


-(void)AleView:(NSString *)str{
    
    UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [aler show];
    
}


 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if ([[segue identifier] isEqualToString:@"userAgreementSegue"]) {
         
         [[segue destinationViewController] setUseAgreeData:@[@"爱社区用户注册使用协议"]];
         
     }
     
     
 }
//键盘隐藏
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



@end
