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





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
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
        cell.useravatar.layer.borderWidth = 2.0;
        cell.useravatar.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.userName.text=[user_info objectForKey:userNickname];
        if([user_info objectForKey:MYSELFHEADNAME]){
            NSURL *imgUrl=[[NSURL alloc]initWithString:[user_info objectForKey:MYSELFHEADNAME]];
            [cell.useravatar setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
            if ([ImgURLisFount TheDataIsImgage:cell.useravatar.image]==2) {
            }else{
                cell.useravatar.image=[UIImage imageNamed:@"defuleImg"];
            }}else{
            cell.useravatar.image=[UIImage imageNamed:@"defuleImg"];
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
            cell.myIocn.image = [UIImage imageNamed:@"liwu"];
            cell.ContName.text = @"我的礼物";
            
        }else if (indexPath.row == 8){
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
        PersonalDataViewController *personalDataVC = [storyBoard instantiateViewControllerWithIdentifier:@"personalData"];
        [personalDataVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:personalDataVC animated:YES];
        
    }else if(indexPath.row == 4){
        MyActivityViewController *myActivityVC = [storyBoard instantiateViewControllerWithIdentifier:@"myactivity"];
        [myActivityVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:myActivityVC animated:YES];
        
    }else if (indexPath.row == 5){
//        MyFavoriteViewController *myFavorite = [storyBoard instantiateViewControllerWithIdentifier:@"myfavorite"];
//        [myFavorite setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:myFavorite animated:YES];
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"您所在的社区暂未开放此项功能" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView1 show];
        
    }else if (indexPath.row == 6){
        
        UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"您所在的社区暂未开放此项功能" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView2 show];
        

        
    }else if (indexPath.row == 8){
        SettingViewController *myCollectionVC=[storyBoard instantiateViewControllerWithIdentifier:@"Mysetting"];
        [self.navigationController pushViewController:myCollectionVC animated:NO];
    }
}




- (IBAction)signButton:(id)sender {
    
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    GetCoinViewController *getCoinVC = [storyBoard instantiateViewControllerWithIdentifier:@"getconiinfo"];
//    [getCoinVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:getCoinVC animated:YES];
    
    UIAlertView *alertView3 = [[UIAlertView alloc] initWithTitle:@"您所在的社区暂未开放此项功能" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView3 show];
}


@end
