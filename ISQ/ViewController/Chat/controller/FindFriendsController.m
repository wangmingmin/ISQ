//
//  FindFriendsController.m
//  ISQ
//
//  Created by mac on 15-5-15.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "FindFriendsController.h"
#import "NeighborsTableCell.h"
#import "GetVcard.h"
#import "MJNIndexView.h"
#import "CmdDealWith.h"

@interface FindFriendsController ()<MJNIndexViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>{
    
    
    NeighborsTableCell *cell;
    GetVcard *getVcard;
    NSArray *theIndex;
    NSMutableDictionary *contanceData;
    NSString *vcardNumber;
    NSMutableArray *Frindsdata;
    NSMutableDictionary*indexServer;
    UITableViewCell *sCell;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchData;
    NSMutableArray *searchServer;
    BOOL isInvitation;
    
}
@property (nonatomic, strong) MJNIndexView *indexView;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation FindFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    searchData=[[NSMutableArray alloc]init];
    searchServer=[[NSMutableArray alloc]init];
    Frindsdata=[[NSMutableArray alloc]init];
    ;
    //获取联系人的初始化
    getVcard=[[GetVcard alloc]init];
    contanceData=[[NSMutableDictionary alloc]init];
    theIndex=[[NSArray alloc]init];
    
    contanceData =[getVcard getPersonInfo];
    theIndex=[[contanceData allKeys] sortedArrayUsingSelector:@selector(compare:)];//排序并赋值
    
    
    self.indexView = [[MJNIndexView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH-2, UISCREENHEIGHT)];
    self.indexView.dataSource = self;
    self.indexView.fontColor = [UIColor blackColor];
    [self.view addSubview:self.indexView];
   
    //搜索框
    [self theSearchBar];
   
    vcardNumber=@"10";
    
   
}


