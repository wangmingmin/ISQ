//
//  LoginViewController.m
//  ISQ
//
//  Created by mac on 15-4-22.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "AFURLResponseSerialization.h"
#import "AppDelegate.h"
#import "ImgURLisFount.h"

@interface LoginViewController (){
    NSDictionary *returnString;

    EGOCache *theCache;
}

@end

@implementation LoginViewController
@synthesize loginPassWord_tv,loginPhoneNumber_tv;
@synthesize loginLoginView,loginPassView;

bool warInt=true;


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    theCache=[[EGOCache alloc]init];
    self.navigationController.navigationBar.hidden=YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    //用户信息存储
    if([user_info objectForKey:userAccount]){
        
        self.loginPhoneNumber_tv.text=[user_info objectForKey:userAccount];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//键盘隐藏
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)login_bt:(id)sender {
    
    //提示框
     [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];    
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"login"];
    NSDictionary *arry=@{@"phone":self.loginPhoneNumber_tv.text,@"pwd":self.loginPassWord_tv.text};
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id responseObject) {
        
        returnString=  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
        
        if ([returnString[userAccount] isEqualToString:self.loginPhoneNumber_tv.text] ) {
            
            [self hideHud];
            
            //用户信息存储
            [user_info setObject:returnString[userAccount] forKey:userAccount];
            [user_info setObject:self.loginPassWord_tv.text forKey:userPassword];
            [user_info setObject:returnString[userNickname] forKey:userNickname];
            [user_info setObject:returnString[userGender] forKey:userGender];
            [user_info setObject:returnString[userIntro] forKey:userIntro];
            [user_info setObject:returnString[userIsqCode] forKey:userIsqCode];
            [user_info setObject:returnString[MyUserID] forKey:MyUserID];
            
            
            [user_info setObject:[NSString stringWithFormat:@"%@%@",MYHEADIMGURL,returnString[@"userFace"]] forKey:MYSELFHEADNAME];
            
            //判断用户是否已有社区||或城市，否则默认为武汉
            if (returnString[userCommunityID]) {
                
                [user_info setObject:returnString[userCommunityID] forKey:userCommunityID];
                
                if (![user_info objectForKey:userCityName]) {
                    [user_info setObject:@"城市" forKey:userCityName];
                }
                
                
            }else{
                
                [user_info setObject:@"717" forKey:userCommunityID];
                [user_info setObject:@"267" forKey:userCityID];
                [user_info setObject:@"武汉" forKey:userCityName];
                
            }
            
            
            UIStoryboard *mainStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *mainVC=[mainStory instantiateViewControllerWithIdentifier:@"MainViewStory"];
            self.navigationController.navigationBar.hidden=YES;
            [self.navigationController pushViewController:mainVC animated:YES];
            
            warInt=true;
            
        }else {
            
            UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名/密码错误。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerView show];
            
            [self hideHud];
        }
        
    } failure:^(NSError *erro) {
        
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常，请稍后再试。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        [self hideHud];
        
    }];
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return NO;
}

- (IBAction)visitorAction:(id)sender {
    
    UIStoryboard *mainStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainVC=[mainStory instantiateViewControllerWithIdentifier:@"MainViewStory"];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController pushViewController:mainVC animated:YES];

}


@end
