//
//  ChangePhoneNumController.m
//  ISQ
//
//  Created by mac on 15-4-24.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ChangePhoneNumController.h"

@interface ChangePhoneNumController (){
    
    NSTimer  *sendCodeTiem;
    NSTimer  *textFildTiem;
    NSInteger isSendCodeTime;
}

@end

@implementation ChangePhoneNumController
@synthesize changePhoneNext_lable,changePhoneNext_ol,changePhonenextView1,changePhonenextView2,Confirm_ol,sendMessageCode_ol,timeLable;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//进入验证码的view的初始化工作
-(void)enTheMessageView{
    self.sendMessageCode_ol.enabled=NO;
    isSendCodeTime=60;//60s倒计时
    sendCodeTiem=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendCodeTime) userInfo:nil repeats:YES];
    
    
}

//是否可以发送验证码的倒计时
-(void)sendCodeTime{
    
    isSendCodeTime=isSendCodeTime-1;
    
    self.timeLable.text=[NSString stringWithFormat:@"(%ld)",(long)isSendCodeTime];
    
    if (isSendCodeTime<=0) {
        self.timeLable.text=@"";
        self.sendMessageCode_ol.enabled=YES;
        [sendCodeTiem invalidate];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePhoneBack_bt:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)changePhoneNext_bt:(id)sender {
    
    self.changePhonenextView1.hidden=YES;
    self.changePhonenextView2.hidden=NO;
    self.changePhoneNext_ol.hidden=YES;
    self.Confirm_ol.hidden=NO;
    //进入验证码的view
    [self enTheMessageView];
    
    
}
- (IBAction)Confirm_bt:(id)sender {
    
    
}
- (IBAction)sendMessageCode_bt:(id)sender {
    
    isSendCodeTime=60;
    sendCodeTiem=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendCodeTime) userInfo:nil repeats:YES];
    self.sendMessageCode_ol.enabled=NO;
}
@end
