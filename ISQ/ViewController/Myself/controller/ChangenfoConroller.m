//
//  ChangenfoConroller.m
//  ISQ
//
//  Created by mac on 15-4-2.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ChangenfoConroller.h"
#import "ChangeInfoCell.h"
#import "AddNewAddress.h"
#import "AppDelegate.h"
#import "CommunitySelectController.h"
#import "CitySelectController.h"
@interface ChangenfoConroller (){
    
    NSDictionary *returnString;
    ChangeInfoCell *cell;
}

@end

@implementation ChangenfoConroller
@synthesize NikeNameSave_ol,changeMyInfoTableview,change_back_ol;
NSArray* newChangeData;


//-(instancetype)initWithFromMyCommunity:(NSArray *)myCommunity{
//    
//    newChangeData=myCommunity;
//    
//    return self;
//}

-(void)setTheUserChangeData:(NSArray*)oldUserChangeData{
    
    if (_theUserChangeData!=oldUserChangeData) {
        _theUserChangeData=oldUserChangeData;
        newChangeData=[self.theUserChangeData copy];
    }    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[newChangeData objectAtIndex:0];
    if ([[newChangeData objectAtIndex:0] isEqualToString:@"昵称"]||[[newChangeData objectAtIndex:0] isEqualToString:@"签名"]) {
        
        self.NikeNameSave_ol.hidden=NO;
    }
//    if ([[newChangeData objectAtIndex:0] isEqualToString:@"我的社区"]) {
//        
//        if ([[newChangeData objectAtIndex:2] isEqualToString:@"我的社区1"]) {
//        
//            [self.change_back_ol setImage:[UIImage imageNamed:@"back_img"] forState:UIControlStateNormal];
//            
//            //颜色
////            [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"" size:23.0],NSFontAttributeName,nil]];
//           
//        
//        }
//        
//        
//        
//    }
    
   }

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    
//    if ([[newChangeData objectAtIndex:0] isEqualToString:@"我的社区"]) {
//        
//        
//        return 2;
//    }
//    
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([[newChangeData objectAtIndex:0] isEqualToString:@"昵称"]) {
        
        return 1;
        
    }
//    else if([[newChangeData objectAtIndex:0] isEqualToString:@"社区号"]){
//        
//        return 1;
//        
//    }
    else if([[newChangeData objectAtIndex:0] isEqualToString:@"签名"]){
        
        return 1;
        
//    }else if([[newChangeData objectAtIndex:0] isEqualToString:@"我的社区"]){
//        
//        return 1;
//        
//    }else if([[newChangeData objectAtIndex:0] isEqualToString:@"我的收货地址"]){
//        
//        return 5+1;
//        
    }
        else if([[newChangeData objectAtIndex:0] isEqualToString:@"性别"]){
        return 2;
       
        
    }
//        else if([[newChangeData objectAtIndex:0] isEqualToString:@"地区"]){
//        
//        return 1;
//        
//    }

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[newChangeData objectAtIndex:0] isEqualToString:@"昵称"]) {
        
        return 45;
        
    }
//    else if([[newChangeData objectAtIndex:0] isEqualToString:@"社区号"]){
//        
//        return 45;
//        
//    }
    else if([[newChangeData objectAtIndex:0] isEqualToString:@"签名"]){
        
        return 66;
        
    }
//    else if([[newChangeData objectAtIndex:0] isEqualToString:@"我的社区"]){
//        
//        if (indexPath.section==0) {
//            return 55;
//        }else {
//            
//            return 40;
//        }
//        
//    }else if([[newChangeData objectAtIndex:0] isEqualToString:@"我的收货地址"]){
//        if (indexPath.row==0) {
//            return 45;
//        }
//        
//        return 62;
//        
//    }
    else if([[newChangeData objectAtIndex:0] isEqualToString:@"性别"]){
        return 45;
        
        
    }
//    else if([[newChangeData objectAtIndex:0] isEqualToString:@"地区"]){
//        
//        return 45;
//        
//    }

    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[newChangeData objectAtIndex:0] isEqualToString:@"昵称"]) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"NikeNameCell" forIndexPath:indexPath];
        cell.NikeNameEd.text=[newChangeData objectAtIndex:1];
        cell.NikeNameEd.delegate=self;
        
    }
