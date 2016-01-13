//
//  AppDelegate.m
//  ISQ
//
//  Created by mac on 15-3-11.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "ChatListViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "ApplyViewController.h"
#import "AppDelegate+EaseMob.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UMessage.h"
#import "BeeCloud.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate (){
    BMKMapManager* _mapManager;
    NSDictionary *returnString;
    bool warInt;
    MBProgressHUD *HUD;
    EMPushNotificationDisplayStyle _pushDisplayStyle;
    NSDictionary *dic;
    NSString *trackViewUrl;
}
@property (nonatomic, strong) Reachability *conn;
@end

@implementation AppDelegate
@synthesize  theLa,theLo,theAddress,theAddress_city,theDistrict;
bool islogin=false;
@synthesize networkStatic,isBackground;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self pushUM:launchOptions];

     [[EaseMob sharedInstance].chatManager setIsUseIp:NO];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    //环信
    [self theHuanxinSDK];
    
    
    //百度SDK
    [self theBaiduSDK];

    //shareSDK
    [self theShareSDK];
    
    //网络状态监测
    [self netStatic];
    [self checkNetworkState];
    
    //从app store 获取版本数据
//    [self getVersionData];
    
    //检查版本更新
//    [self onCheckVersion];
    
    //支付
    [BeeCloud initWithAppID:@"5652c5fb-096e-4660-8fa8-a9a511e9b296" andAppSecret:@"a3c0fefd-45e6-44aa-822c-117005773586"];
    [BeeCloud initWeChatPay:weixinAppID];
    
    return YES;
    
    
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}

-(void)pushUM:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:@"566f7e4b67e58ef47d003c5d" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log
//    [UMessage setLogEnabled:YES];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
//      [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
        //定制自定的的弹出框
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            NSDictionary * aps = userInfo[@"aps"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"爱社区提醒您"
                                                                message:aps[@"alert"]
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            NSArray * arrayKeys = [userInfo allKeys];
            if ([arrayKeys containsObject:@"property"]) {//物业
                if ([userInfo[@"property"] isEqualToString:@"repair"]) {
                    alertView.tag = -1;//物业报修时tag等于-1
                }
            }
            [alertView show];
            
        }
}

-(void)netStatic{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}

- (void)networkStateChange
{
    [self checkNetworkState];
}

- (void)checkNetworkState
{
    
    
    // 1.检测wifi状态
//    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    networkStatic=[NSString stringWithFormat:@"123 %u",[conn currentReachabilityStatus]];
    
    
    // 3.判断网络状态
//    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
    
        
//    } else

}


#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
        
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        
    }else{
        
        //登陆失败加载登陆页面控制器
        
    }
    
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    isBackground=YES;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    isBackground=NO;
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

-(void)theHuanxinSDK{
    
    
    [self loginStateChange:nil];
    
    
    NSUserDefaults *userSetting=[NSUserDefaults standardUserDefaults];
    
    if ([userSetting objectForKey:notify_switch]) {
        
        return;
    }else {
        [userSetting setValue:@"YES"  forKey:notify_switch];
    }
    if ([userSetting objectForKey:Sound_switch]) {
        return;
    }else {
        [userSetting setValue:@"YES"  forKey:Sound_switch];
    }
    if ([userSetting objectForKey:Shating_switch]) {
        return;
    }else {
        [userSetting setValue:@"YES"  forKey:Shating_switch];
    }
    if ([userSetting objectForKey:detail_switch]) {
        return;
    }else {
        [userSetting setValue:@"YES"  forKey:detail_switch];
    }
    
    
    if ([[userSetting objectForKey:@"detail_switch"] isEqualToString:@"YES"]) {
        
        // 此处设置详情显示时的昵称，比如_nickName = @"环信";
        _pushDisplayStyle = ePushNotificationDisplayStyle_messageSummary;
    }
    else{
        _pushDisplayStyle = ePushNotificationDisplayStyle_simpleBanner;
    }

    
    }


-(void)theBaiduSDK{
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDUMAPKEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图API启动失败...");
    }
    theAddress=@"定位失败";

}

//shareSDK
-(void)theShareSDK{
    
    [ShareSDK registerApp:@"58820de937c2"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"428139603"
                               appSecret:@"28549fbcf554097ccfd73ff55435b6f0"
                             redirectUri:@"http://www.weibo.com"];

    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104175103"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104175103"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:weixinAppID   //微信APPID
                           appSecret:weixinAppSecret  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    //连接邮件
    [ShareSDK connectMail];
    
}


//信息更改一次就重新获取用户信息
-(void)ToObtainInfo:(NSString*)str{
    
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"login"];
    NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pwd":[user_info objectForKey:userPassword]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"%lu",(unsigned long)[responseObject length]);
        NSData *thaData = responseObject;
        returnString=  [NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil];
        
        //用户信息存储
        [user_info setObject:returnString[userAccount] forKey:userAccount];
        [user_info setObject:returnString[userNickname] forKey:userNickname];
        [user_info setObject:returnString[userGender] forKey:userGender];
        [user_info setObject:returnString[userIntro] forKey:userIntro];
        [user_info setObject:returnString[userCommunityID] forKey:userCommunityID];
        [user_info setObject:returnString[userIsqCode] forKey:userIsqCode];
        [user_info setObject:returnString[userCityID] forKey:userCityID];
        
        [user_info setObject:returnString[MyUserID] forKey:MyUserID];
        
            warInt=true;
        ISQLog(@"userNickname-%@--userGender--%@--userIntro%@--",returnString[userNickname],returnString[userGender],returnString[userIntro]);
        
        
        if (str==nil || [str length]<=0) {
            [self warning2:@"保存成功！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error:%@",error);
        warInt=false;
        if (str==nil || [str length]<=0) {
             [self warning2:@"服务器未响应，请检查网络" ];
        }
        
        
    }];
    
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)warning2:(NSString *)warString2{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    HUD.mode=MBProgressHUDModeText;
    
    HUD.labelText =[NSString stringWithFormat:@"%@",warString2];
    HUD.margin = 8.f;
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:1.5];
}

//获取版本数据
-(void)getVersionData{
    NSString *URL = APP_URL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *resultString = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    dic = dicData;
}

//检查当前版本号并提示更新
- (void)onCheckVersion{

    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSArray *infoArray = [dic objectForKey:@"results"];
    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
    NSString *latestVersion = [releaseInfo objectForKey:@"version"];
    trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
    if (![latestVersion isEqualToString:currentVersion]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                message:nil
                               delegate:self
                      cancelButtonTitle:@"以后再说"
                      otherButtonTitles:@"立即更新",nil];
        
        [alert show];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        UIApplication *appllication = [UIApplication sharedApplication];
        [appllication openURL:[NSURL URLWithString:trackViewUrl]];
    }
    if (alertView.tag == -1) {//物业报修时tag等于－1,跳转到首页
        UIStoryboard *mainStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *mainVC=[mainStory instantiateViewControllerWithIdentifier:@"MainViewStory"];
        self.window.rootViewController = mainVC;
        [mainVC setSelectedIndex:0];
    }
}


@end
