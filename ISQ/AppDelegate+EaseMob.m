//
//  AppDelegate+EaseMob.m
//  EasMobSample
//
//  Created by dujiepeng on 12/5/14.
//  Copyright (c) 2014 dujiepeng. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "ApplyViewController.h"
#import "UMessage.h"
/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)
- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (launchOptions) {
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
            [self application:application didReceiveRemoteNotification:userInfo];
        }
    }
    
    _connectionState = eEMConnectionConnected;
    
    [self registerRemoteNotification];
    
 // APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = @"isq_isq";
#if DEBUG
    apnsCertName = @"isq_isq";
#else
    apnsCertName = @"isq_isq";
#endif

    [[EaseMob sharedInstance] registerSDKWithAppKey:@"i-shequ#isq"
                                       apnsCertName:apnsCertName
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    // 登录成功后，自动去取好友列表
    // SDK获取结束后，会回调
    // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    // 注册环信监听
    [self registerEaseMobNotification];
    [[EaseMob sharedInstance] application:application
            didFinishLaunchingWithOptions:launchOptions];
    
    [self setupNotifiers];
}


// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSString * string_id = [NSString stringWithFormat:@"%ld",[[user_info objectForKey:MyUserID] integerValue]];
    
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"＊＊＊＊＊＊＊%@＊＊＊＊＊＊＊",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                stringByReplacingOccurrencesOfString: @">" withString: @""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    //添加友盟别名绑定
    [UMessage addAlias:string_id type:AliasTypeForUM response:^(id responseObject, NSError *error) {
        if(responseObject)
        {
//            [self showMessageAlert:@"绑定成功！"];
        }
        else
        {
//            [self showMessageAlert:error.localizedDescription];
        }
    }];

}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
//                                                    message:error.description
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
    
    NSLog(@"APNS证书没有找到------%@",error.description);
    
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);

}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;

    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }

#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



#pragma mark - IChatManagerDelegate
// 开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{

    if (error) {
    
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
    }else {
        
        //将旧版的coredata数据导入新的数据库
        EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
        if (!error) {
            error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
        }
        
    }
    
   
    
}

// 结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
//    UIAlertView *alertView = nil;
//    if (error) {
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    }
//    else{
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.endAutoLogin", @"End automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    }
//    
//    [alertView show];
}

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
   
    
//    NSLog(@"messagemessage--%@",message);
//    
//    
//    if (!username) {
//        return;
//    }
//    if (!message) {
//        message = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"add you as a friend")];
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
//    
//
//    [[ApplyViewController shareController] addNewApply:dic];
//    
//    
//    if (self.mainController) {
//        [self.mainController setupUntreatedApplyCount];
//    }
    
    
}






// 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    

    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    /*!
     @enum
     @brief 退出群组的原因
     @constant eGroupLeaveReason_BeRemoved 被管理员移除出该群组
     @constant eGroupLeaveReason_UserLeave 用户主动退出该群组
     @constant eGroupLeaveReason_Destroyed 该群组被别人销毁
     */
    
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:NSLocalizedString(@"group.beKicked", @"you have been kicked out from the group of \'%@\'"), tmpStr];
    }
    else if(reason == eGroupLeaveReason_Destroyed){
        
        str = [NSString stringWithFormat:@"群（%@）被管理员解散了", tmpStr];
        
    }
    if (str.length > 0) {
        TTAlertNoTitle(str);
    }
}

// 申请加入群组被拒绝回调
//- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
//                                   groupname:(NSString *)groupname
//                                      reason:(NSString *)reason
//                                       error:(EMError *)error{
//    if (!reason || reason.length == 0) {
//        reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), groupname];
//    }
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:reason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//}

//接收到入群申请
//- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
//                         groupname:(NSString *)groupname
//                     applyUsername:(NSString *)username
//                            reason:(NSString *)reason
//                             error:(EMError *)error
//{
//
//    
//    if (!groupId || !username) {
//        return;
//    }
//    
//    if (!reason || reason.length == 0) {
//        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), username, groupname];
//    }
//    else{
//        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), username, groupname, reason];
//    }
//    
//    if (error) {
//        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.sendApplyFail", @"send application failure:%@\nreason：%@"), reason, error.description];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//    else{
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
//        
//        [[ApplyViewController shareController] addNewApply:dic];
//        if (self.homeController) {
//            [self.homeController setupUntreatedApplyCount];
//        }
//    }
//}

// 已经同意并且加入群组后的回调
//- (void)didAcceptInvitationFromGroup:(EMGroup *)group
//                               error:(EMError *)error
//{
//    if(error)
//    {
//        return;
//    }
//    
//    NSString *groupTag = group.groupSubject;
//    if ([groupTag length] == 0) {
//        groupTag = group.groupId;
//    }
//    
//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed and joined the group of \'%@\'"), groupTag];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//}


// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    //[self.mainController networkChanged:connectionState];
}

// 打印收到的apns信息
-(void)didReiveceRemoteNotificatison:(NSDictionary *)userInfo{
    NSUserDefaults *user_setting=[NSUserDefaults standardUserDefaults];
    
        
    if ([[user_setting objectForKey:detail_switch] isEqualToString:@"YES"]) {
        
        NSError *parseError = nil;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                            options:NSJSONWritingPrettyPrinted error:&parseError];
        //    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *strArry=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJapaneseEUCStringEncoding  error:nil];
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@的消息：",strArry[@"f"]]
                                                        message:strArry[@"aps"][@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
        
        
        

        
    }
  }

@end
