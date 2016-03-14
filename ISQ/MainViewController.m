//
//  MainViewController.m
//  ISQ
//
//  Created by mac on 15-3-31.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+HUD.h"
#import "ApplyViewController.h"
#import "MessageViewController.h"
#import "CallViewController.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"
#import "EMCDDeviceManager.h"
#import "LoginViewController.h"
#import "ImgURLisFount.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface MainViewController ()<UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate>

{
    
    ChatListViewController *_chatListVC;
    MessageViewController *_msgVC;
    NSUserDefaults *userSetting;
    EGOCache *theCache;
    AVAudioPlayer *_ringPlayer;
    
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong,nonatomic) HomeViewController *homeViewController;
@end

@implementation MainViewController
@synthesize theAddress;

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

- (void)viewDidLoad {
    [super viewDidLoad];
    _msgVC=[[MessageViewController alloc]init];
    _chatListVC = [[ChatListViewController alloc] init];
    //用户的设置状态
    userSetting=[NSUserDefaults standardUserDefaults];
    
    //把self注册为SDK的delegate
    [self registerNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    //设置显示首页
    self.selectedIndex = 0;
    theCache=[[EGOCache alloc]init];
    //登录环信
    [self loginIM];
    //获取好友数据
    [self getImFriendsData];
    
    //获取用户资料
    [self getUserInfo];
    [self theWIFI];
    
}



#pragma mark 获取用户基本资料
-(void)getUserInfo{
    
    AppDelegate *delget=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delget ToObtainInfo:@"frist"];
    
    
}

#pragma mark - call

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    if (!bCanRecord) {
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alt show];
    }
    
    return bCanRecord;
}

- (void)callOutWithChatter:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (![self canRecord]) {
            return;
        }
        
        EMError *error = nil;
        NSString *chatter = [object objectForKey:@"chatter"];
        EMCallSessionType type = [[object objectForKey:@"type"] intValue];
        EMCallSession *callSession = nil;
        if (type == eCallSessionTypeAudio) {
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:50 error:&error];
            
        }
        else if (type == eCallSessionTypeVideo){
            if (![CallViewController canVideo]) {
                return;
            }
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
        }
        
        if (callSession && !error) {
            [[EaseMob sharedInstance].callManager removeDelegate:self];
            
            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO];
            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:callController animated:NO completion:nil];
        }
        
        if (error) {
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            //            [alertView show];
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}
// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = message.messageType ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
#endif
    }
}

//在线透传
-(void)didReceiveCmdMessage:(EMMessage *)message
{
    
    
    EMCommandMessageBody *body = (EMCommandMessageBody *)message.messageBodies.lastObject;
    
    
    
    if ([body.action isEqualToString:CMD_ACTION_NOTICE_ADD]||[body.action isEqualToString:CMD_ACTION_NOTICE_AGREE]||[body.action isEqualToString:CMD_ACTION_NOTICE_REFUSE]) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":message.from, @"username":message.from, @"applyMessage":body.action, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend],@"applicantNick":message.ext[@"content"][@"nick"],@"applicantAvatar":message.ext[@"content"][@"avatar"]}];
        
        [[ApplyViewController shareController] addNewApply:dic];
        
        
        //当对方接受好友申请时刷新
        if([body.action isEqualToString:CMD_ACTION_NOTICE_AGREE]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AGREEINVITATIONFRIEND object:nil];
            
            
            //获取好友数据
            [self getImFriendsData];
        }
        
        
    }else if([body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_REQUEST]||[body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_AGREE]||[body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_REFUSE]||[body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_JOIN]){
        
        int applyStyle;
        
        if ([body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_JOIN]) {
            
            applyStyle=2;
            
        }else{
            
            applyStyle=1;
        }
        
        
        NSString *nikname = (message.ext[@"content"][@"nick"] && [message.ext[@"content"][@"nick"] length] > 0) ? message.ext[@"content"][@"nick"] : @"";
        NSString *avatar = (message.ext[@"content"][@"avatar"] && [message.ext[@"content"][@"avatar"] length] > 0) ? message.ext[@"content"][@"avatar"] : @"";
        NSString *groupname = (message.ext[@"content"][@"groupName"] && [message.ext[@"content"][@"groupName"] length] > 0) ? message.ext[@"content"][@"groupName"] : @"";
        NSString *groupId = (message.ext[@"content"][@"groupId"] && [message.ext[@"content"][@"groupId"] length] > 0) ? message.ext[@"content"][@"groupId"] : @"";
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":message.from, @"username":message.from, @"applyMessage":body.action, @"applyStyle":[NSString stringWithFormat:@"%d",applyStyle],@"applicantNick":nikname,@"applicantAvatar":avatar,@"groupname":groupname,@"groupId":groupId}];
        
        
        [[ApplyViewController shareController] addNewApply:dic];
        
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEAPPLYCOUNT object:nil];
    [self.homeViewController setupUntreatedApplyCount];
    [self playSoundAndVibration];
}