-(void)theSearchBar{
    
    if(theIndex.count>=1){
        
        for (int i=0; i<theIndex.count; i++) {
            
            for (int j=0; j<[contanceData[theIndex[i]] count]; j++) {
                
                vcardNumber=[NSString stringWithFormat:@"%@,%@",vcardNumber,contanceData[theIndex[i]][j][@"telphone"]];
                
                
            }
            
        }
        
        
        
        //建立一个字典，字典保存key是A-Z  值是数组(服务器收到的返回值整理)
        indexServer=[NSMutableDictionary dictionaryWithCapacity:0];
        
        
        NSDictionary *arry=@{@"ua":[user_info objectForKey:userAccount],@"tfs":vcardNumber};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:FINDFRIENDS parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Frindsdata=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
 
            
                    int k=0;
                    for(int i=0;i<theIndex.count;i++){
                        
                        for(int j=0;j<[contanceData[theIndex[i]] count];j++){
                            
                            k=k+1;
                            
                            

            if ([ contanceData[theIndex[i]][j][@"telphone"] isEqualToString:Frindsdata[k][@"user"]]) {
                                

                if ([[indexServer allKeys]containsObject:theIndex[i]]) {
                    //判断index字典中，是否有这个key如果有，取出值进行追加操作
                    [[indexServer objectForKey:theIndex[i]] addObject:Frindsdata[k]];
                    
                    
                    
                }else{
                    
                    NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
                    [tempArray addObject:Frindsdata[k]];
                    [indexServer setObject:tempArray forKey:theIndex[i]];
                }
                            }
                            
                        }
                    }

            
            
           
            
            [self.findFriendsTableview reloadData];
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
        }];

        
    }
   
   
    
    
    
    
    UISearchBar *friends_seachview = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44)];
    friends_seachview.delegate=self;
    friends_seachview.backgroundImage=[UIImage imageNamed:@"searchBg"];
    friends_seachview.placeholder = @"手机号";
    // 添加 searchbar 到 headerview
    self.findFriendsTableview.tableHeaderView = friends_seachview;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:friends_seachview contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;

    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView==self.findFriendsTableview) {
        
        return theIndex.count;
    }else if(searchDisplayController){
        
        return 1;
    }
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.findFriendsTableview) {
        
        //-1的目的就是要把#后移
        if ([theIndex[0] isEqualToString:@"#"]) {
            if (section==theIndex.count-1) {
                
                return [contanceData[theIndex[0]] count];
            }
            return [contanceData[theIndex[section+1]] count];
        }
        return [contanceData[theIndex[section]] count];
    }else if (searchDisplayController){
        
        
        
        
        return searchData.count;
    }
    
    return 0;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.findFriendsTableview) {
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"findFriendsCell" forIndexPath:indexPath];
        
        if([theIndex[0] isEqualToString:@"#"]){
            
            if (indexPath.section!=theIndex.count-1) {
            
                cell.theName.text=[contanceData[theIndex[indexPath.section+1]][indexPath.row][@"last"] stringByAppendingFormat:@"%@",contanceData[theIndex[indexPath.section+1]][indexPath.row][@"first"]];
                
                if(indexServer.count>0){
                    

                    cell.dataSource=indexServer[theIndex[indexPath.section+1]][indexPath.row];

                }
                
            }else if(indexPath.section==theIndex.count-1){
                
                
                cell.theName.text=[contanceData[theIndex[0]][indexPath.row][@"last"] stringByAppendingFormat:@"%@",contanceData[theIndex[0]][indexPath.row][@"first"]];
    
                if(indexServer.count>0){
                    
                    cell.dataSource=indexServer[theIndex[0]][indexPath.row];
                    
                }
                
                
                
                
                
            }
        }
        else {
            
            
            cell.theName.text=[contanceData[theIndex[indexPath.section]][indexPath.row][@"last"] stringByAppendingFormat:@"%@",contanceData[theIndex[indexPath.section]][indexPath.row][@"first"]];
            
            
            if(indexServer.count>0){
                
                cell.dataSource=indexServer[theIndex[indexPath.section]][indexPath.row];
                
            }
  
        }
        
        cell.add_ol.tag=indexPath.row;
        [cell.add_ol addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (searchDisplayController&&tableView!=self.findFriendsTableview){
        sCell=[[UITableViewCell alloc]init];
        
        
        UIImageView *searchImg=[[UIImageView alloc]initWithFrame:CGRectMake(14, 9, 45, 45)];
        
        searchImg.image=[UIImage imageNamed:@"defuleImg"];
        searchImg.layer.cornerRadius=4.0f;
        searchImg.layer.masksToBounds=YES;
       
        
        UILabel *searchLable1=[[UILabel alloc]initWithFrame:CGRectMake(63, 10, 0.629*UISCREENWIDTH, 26)];
        searchLable1.font=[UIFont  fontWithName:@"" size:17];
        searchLable1.text=[NSString stringWithFormat:@"%@%@",searchData[indexPath.row][@"last"],searchData[indexPath.row][@"first"]];
        
        UILabel *searchLable2=[[UILabel alloc]initWithFrame:CGRectMake(63, 36, 0.629*UISCREENWIDTH, 20)];
        searchLable2.textColor=[UIColor colorWithRed:111/255.0f green:113/255.0f blue:121/255.0f alpha:1];
        searchLable2.font=[UIFont  fontWithName:@"" size:14];
        searchLable2.text=@"手机联系人";
        
        
        if (searchServer.count>0) {
            
            UIButton *searchbtn=[[UIButton alloc]initWithFrame:CGRectMake(UISCREENWIDTH-16-60, 16, 60, 33)];
            
            if ([searchServer[indexPath.row][@"status"] intValue]==0||[[user_info objectForKey:userAccount] isEqualToString:searchServer[indexPath.row][@"user"]]) {
                
                searchbtn.tag=indexPath.row+10000;
                [searchbtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [searchbtn setTitle:@"已添加" forState:UIControlStateNormal];
                [searchbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                searchbtn.userInteractionEnabled=NO;
                
                
                
                
            }else if([searchServer[indexPath.row][@"status"] intValue]==1){
                
                [searchbtn setBackgroundImage:[UIImage imageNamed:@"Neighbors4"] forState:UIControlStateNormal];
                [searchbtn setTitle:@"添加" forState:UIControlStateNormal];
                [searchbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                searchbtn.tag=indexPath.row+10000;
                [searchbtn addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if([searchServer[indexPath.row][@"status"] intValue]==2){
                
                
                [searchbtn setBackgroundImage:[UIImage imageNamed:@"Neighbors5"] forState:UIControlStateNormal];
                [searchbtn setTitle:@"邀请" forState:UIControlStateNormal];
                searchbtn.tag=indexPath.row+10000;
                [searchbtn addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
                [searchbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                
            }
            
            
            
            
            [sCell addSubview:searchbtn];
        }
        
        [sCell addSubview:searchImg];
        [sCell addSubview:searchLable1];
        [sCell addSubview:searchLable2];
        
        
    }
    
    
    sCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return sCell;
    

}


//分组的名称
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView==self.findFriendsTableview) {
        
        if (theIndex.count>0) {
            
            if ([theIndex[0] isEqualToString:@"#"]) {
                
                if(section!=theIndex.count-1){
                    
                    return theIndex[section+1];
                    
                }else if(section==theIndex.count-1){
                    
                    return theIndex[0];
                }
                
            }
            
            return theIndex[section];
            
        }

    }
    
    
    return nil;
}
//索引
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    
    if (theIndex.count>0) {
        
    NSMutableArray *IndexTitles=[[NSMutableArray alloc]init];
    
    if ([theIndex[0] isEqualToString:@"#"]) {
        
        if(theIndex.count>0){
            for (int i=0; i<theIndex.count; i++) {
                
                if (i!=0) {
                    [IndexTitles addObject:theIndex[i]];
                }
                
            }
            [IndexTitles addObject:theIndex[0]];
        }
        
        return IndexTitles;
    }
    
    
    
    return theIndex;
        
    }
    return nil;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
    [searchData removeAllObjects];
    [searchServer removeAllObjects];
    
    for (int i=0;i<theIndex.count;i++){
        
        for(int j=0;j<[contanceData[theIndex[i]] count];j++){
            
            if ([contanceData[theIndex[i]][j][@"telphone"] rangeOfString:searchText].location !=NSNotFound) {
            
                [searchData addObject:contanceData[theIndex[i]][j]];
                
                if (indexServer.count>0&&indexServer) {
                    
                    [searchServer addObject:indexServer[theIndex[i]][j]];
                
                }
                
                
                

                
                [self.findFriendsTableview reloadData];
            
                
               
            }
            
            
        }
        
    }
    
    

    
    
    
    
    
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    if (theIndex.count>0) {
        [self.findFriendsTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
    }
    
    
}

-(void)addFriends:(UIButton *)btn{

    UIView *v ;
    
    if (SYSTEMVERSION<8.0) {
        
        v = [btn superview].superview;//获取父类view
        
    }else{
        
        v = [btn superview];//获取父类view
    }
    
    

    UITableViewCell *theCell = (UITableViewCell *)[v superview];//获取cell
    NSIndexPath *indexPath = [self.findFriendsTableview indexPathForCell:theCell];//获取cell对应的section

    
    if (btn.tag>=10000) {
        
        
        if ([searchServer[btn.tag-10000][@"status"] intValue]==2) {
            
            [self sendInvitation:searchServer[btn.tag-10000][@"user"]];
            
            
            
            
        }else{
            

            
            [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_ADD :searchServer[btn.tag-10000][@"user"]];
            [self aler];
        }
        
    }
    else{
        
        if([theIndex[0] isEqualToString:@"#"]){
            
            if (indexPath.section!=theIndex.count-1) {
                
                if ([indexServer[theIndex[indexPath.section+1]][indexPath.row][@"status"] intValue]==2) {
                    
                    [self sendInvitation:indexServer[theIndex[indexPath.section+1]][indexPath.row][@"user"]];
                    
                    
                    
                }else{
                    

                    
                    [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_ADD :indexServer[theIndex[indexPath.section+1]][indexPath.row][@"user"]];
                    [self aler];
                }
                
                
                
            }else if(indexPath.section==theIndex.count-1){
                
                if ([indexServer[theIndex[0]][indexPath.row][@"status"] intValue]==2) {
                  
                    [self sendInvitation:indexServer[theIndex[0]][indexPath.row][@"user"]];
                    
                }else{
                    
                    

                    
                    [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_ADD :indexServer[theIndex[0]][indexPath.row][@"user"]];
                    [self aler];
                }

        }
        
        
        
        }else{
            
            
            if ([indexServer[theIndex[indexPath.section]][indexPath.row][@"status"] intValue]==2) {
                
                [self sendInvitation:indexServer[theIndex[indexPath.section]][indexPath.row][@"user"]];
                
            }else{
                
                
                [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_ADD :indexServer[theIndex[indexPath.section]][indexPath.row][@"user"]];
                
                [self aler];
                
            }
            
            
            
        }

    }
    
    
   
}


-(void)sendInvitation:(NSString*)phone{
    
   
    //提示框
    [self showHudInView:self.view hint:@"正在处理..."];
    
    NSDictionary *arry=@{@"fa":[user_info objectForKey:userAccount],@"ua":phone};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:FINDFRIENDSMESSAGE parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
        [self hideHud];
        
        if ([dic[@"code"] intValue]==0) {
            
            UIAlertView *ale=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您好，已经成功将邀请发送至您的好友手机中。" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [ale show];
            
            
        }else{
            
            UIAlertView *ale=[[UIAlertView alloc]initWithTitle:@"提示" message:@"邀请失败。" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [ale show];
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self hideHud];
        UIAlertView *ale=[[UIAlertView alloc]initWithTitle:@"提示" message:@"邀请失败。" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [ale show];
        
    }];
   
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)aler{
    
    UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"" message:@"已经成功发送请求" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [aler show];
    
}

- (IBAction)back_bt:(id)sender {
    [self hideHud];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
