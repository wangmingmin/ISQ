//
//  AccountSecurityView.m
//  ISQ
//
//  Created by mac on 15-4-8.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "AccountSecurityView.h"
#import "UserInfoCell.h"
#import "AccountDetailController.h"
#import "ChangePhoneNumController.h"
@interface AccountSecurityView ()
@end

@implementation AccountSecurityView
@synthesize securityTableview;
- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==1||indexPath.row==3) {
        return 10;
    }
    return 44;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfoCell *cell;
    
    if (indexPath.row==1||indexPath.row==3) {
        cell= [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    }else if(indexPath.row==0){
         cell= [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        cell.userIsqCodelable.text=[user_info objectForKey:userIsqCode];
       
    }else if (indexPath.row==2){
        cell= [tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
        cell.myPhoneNumber.text=[user_info objectForKey:userAccount];
        
    }
//    else {
//        cell= [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
//    }
    
    if (indexPath.row==0||indexPath.row==2) {
        cell.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.4f].CGColor;
        cell.layer.borderWidth=0.5f;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
       
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([[segue identifier] isEqualToString:@"changeAccountSegue"]) {
    
        
//         if(indexPath.row==3){
//            
//            [[segue destinationViewController] setFromAccountData:@[@"邮箱地址",@""]];
//        }else
        
//    if ([[segue identifier] isEqualToString:@"thePassWordChangeSegue"]) {
//        
//        [[segue destinationViewController] setFromAccountData:@[@"账号密码",@""]];
//    }
    
       
//    }
    
}


- (IBAction)accountSecurity_back_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