/*!
 @method
 @brief 接收到离线透传消息的回调
 @discussion
 @param offlineCmdMessages 接收到的离线透传消息列表
 @result
 */
- (void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages{
    
    for(EMMessage *cmdDic in offlineCmdMessages){
        
        
        NSLog(@"接收到的离线透传消息列表--%@",cmdDic);
        EMCommandMessageBody *body = (EMCommandMessageBody *)cmdDic.messageBodies.lastObject;
        
        if([body.action isEqualToString:CMD_ACTION_NOTICE_ADD]||[body.action isEqualToString:CMD_ACTION_NOTICE_AGREE]||[body.action isEqualToString:CMD_ACTION_NOTICE_REFUSE]){
            
            NSDictionary *dic = @{@"title":cmdDic.from,@"username":cmdDic.from,@"applyMessage":body.action,@"applyStyle":[NSString stringWithFormat:@"%ld",cmdDic.messageType],@"applicantNick":cmdDic.ext[@"content"][@"nick"],@"applicantAvatar":cmdDic.ext[@"content"][@"avatar"]};
            
            [[ApplyViewController shareController] addNewApply:dic];
            
            //当对方接受好友申请时刷新
            if([body.action isEqualToString:CMD_ACTION_NOTICE_AGREE]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AGREEINVITATIONFRIEND object:nil];
                //获取好友数据
                [self getImFriendsData];
            }
            
            
        }else if([body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_REQUEST]||[body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_AGREE]||[body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_REFUSE]||[body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_JOIN]){
            
            int applyStyle;
            
            if ([body.action isEqualToString:CMD_ACTION_NOTICE_GROUP_JOIN]) {
                
                applyStyle=2;
                
            }else{
                
                applyStyle=1;
            }
            
            
            NSString *nikname = (cmdDic.ext[@"content"][@"nick"] && [cmdDic.ext[@"content"][@"nick"] length] > 0) ? cmdDic.ext[@"content"][@"nick"] : @"";
            NSString *avatar = (cmdDic.ext[@"content"][@"avatar"] && [cmdDic.ext[@"content"][@"avatar"] length] > 0) ? cmdDic.ext[@"content"][@"avatar"] : @"";
            NSString *groupname = (cmdDic.ext[@"content"][@"groupName"] && [cmdDic.ext[@"content"][@"groupName"] length] > 0) ? cmdDic.ext[@"content"][@"groupName"] : @"";
            NSString *groupId = (cmdDic.ext[@"content"][@"groupId"] && [cmdDic.ext[@"content"][@"groupId"] length] > 0) ? cmdDic.ext[@"content"][@"groupId"] : @"";
            
            NSDictionary *dic = @{@"title":cmdDic.from,@"username":cmdDic.from,@"applyMessage":body.action,@"applyStyle":[NSString stringWithFormat:@"%d",applyStyle],@"applicantNick":nikname,@"applicantAvatar":avatar,@"groupname":groupname,@"groupId":groupId};
            
            [[ApplyViewController shareController] addNewApply:dic];
            
        }
        
        
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEAPPLYCOUNT object:nil];
    [self.homeViewController setupUntreatedApplyCount];
    
    [self playSoundAndVibration];
}


//提示震动，铃声
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        
        
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    if ([[userSetting objectForKey:Sound_switch] isEqualToString:@"YES" ]) {
        // 收到消息时，播放音频
        [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    }
    if ([[userSetting objectForKey:Shating_switch] isEqualToString:@"YES"]) {
        // 收到消息时，震动
        [[EMCDDeviceManager sharedInstance] playVibration];
    }
    
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
// 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
    
    
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    NSString *nickName=callSession.sessionChatter;
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        
        
        
    }];
    
    if (callSession.status == eCallSessionStatusConnected)
    {
        
        EMError *error = nil;
        do {
            BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
            if (isShowPicker) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (![self canRecord]) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
#warning 在后台不能进行视频通话
            if(callSession.type == eCallSessionTypeVideo && ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive || ![CallViewController canVideo])){
                
                
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (!isShowPicker){
                
                
                AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                
                
                if(appDelegate.isBackground&&[[userSetting objectForKey:notify_switch] isEqualToString:@"YES"]){
                    
                    
                    if([theCache plistForKey:IMCACHEDATA]){
                        
                        for ( NSDictionary *dic in [NSJSONSerialization JSONObjectWithData:[theCache plistForKey:IMCACHEDATA] options:NSJapaneseEUCStringEncoding error:nil][@"friends"]) {
                            
                            if ([callSession.sessionChatter isEqualToString:dic[@"hxid"]]) {
                                
                                nickName = dic[@"nick"];
                                break;
                            }
                            
                        }
                        
                    }
                    
                    
                    //                发送本地推送
                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                    notification.fireDate = [NSDate date]; //触发通知的时间
                    notification.alertBody = [NSString stringWithFormat:@"%@:%@", nickName, @"请求语音通话"];
                    
                    notification.alertAction = NSLocalizedString(@"open", @"Open");
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    //发送通知
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                }
                
                [[EaseMob sharedInstance].callManager removeDelegate:self];
                CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:YES];
                callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:callController animated:NO completion:nil];
                if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]])
                {
                    ChatViewController *chatVc = (ChatViewController *)self.navigationController.topViewController;
                    chatVc.isInvisible = YES;
                }
            }
        } while (0);
        
        if (error) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReasonHangup];
            return;
        }
    }
}
#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        //        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif
    
    [_msgVC reloadApplyView];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:UPDATEAPPLYCOUNT object:nil];
    
    
    
}

