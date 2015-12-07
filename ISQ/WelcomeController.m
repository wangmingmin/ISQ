//
//  WelcomeController.m
//  ISQ
//
//  Created by mac on 15-4-28.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "WelcomeController.h"
#import "WelcomeTableViewCell.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "SeconWebController.h"


@interface WelcomeController ()<UITableViewDataSource,UITableViewDelegate>{
    
    WelcomeTableViewCell *cell;
    NSTimer *theTime;
    NSDictionary *welcomeAdData;
    AppDelegate *bannerDeletage;
}

@end

@implementation WelcomeController
@synthesize  welcomeTableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    theTime=[NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(toStart) userInfo:nil repeats:NO];
    //welcome广告图
//    [self welcomeAdHttp];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    self.navigationController.navigationBar.hidden=YES;
}

//已经登陆过则进入主界面，未登录则进入登录界面
-(void)toStart{
    
    if ([user_info objectForKey:userPassword]&&[user_info objectForKey:userAccount]) {
        UIStoryboard *mainStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *mainVC=[mainStory instantiateViewControllerWithIdentifier:@"MainViewStory"];
        self.navigationController.navigationBar.hidden=YES;
        [self.navigationController pushViewController:mainVC animated:YES];

    }else {
        
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
        LoginViewController *loginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

 //welcome广告图
-(void)welcomeAdHttp{

    NSString *http=[getHomePic stringByAppendingString:@"getcover"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:http parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        welcomeAdData=  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
        
        
        
        [self.welcomeTableview reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      
    
    }];

}



-(void)viewWillDisappear:(BOOL)animated{
    
    [theTime invalidate];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (indexPath.row==0) {
//        return UISCREENHEIGHT*0.80809;
//    }
    
    return UISCREENHEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"welcomeCell1" forIndexPath:indexPath];

        if (welcomeAdData.count>0) {
            
            //创建内容对象
            NSURL *theUrl=[NSURL URLWithString:[theImgURL stringByAppendingString:welcomeAdData[@"coverTitlepic"]]];
            [cell.welcomeImg setImageWithURL:theUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        }
        
    }
//    else {
//        cell=[tableView dequeueReusableCellWithIdentifier:@"welcomeCell2" forIndexPath:indexPath];
//        
//    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.welcomeTableview deselectRowAtIndexPath:indexPath animated:YES];
    [self toStart];
//    if (indexPath.row==1) {
//        
////        [self toStart];
//        
//    }else
    
//        if(indexPath.row==0){
//        
//        NSString *webUrlRequestStr=@" ";
//        
//        if (welcomeAdData.count>0) {
//            
//            if (welcomeAdData[@"coverTitleurl"]!=nil) {
//                
//               webUrlRequestStr=welcomeAdData[@"coverTitleurl"];
//                
//            }else{
//                
//                webUrlRequestStr =[NSString stringWithFormat:@"%@id/%@/type/%@",WhenNoUrlAd,welcomeAdData[@"coverId"],@"0"];
//                
//            }
//            
//        }
    
        
//        
//        UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SeconWebController *seconWebVC=[board instantiateViewControllerWithIdentifier:@"SeconWebController"];
//        
//      seconWebVC.theUrl=webUrlRequestStr;
//        [self.navigationController pushViewController:seconWebVC animated:YES];

        
//    }
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    return NO;
}

-(void)dealloc{
    
    [self.welcomeTableview removeFromSuperview];
    
}

@end
