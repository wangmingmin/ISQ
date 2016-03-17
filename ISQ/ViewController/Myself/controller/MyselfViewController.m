//
//  MyselfViewController.m
//  ISQ
//
//  Created by mac on 15-3-27.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MyselfViewController.h"
#import "MyselfCell.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "UserInfoController.h"
#import "ApplyViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ImgURLisFount.h"
#import "PersonalDataViewController.h"
#import "GetCoinViewController.h"
#import "SeconWebController.h"
#import "MyActivityViewController.h"
#import "MyFavoriteViewController.h"
#import "AppDelegate.h"

@interface MyselfViewController (){
    
   
    EGOCache *theCache;
   

}

@end

@implementation MyselfViewController
@synthesize theTableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    theCache=[[EGOCache alloc]init];
    
    
}




#pragma mark - tableView delagate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1||indexPath.row == 3||indexPath.row == 7){
        return 10;
    }else if (indexPath.row==0){
        
        return 150;
    }
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyselfCell *cell;
    if(indexPath.row==0){
        cell=[tableView dequeueReusableCellWithIdentifier:@"MyselfCell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.useravatar.layer.masksToBounds = YES;
        cell.useravatar.layer.cornerRadius = 75/2;
        cell.useravatar.layer.borderColor = [UIColor whiteColor].CGColor;
       
        //已登陆与未登录两种状态
        if ([user_info objectForKey:userAccount] && [user_info objectForKey:userPassword]) {
             cell.statusLabel.text = [user_info objectForKey:userNickname];
            if([user_info objectForKey:MYSELFHEADNAME]){
                NSURL *imgUrl=[[NSURL alloc]initWithString:[user_info objectForKey:MYSELFHEADNAME]];
                [cell.useravatar setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"personalData"]];
                if ([ImgURLisFount TheDataIsImgage:cell.useravatar.image]==2) {
                }else{
                    cell.useravatar.image = [UIImage imageNamed:@"personalData"];
                }}else{
                    cell.useravatar.image=[UIImage imageNamed:@"personalData"];
                }
        }else{
        
        cell.useravatar.image = [UIImage imageNamed:@"personalData"];
        cell.statusLabel.text = @"立刻登陆";
        cell.statusLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateButtonAction:)];
        [cell.statusLabel addGestureRecognizer:tap];
        }
        
    }else if(indexPath.row == 1||indexPath.row == 3||indexPath.row == 7){
        cell=[tableView dequeueReusableCellWithIdentifier:@"MyselfCell2" forIndexPath:indexPath];
        
    }else if(indexPath.row == 2||indexPath.row == 4||indexPath.row == 5||indexPath.row == 6||indexPath.row == 8){
        cell=[tableView dequeueReusableCellWithIdentifier:@"MyselfCell3" forIndexPath:indexPath];
        if (indexPath.row == 2){
            cell.myIocn.image = [UIImage imageNamed:@"my1"];
            cell.ContName.text = @"个人信息";
        }else if (indexPath.row == 4){
            cell.myIocn.image = [UIImage imageNamed:@"my2"];
            cell.ContName.text = @"我的活动";
        }else if (indexPath.row == 5){
            cell.myIocn.image=[UIImage imageNamed:@"my3"];
            cell.ContName.text=@"我的收藏";
        }else if (indexPath.row == 6){
            cell.myIocn.image = [UIImage imageNamed:@"my4"];
            cell.ContName.text = @"设置";
        }
    }
    
    cell.layer.borderWidth=0.5f;
    cell.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0) {
       
    }
    else if(indexPath.row == 2){
        
        if ([user_info objectForKey:userAccount] && [user_info objectForKey:userPassword]) {
            
            PersonalDataViewController *personalDataVC = [storyBoard instantiateViewControllerWithIdentifier:@"personalData"];
            [personalDataVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:personalDataVC animated:YES];
        }else{
        
        UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"登陆后可查看" message:@"立刻登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
            
        }
       
        
    }else if(indexPath.row == 4){
        
        if ([user_info objectForKey:userAccount] && [user_info objectForKey:userPassword]){
        
            MyActivityViewController *myActivityVC = [storyBoard instantiateViewControllerWithIdentifier:@"myactivity"];
            [myActivityVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myActivityVC animated:YES];
        }else{
        
        UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"登陆后可查看" message:@"立刻登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
        }
        
    }else if (indexPath.row == 5){

        if ([user_info objectForKey:userAccount] && [user_info objectForKey:userPassword]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您所在的社区暂未开放此项功能" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
        }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登陆后可查看" message:@"立刻登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
        }
        
    }else if (indexPath.row == 6){ 
        
        SettingViewController *myCollectionVC=[storyBoard instantiateViewControllerWithIdentifier:@"Mysetting"];
        [self.navigationController pushViewController:myCollectionVC animated:NO];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
        LoginViewController *loginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)stateButtonAction:(id *)sender{
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
    LoginViewController *loginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