- (void)_removeBuddies:(NSArray *)userNames
{
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:userNames deleteMessages:YES append2Chat:YES];
    [_chatListVC refreshDataSource];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [userNames containsObject:[(ChatViewController *)viewController chatter]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        [self.navigationController setViewControllers:viewControllers animated:YES];
    }
    //    [self showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), userNames[0]]];
}
- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    if (!isAdd)
    {
        NSMutableArray *deletedBuddies = [NSMutableArray array];
        for (EMBuddy *buddy in changedBuddies)
        {
            if ([buddy.username length])
            {
                [deletedBuddies addObject:buddy.username];
            }
        }
        if (![deletedBuddies count])
        {
            return;
        }
        
        [self _removeBuddies:deletedBuddies];
    }
    //    [_msgVC reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
    
    [self _removeBuddies:@[username]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AGREEINVITATIONFRIEND object:nil];
    //获取好友数据
    [self getImFriendsData];
    //    [_msgVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
    //    [_msgVC reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    TTAlertNoTitle(message);
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
    //    [_msgVC reloadDataSource];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
    [_msgVC reloadGroupView];
}

//另一处登录
- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        
        
        //清除用户信息，表示退出登录
        [userSetting removeObjectForKey:userPassword];
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
        
        
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
        LoginViewController *LoginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
        
        
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

//登录环信
-(void)loginIM{
    
    //环信登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[NSString stringWithFormat:@"%@",[userSetting objectForKey:userAccount]]password:[userSetting objectForKey:userPassword] completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            
            //获取群组列表
            [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
            
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            //将2.1.0版本旧版的coredata数据导入新的数据库
            EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
            if (!error) {
                error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                
            }
            
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            
        }
        
    } onQueue:nil];
    
    
    
}

//从服务器获取环信相关数据
-(void)getImFriendsData{
    
    if ([userSetting objectForKey:userAccount] && [userSetting objectForKey:userPassword]) {
        
        NSDictionary *arry=@{@"user":[userSetting objectForKey:userAccount],@"pwd":[userSetting objectForKey:userPassword]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:IMFRIENDSDATA parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *myData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
            
            
            if ([myData[@"code"] intValue]==0) {
                
                [theCache setPlist:responseObject forKey:IMCACHEDATA];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
    
//    NSDictionary *arry=@{@"user":[userSetting objectForKey:userAccount],@"pwd":[userSetting objectForKey:userPassword]};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    
//    [manager GET:IMFRIENDSDATA parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *myData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
//        
//        
//        if ([myData[@"code"] intValue]==0) {
//            
//            [theCache setPlist:responseObject forKey:IMCACHEDATA];
//            
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
}

- (void)dealloc
{
    [self unregisterNotifications];
}

#pragma mark - public

- (void)jumpToMessageView
{
    if(_msgVC)
    {
        //[self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_msgVC];
    }
}


/**
 *  分享
 *
 *  @param dic 参数
 
 parame[@"img"]    图片
 parame[@"title"]  标题
 parame[@"desc"]   描述
 parame[@"url"]    要分享的URL（不能为空）
 */

+(void)theShareSDK:(NSDictionary  *)dic{

        NSString *imagePath =   [NSString stringWithFormat:@"%@",dic[@"img"]? dic[@"img"]:@""];
        NSString *theTitle =    [NSString stringWithFormat:@"%@",dic[@"title"]? dic[@"title"]:@""];
        NSString *theDesc =     [NSString stringWithFormat:@"%@",dic[@"desc"]? dic[@"desc"]:@""];
        NSString *shareURL =    [NSString stringWithFormat:@"%@",dic[@"url"]? dic[@"url"]:@""];
    
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:theDesc
                                           defaultContent:nil
                                                    image:[ShareSDK imageWithUrl:imagePath]
                                                    title:theTitle
                                                      url:shareURL
                                              description:theTitle
                                                mediaType:SSPublishContentMediaTypeNews];
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
    
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    }
                                }];
        
        
}

-(void)theWIFI{
    
    AppDelegate *delget=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    reach.reachableBlock = ^(Reachability *reach){
        
        if([reach currentReachabilityStatus] == ReachableViaWiFi){
            
            
            delget.isWIFI=@"WIFI";
            
            
        }else {
            
            delget.isWIFI=@"noWIFI";
        }
        
    };
    
    reach.unreachableBlock = ^(Reachability *reach){
        
        [self showHint:@"请检查您当前的网络连接状况"];
        
    };
    
    [reach startNotifier];
}

@end