//    else if([[newChangeData objectAtIndex:0] isEqualToString:@"社区号"]){
//         cell=[tableView dequeueReusableCellWithIdentifier:@"NumberCell" forIndexPath:indexPath];
//        cell.CounNunber.text=[newChangeData objectAtIndex:1];
//        
//    }
    else if([[newChangeData objectAtIndex:0] isEqualToString:@"签名"]){
         cell=[tableView dequeueReusableCellWithIdentifier:@"Signature" forIndexPath:indexPath];
        cell.SigatureEd.text=[newChangeData objectAtIndex:1];
        
    }
    else if([[newChangeData objectAtIndex:0] isEqualToString:@"我的社区"]){
        
        if(indexPath.section==0){
            cell=[tableView dequeueReusableCellWithIdentifier:@"Community" forIndexPath:indexPath];
            cell.CommunityLable.text=[newChangeData objectAtIndex:1];
            
           
        }
//        else{
//            cell=[tableView dequeueReusableCellWithIdentifier:@"Community2" forIndexPath:indexPath];
//            
//            cell.CommunityFromNet.text=[NSString stringWithFormat:@"更改社区"];
//            
//            
//        }
//        
//        
//    }else if([[newChangeData objectAtIndex:0] isEqualToString:@"我的收货地址"]){
//        
//        if (indexPath.row==0) {
//            cell=[tableView dequeueReusableCellWithIdentifier:@"Myaddress" forIndexPath:indexPath];
//        }
//        else{
//            
//            cell=[tableView dequeueReusableCellWithIdentifier:@"Myaddress2" forIndexPath:indexPath];
//            
//            cell.adressName.text=[NSString stringWithFormat:@"姓名%ld",(long)indexPath.row];
//            
//        }
//        
//        
    }
    else if([[newChangeData objectAtIndex:0] isEqualToString:@"性别"]){
         cell=[tableView dequeueReusableCellWithIdentifier:@"SexCell" forIndexPath:indexPath];
    
    if (indexPath.row==0) {
            cell.SexLable.text=@"男";
            
        }else if(indexPath.row==1){
            cell.SexLable.text=@"女";
            
        }
        if (indexPath.row==0&&[[newChangeData objectAtIndex:1] isEqualToString:@"男"]) {
            cell.SexChosebg.hidden=NO;
        }else if(indexPath.row==1&&[[newChangeData objectAtIndex:1] isEqualToString:@"女"]){
            cell.SexChosebg.hidden=NO;
        }
        
        
    }
//    else if([[newChangeData objectAtIndex:0] isEqualToString:@"地区"]){
//        
//         cell=[tableView dequeueReusableCellWithIdentifier:@"MyPlace" forIndexPath:indexPath];
//        
//            cell.myPlace_lable.text=[newChangeData objectAtIndex:1];
// 
//    }
    
    cell.layer.borderWidth=0.5f;
    cell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.changeMyInfoTableview deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([[newChangeData objectAtIndex:0] isEqualToString:@"性别"]) {
        
        if (indexPath.row==0) {
            
            //更改性别
            [self changeHttpClink:@"5" :@"0"];
        }else {
            
            //更改性别
            [self changeHttpClink:@"5" :@"1"];
            
        }
        
        
        [self.navigationController popViewControllerAnimated:NO];
    }
//    else if([newChangeData[0] isEqualToString:@"我的社区"]){
//        
//        saveCityName=[NSUserDefaults standardUserDefaults];
//        
//        if([saveCityName objectForKey:userCityName]){
//            
//            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
//            CitySelectController *citySelectVC=[storyBoard instantiateViewControllerWithIdentifier:@"SelectCommunityId"];
//            
//            [citySelectVC setHidesBottomBarWhenPushed:YES];
//            [self.navigationController  pushViewController:citySelectVC animated:YES];
//            
//        }else{
//            
//            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
//            CitySelectController *citySelectVC=[storyBoard instantiateViewControllerWithIdentifier:@"SeclecticCityId"];
//            
//            [citySelectVC setHidesBottomBarWhenPushed:YES];
//            [self.navigationController  pushViewController:citySelectVC animated:YES];
//            
//        }
//
//        
//    
//    }
    
}

/*
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{

     NSArray * addressInfo=[[NSArray alloc] initWithObjects:@"编辑收货地址",nil];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddNewAddress *addNewVC=[[storyBoard instantiateViewControllerWithIdentifier:@"AddNewAddress_storyboard"]initWithAddressInfo:addressInfo] ;
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.5f;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromTop;
    
    transition.delegate = self;
    
    [addNewVC.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:addNewVC animated:NO];
 
}

 */


//更改请求
-(void)changeHttpClink:(NSString*)HttpType:(NSString*)str{
    
    //用户信息缓存器
    NSString *http=[requestTheCodeURL stringByAppendingString:@"changeproperty"];
    NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pnum":HttpType,@"pv":str};
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSData *thaData = responseObject;
        returnString=  [NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil];
        
        //更改一次信息，重新获取一次
//        AppDelegate *delget=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        [delget ToObtainInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"修改失败，请检查网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{


    
    //不能输入特殊字符（延迟0.01s）
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(niknameTvTest) userInfo:nil repeats:NO];

    return YES;

}


//昵称输入的特殊字符会过滤掉
-(void)niknameTvTest{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@ ,.!／/：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    
    NSString *trimmedString = [cell.NikeNameEd.text stringByTrimmingCharactersInSet:set];
    cell.NikeNameEd.text=trimmedString;
}

- (IBAction)NikeNameSave_bt:(id)sender {
    
    
    
    
    if([newChangeData[0] isEqualToString:@"昵称"]){
        
        
        //更改昵称请求
        [self changeHttpClink:@"1":cell.NikeNameEd.text];
        
    }else if ([newChangeData[0] isEqualToString:@"签名"]){
        
        //更改签名请求
        [self changeHttpClink:@"4":cell.SigatureEd.text];
        
    }
    
    if ([returnString isEqual:@"1"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    
    }else {
        
        
    }
  
    
}

- (IBAction)Change_back_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
