//
//  addMakeController.m
//  ISQ
//
//  Created by mac on 15-5-3.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "addMakeController.h"
#import "AddFriendViewController.h"
#import "PublicGroupListViewController.h"
#import "NeighborsTableCell.h"
#import "AddNeighborsController.h"
#import "FindFriendsController.h"
#import "CreateGroupViewController.h"
@interface addMakeController (){
    
    NeighborsTableCell *cell;
}

@end

@implementation addMakeController
@synthesize addTableview;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row%2==0) {
        
        return 10;
    }
    
    return 44;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row%2==0) {
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"addFriendsCell2" forIndexPath:indexPath];
    }
    else {
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"addFriendsCell1" forIndexPath:indexPath];
        
        if (indexPath.row==1) {
            cell.addFriendsLable.text=@"加好友";
        }
        else if (indexPath.row==3) {
            cell.addFriendsLable.text=@"找邻居";
            
        }
        else if (indexPath.row==5) {
            cell.addFriendsLable.text=@"找通讯录好友";
            
        }
        else if (indexPath.row==7) {
            cell.addFriendsLable.text=@"加群组";
            
        }else if (indexPath.row==9) {
            
            cell.addFriendsLable.text=@"创建群";
        }
        
        
        cell.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
        cell.layer.borderWidth=0.5f;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.addTableview deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *stord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    if (indexPath.row==1) {
        
        AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:addController animated:YES];
    }
    else if(indexPath.row==3){
        
        AddNeighborsController *addNeighborsVC=[stord instantiateViewControllerWithIdentifier:@"AddNeighborsController"];
        [self.navigationController pushViewController:addNeighborsVC animated:YES];
       
        
    }
    else if (indexPath.row==5){
        
        FindFriendsController *FindFriendsVC=[stord instantiateViewControllerWithIdentifier:@"FindFriendsController"];
        [self.navigationController pushViewController:FindFriendsVC animated:YES];
        
        
    }
    else if (indexPath.row==7){
        
        
        
        
        PublicGroupListViewController *publicController = [[PublicGroupListViewController alloc] initWithStyle:UITableViewStylePlain];
        
        [self.navigationController pushViewController:publicController animated:YES];
    }
    else if (indexPath.row==9){
        
       
        
        CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
        [self.navigationController pushViewController:createChatroom animated:YES];
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


- (IBAction)back_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
