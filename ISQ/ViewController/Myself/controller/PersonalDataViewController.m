//
//  PersonalDataViewController.m
//  ISQ
//
//  Created by mac on 15-10-6.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalTableViewCell.h"
#import "UserInfoController.h"
#import "ChangenfoConroller.h"
#import "CommunityViewController.h"
#import "ChangePassWordViewController.h"
#import "ProvinceSelectController.h"

@interface PersonalDataViewController (){

    NSString *communityName;
}

@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.userdataTabelView.dataSource = self;
    self.userdataTabelView.delegate = self;
    self.userdataTabelView.tableFooterView = [[UIView alloc] init];
    if ([self.userdataTabelView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.userdataTabelView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.userdataTabelView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.userdataTabelView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"" size:23.0],NSFontAttributeName,nil]];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PersonalTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:@"personalcell" forIndexPath:indexPath];
    if (indexPath.row == 0){
        cell.myIcon.image = [UIImage imageNamed:@"personalData"];
        cell.contname.text = @"个人资料";
    }else if (indexPath.row == 1){
        cell.myIcon.image = [UIImage imageNamed:@"changePassword"];
        cell.contname.text = @"修改密码";
    }else if (indexPath.row == 2){
        cell.myIcon.image = [UIImage imageNamed:@"house"];
        cell.contname.text = @"修改社区";
    }
    cell.layer.borderWidth=0.5f;
    cell.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0) {
        UserInfoController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"userInfo"];
        [self.navigationController pushViewController:userInfoVC animated:YES];
        
    }else if (indexPath.row == 1){
        ChangePassWordViewController *changePasswordVC = [storyBoard instantiateViewControllerWithIdentifier:@"forgotPassWord"];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
        
    }else if (indexPath.row == 2){
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
        ProvinceSelectController *citySelectVC = [storyBoard instantiateViewControllerWithIdentifier:@"SeclecticCityId"];
        [citySelectVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController  pushViewController:citySelectVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
