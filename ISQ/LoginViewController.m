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
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

@interface LoginViewController ()<TencentSessionDelegate,WXApiDelegate>
{
    NSDictionary *returnString;

    EGOCache *theCache;
}
@property (strong, nonatomic) TencentOAuth * tencentOAuth;

@end

@implementation LoginViewController
@synthesize loginPassWord_tv,loginPhoneNumber_tv;
@synthesize loginLoginView,loginPassView;

bool warInt=true;


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID
                                            andDelegate:self];

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

- (IBAction)QQLogIn:(UIButton *)sender {
    [self QQLogin];
}

- (IBAction)weixinLogIn:(UIButton *)sender {
    [self sendAuthRequest];
}

#pragma QQ
- (void)QQLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]!= nil) {
        [_tencentOAuth setAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]];
        [_tencentOAuth setOpenId:[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"]];
        [_tencentOAuth setExpirationDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"]];
        
    }
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    
    [_tencentOAuth authorize:permissions inSafari:NO];
}

-(void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间,测试时存在本地，建议各种信息存在云端服务器上,需要时访问服务器获取
        [[NSUserDefaults standardUserDefaults] setObject:_tencentOAuth.accessToken forKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] setObject:_tencentOAuth.openId forKey:@"openId"];
        [[NSUserDefaults standardUserDefaults] setObject:_tencentOAuth.expirationDate forKey:@"expirationDate"];
        
        
        NSString * httpString = [NSString stringWithFormat:@"https://openmobile.qq.com/user/get_simple_userinfo?access_token=%@&oauth_consumer_key=%@&openid=%@",_tencentOAuth.accessToken,_tencentOAuth.appId,_tencentOAuth.openId];
        [ISQHttpTool getHttp:httpString contentType:nil params:nil success:^(id data) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dic = %@",dic);
            
            //建议在获取用户信息成功后再对接爱社区第三方登录
            
//            id community_id =[user_info objectForKey:userCommunityID];
//            NSMutableDictionary * paramsDic = [NSMutableDictionary dictionaryWithObjects:@[@"client_credentials",@"qq",_tencentOAuth.openId,community_id] forKeys:@[@"grant_type",@"login_type",@"openid",@"community_id"]];
//            
//            paramsDic[@"nickname"] = dic[@"nickname"];
//            paramsDic[@"sex"] = [dic[@"gender"] isEqualToString:@"男"]?@0:@1;
//            paramsDic[@"user_face"] = dic[@"figureurl_qq_1"];
//
//            [ISQHttpTool post:@"http://api.wisq.cn/oauth/authorization/otherlogin" contentType:nil params:paramsDic success:^(id responseObj) {
//                NSDictionary * dic2 = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
//                NSLog(@"dic2 ======== %@",dic2);
//
//            } failure:^(NSError *error) {
//
//            }];
        } failure:^(NSError *erro) {
            
        }];
        
    }
    else
    {
        
    }
    
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
    }
    else
    {
    }
    
}

-(void)tencentDidNotNetWork
{
    
}

-(void)tencentDidLogout
{
    
}

#pragma weixin
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];//安装微信时onResp:在Appdelegate中
    }else {
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }
}

-(void)onResp:(BaseResp *)resp//没有安装微信时,安装微信后在Appdelegate中响应相同的方法
{
    if (!resp.errCode) {
        if([resp isKindOfClass:[SendMessageToWXResp class]]){
            SendMessageToWXResp * SendMessage = (SendMessageToWXResp *)resp;
            
        }else{
            SendAuthResp * AuthResp = (SendAuthResp *)resp;
            NSString * httpString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",weixinAppID,weixinAppSecret,AuthResp.code];
            [ISQHttpTool getHttp:httpString contentType:nil params:nil success:^(id data) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"dic = %@",dic);
                /*
                 {
                 "access_token":"ACCESS_TOKEN",
                 "expires_in":7200,
                 "refresh_token":"REFRESH_TOKEN",
                 "openid":"OPENID",
                 "scope":"SCOPE",
                 "unionid":"o6_bmasdasdsad6_2sgVt7hMZOPfL"
                 } 
                 */
                
            //用户信息 http请求方式: GET，建议在获取用户信息成功后再对接爱社区第三方登录
            //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
                
            } failure:^(NSError *erro) {
                
            }];
        }
    }
    
}

@end
