//
//  MySettingView.m
//  ISQ
//
//  Created by mac on 15-4-8.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "SettingViewController.h"
#import "LocationSettingCell.h"
#import "ApplyViewController.h"
#import "LoginViewController.h"
#import "SDImageCache.h"
#import "SettingVersionCell.h"
#import "UMessage.h"

@interface SettingViewController (){
    
    EGOCache *theCache;
   
    UIAlertView *alert1;
    UIAlertView *alert2;
    UIAlertView *alert3;
    UIAlertView *alert4;
    NSString *trackViewUrl;
    NSString *imagePath;
    NSString * nowVersion;
    //存储文件大小
    long long sum;
}


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    theCache=[[EGOCache alloc]init];
    self.title = @"设置";
    NSDictionary *infoDictionary =[[NSBundle mainBundle]infoDictionary];
    nowVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    [[ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleDefault ];
    self.tabBarController.tabBar.hidden=YES;
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self CacheSize];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


//计算本地缓存
- (void)CacheSize{
    
    //每次调用清空
    sum = 0;
    //取得缓存路径
    imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.hackemist.SDWebImageCache.default"];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    //将相应路径所以文件名放到数组中
    NSArray *fileNames = [fileManger subpathsOfDirectoryAtPath:imagePath error:nil];
    for (NSString *name in fileNames) {
        //取得图片路径
        NSString *filePath = [imagePath stringByAppendingPathComponent:name];
        //获取相应图片的属性
        NSDictionary *attributesDic = [fileManger attributesOfItemAtPath:filePath error:nil];
        //取得文件大小
        long long size = [attributesDic fileSize];
        sum += size;
    }
    
    [self.settingTableView reloadData];
}


#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 130;
    }else if (indexPath.row == 4 ) {
        return 8;
    }
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LocationSettingCell *cell;
    if (indexPath.row == 0) {
        SettingVersionCell *versioncell = [tableView dequeueReusableCellWithIdentifier:@"versioncell" forIndexPath:indexPath];
        versioncell.versionLabel.text = [NSString stringWithFormat:@"%@  V%@",@"爱社区",nowVersion];
        return versioncell;
    }else if (indexPath.row == 1) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"SettingCell0" forIndexPath:indexPath];
    }else if (indexPath.row == 2){
        cell=[tableView dequeueReusableCellWithIdentifier:@"SettingCell1" forIndexPath:indexPath];
    }else if (indexPath.row == 3){
        cell=[tableView dequeueReusableCellWithIdentifier:@"SettingCell2" forIndexPath:indexPath];
    }else if (indexPath.row == 4 ){
        cell=[tableView dequeueReusableCellWithIdentifier:@"SettingCell3" forIndexPath:indexPath];
    }else if (indexPath.row == 5){
        cell=[tableView dequeueReusableCellWithIdentifier:@"SettingCell4" forIndexPath:indexPath];
        cell.labelText.text = @"清除缓存";
        float size = sum/(1024*1024.0);
        cell.detailLabel.text = [NSString stringWithFormat:@"%.1fM",size];
    }else if (indexPath.row == 6){
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell5" forIndexPath:indexPath];
    }
    cell.layer.borderWidth=0.5f;
    cell.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
    if (indexPath.row == 6) {
        cell.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 5){
        
        if (sum/(1024*1024.0) >0.0) {
            
            alert3 = [[UIAlertView alloc] initWithTitle:@"是否确定清除当前缓存"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"确定", nil];
            alert3.tag = 902;
            
            [alert3 show];
        }
    }else if (indexPath.row == 6){
        
        if ([user_info objectForKey:userAccount] && [user_info objectForKey:userPassword]) {
        
            alert4 = [[UIAlertView alloc] initWithTitle:@"是否退出登录?"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"退出登录", nil];
            
            alert4.tag = 903;
            
            [alert4 show];
            
        }else{
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登录哦~" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
       
    }
}

#pragma mark - UIAlertView dalegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   if (buttonIndex == 1){
       
       if (alertView.tag == 903) {
           [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
           [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
               [self hideHud];
               if (error && error.errorCode != EMErrorServerNotLogin) {
                   
//                   [self showHint:error.description];
                   
               }else{
//                   NSString * string_id = [user_info objectForKey:MyUserID];
//                   [UMessage removeAlias:string_id type:AliasTypeForUM response:nil];//删除友盟别名绑定
                   [user_info removeObjectForKey:userPassword];
                   [user_info removeObjectForKey:MyUserID];
                   if([theCache plistForKey:IMCACHEDATA]){
                       [theCache removeCacheForKey:IMCACHEDATA];
                   }
//                   //清除UIWebView的缓存
//                   [[NSURLCache sharedURLCache] removeAllCachedResponses];
//                   //清除cookies
//                   NSHTTPCookie *cookie;
//                   
//                   NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//                   for (cookie in [storage cookies])
//                   {
//                       [storage deleteCookie:cookie];
//                   }
                   
                   [[ApplyViewController shareController] clear];
                   [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                   UIStoryboard *registerStory=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
                   LoginViewController *loginVC=[registerStory instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
                   [loginVC setHidesBottomBarWhenPushed:YES];
                   [self.navigationController pushViewController:loginVC animated:NO];
               }
           } onQueue:nil];
           
       }else if (alertView.tag == 900){
       
           UIApplication *appllication = [UIApplication sharedApplication];
           [appllication openURL:[NSURL URLWithString:trackViewUrl]];
           
       }else if (alertView.tag == 902){
           [self showHudInView:self.view hint:@"正在清除..."];
           //清理缓存文件
           NSFileManager *fileManager=[NSFileManager defaultManager];
           if ([fileManager fileExistsAtPath:imagePath]) {
               NSArray *childerFiles=[fileManager subpathsAtPath:imagePath];
               for (NSString *fileName in childerFiles) {

                   NSString *absolutePath=[imagePath stringByAppendingPathComponent:fileName];
                   [fileManager removeItemAtPath:absolutePath error:nil];
               }
           }
           
           [[SDImageCache sharedImageCache] cleanDisk];
           
           [self CacheSize];
           [self hideHud];
           [self.settingTableView reloadData];
       }

    }
}


- (IBAction)SettingBack_bt:(id)sender {
    
    //状态栏字体颜色
    [[ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleLightContent ];
    self.tabBarController.tabBar.hidden=NO;
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popToRootViewControllerAnimated:YES ];
}


@end
