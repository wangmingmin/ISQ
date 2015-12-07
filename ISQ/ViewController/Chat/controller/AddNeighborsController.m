//
//  AddNeighborsController.m
//  ISQ
//
//  Created by mac on 15-5-14.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "AddNeighborsController.h"
#import "UIImageView+AFNetworking.h"
#import "NeighborsTableCell.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "ChatListCell.h"
#import "ImgURLisFount.h"
#import "CmdDealWith.h"



@interface AddNeighborsController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    NeighborsTableCell *cell;
    NSArray *neighborData;
    UITableViewCell *sCell;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchData;
    
}
@property (nonatomic, strong) UISearchBar *searchBar;



@end



@implementation AddNeighborsController
@synthesize AddNeighborsTableview,dfdf;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchData=[[NSMutableArray alloc]init];
    
    
    //获取本社区的人
   [self getMineCommunity];
    
    UISearchBar *friends_seachview = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44)];
    friends_seachview.delegate=self;
    friends_seachview.backgroundImage=[UIImage imageNamed:@"searchBg"];
    friends_seachview.placeholder = @"手机号";
    // 添加 searchbar 到 headerview
    self.AddNeighborsTableview.tableHeaderView = friends_seachview;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:friends_seachview contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;

}


-(void)getMineCommunity{
    
    
    NSDictionary *arry=@{@"ua":[user_info objectForKey:userAccount],@"cid":[user_info objectForKey:userCommunityID]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:FINDNEIGBOR parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
      
        neighborData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
       
       
        
        [self.AddNeighborsTableview reloadData];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(tableView==self.AddNeighborsTableview){
        
        return 3;
    }else if(searchDisplayController){
        
        return 1;
    }
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.AddNeighborsTableview) {
        
        if (section==0||section==1) {
            return 1;
        }
        
        return neighborData.count;
    }else if (searchDisplayController){
        
        
        
        
        return searchData.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.AddNeighborsTableview) {
        
        if (indexPath.section==0) {
            return 22;
        }
        else if (indexPath.section==1){
            
            return 49;
        }else{
            
            
            return 64;
        }

    }
    
    return 64;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    if (tableView==self.AddNeighborsTableview) {
        
        
        if (indexPath.section==0) {
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"addNeighborsCell1" forIndexPath:indexPath];
            
            
        }
        else if (indexPath.section==1){
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"addNeighborsCell2" forIndexPath:indexPath];
            
            if ([user_info objectForKey:saveCommunityName]) {
                
                cell.communityName.text=[user_info objectForKey:saveCommunityName];
            }
             
            
        }else {
            
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"addNeighborsCell3" forIndexPath:indexPath];
            
            if (neighborData.count>0) {
                
                cell.add_ol.tag=indexPath.row;
                cell.dataSource=neighborData[indexPath.row];
                cell.myAcount=[user_info objectForKey:userAccount];
                [cell.add_ol addTarget:self action:@selector(addNeighbors:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }

        
        return  cell;
    }else if (searchDisplayController&&tableView!=self.AddNeighborsTableview){
        sCell=[[UITableViewCell alloc]init];
        
        
      UIImageView *searchImg=[[UIImageView alloc]initWithFrame:CGRectMake(14, 9, 45, 45)];
        searchImg.layer.cornerRadius=4.0f;
        searchImg.layer.masksToBounds=YES;
        NSURL *imgUrl=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",searchData[indexPath.row][@"avatar"]]];
            
            [searchImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        if ([ImgURLisFount TheDataIsImgage:searchImg.image]==2) {
            
            
        }else{
            
            searchImg.image=[UIImage imageNamed:@"defuleImg"];
            
        }
        
        
      UILabel *searchLable1=[[UILabel alloc]initWithFrame:CGRectMake(63, 10, 0.629*UISCREENWIDTH, 26)];
        searchLable1.font=[UIFont  fontWithName:@"" size:17];
        searchLable1.text=searchData[indexPath.row][@"nick"];
        
        UILabel *searchLable2=[[UILabel alloc]initWithFrame:CGRectMake(63, 36, 0.629*UISCREENWIDTH, 20)];
        searchLable2.textColor=[UIColor colorWithRed:111/255.0f green:113/255.0f blue:121/255.0f alpha:1];
        searchLable2.font=[UIFont  fontWithName:@"" size:14];
        searchLable2.text=@"社区邻居";
        
      UIButton *searchbtn=[[UIButton alloc]initWithFrame:CGRectMake(UISCREENWIDTH-16-60, 16, 60, 33)];
        
        [searchbtn setTitleColor:[UIColor colorWithRed:111/255.0f green:113/255.0f blue:121/255.0f alpha:1] forState:UIControlStateNormal];
        
        
        
        if ([searchData[indexPath.row][@"isFriend"] intValue]==0&&![searchData[indexPath.row][@"account"] isEqualToString:[user_info objectForKey:userAccount]]) {
            
            
            [searchbtn setBackgroundImage:[UIImage imageNamed:@"Neighbors4"] forState:UIControlStateNormal];
            [searchbtn setTitle:@"添加" forState:UIControlStateNormal];
            searchbtn.tag=indexPath.row+10000;
            [searchbtn addTarget:self action:@selector(addNeighbors:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
            [searchbtn setImage:nil forState:UIControlStateNormal];
            [searchbtn setTitle:@"已添加" forState:UIControlStateNormal];
            searchbtn.userInteractionEnabled=NO;
            
        }

        

        [sCell addSubview:searchbtn];
        [sCell addSubview:searchImg];
        [sCell addSubview:searchLable1];
        [sCell addSubview:searchLable2];
        
        
    }

    
    sCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return sCell;


}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    
    [searchData removeAllObjects];
    
    for (NSDictionary *dic in neighborData) {
        
        
        
        if ([dic[@"account"] rangeOfString:searchText].location !=NSNotFound) {
            
            [searchData addObject:dic];
            
            [self.AddNeighborsTableview reloadData];
            
           
        }
        
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

-(void)addNeighbors:(UIButton*)btn{
    

    if (btn.tag>=10000) {
        
        [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_ADD :searchData[btn.tag-10000][@"account"]];
        
    }else{
        

        [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_ADD :neighborData[btn.tag][@"account"]];
  
    }
    
    
    
    
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"" message:@"已经成功发送请求" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [aler show];
   
}

- (IBAction)back_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
