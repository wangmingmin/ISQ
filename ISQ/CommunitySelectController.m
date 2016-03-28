//
//  CommunitySelectController.m
//  ISQ
//
//  Created by mac on 15-4-25.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "CommunitySelectController.h"
#import "CityTableViewCell.h"
#import "MJNIndexView.h"
#import "AppDelegate.h"
#import "pinyin.h"
#import "MJRefresh.h"
#import "HMAC-SHA1.h"
#import "MD5Func.h"


@interface CommunitySelectController ()<MJNIndexViewDataSource,UIWebViewDelegate,UIAlertViewDelegate>{
    
    CityTableViewCell *communitycell;
    NSArray *cityToCommunity;
    NSArray *returnString;
    AppDelegate *locationCityDelegate;
    NSMutableDictionary*index;
    NSArray*arraylist;
}
@property (nonatomic, strong) MJNIndexView *indexView;

@end

@implementation CommunitySelectController

@synthesize communityTableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    returnString = [[NSArray alloc] init];
    
    
    //下拉刷新
    [self addHeader];
    
    //获取社区数据(定位)
//    [self getCommnityDataLocation];
    self.communityTableview.showsVerticalScrollIndicator = NO;
    
    self.communityTableview.tableFooterView = [[UITableView alloc]init];
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [vc.communityTableview addHeaderWithCallback:^{
        //获取社区数据(非定位)
        [self getCommnityData];
        
    }];
    // 自动刷新(一进入程序就下拉刷新)
    [vc.communityTableview headerBeginRefreshing];
    
}

-(void)viewDidAppear:(BOOL)animated{

    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

//获取社区数据(定位)
//-(void)getCommnityDataLocation{
//    
//    
//    locationCityDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    
//    if (locationCityDelegate.theDistrict) {
//
//        NSString *http=[communityURL stringByAppendingString:@""];
//        NSDictionary *arry=@{@"la":[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLa],@"lo":[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLo],@"dname":locationCityDelegate.theDistrict};
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//        
//        [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            cityToCommunity=  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
//            
//            [self.communityTableview reloadData];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"error---%@",error);
//            
//        }];
//        
//    }
//    
//}


#pragma mark - 获取社区数据
-(void)getCommnityData{
    
    NSString *url = @"http://api.wisq.cn/rest/region/community";
    NSString *key = @"FkFITeRW";
    NSString *s = [NSString stringWithFormat:@"%@%@district=%@limit=%@order=%@page=%@per_page=%@sortby=%@timestamp=%@%@",@"GET",url,[saveCityName objectForKey:userDistrictid],@"20",@"asc",@"20",@"10",@"alphabet",[HMAC_SHA1 getTime],key];
    NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"/+=\n:"] invertedSet];
    NSString *str = [s stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
    NSString *sign = [MD5Func md5:str];
    
    NSString *http = [NSString stringWithFormat:@"%@?timestamp=%@&sign=%@&district=%@&limit=%@&page=%@&per_page=%@&sortby=%@&order=%@",url,[HMAC_SHA1 getTime],sign,[saveCityName objectForKey:userDistrictid],@"20",@"20",@"10",@"alphabet",@"asc"];
    
    //建立一个字典，字典保存key是A-Z  值是数组
    index=[NSMutableDictionary dictionaryWithCapacity:0];
    [index removeAllObjects];
    [ISQHttpTool getHttp:http contentType:nil params:nil success:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
        NSInteger totalcount = [[[dic objectForKey:@"data"] objectForKey:@"total"] integerValue];
        
        if (totalcount > 0) {
        
            returnString = [[dic objectForKey:@"data"] objectForKey:@"content"];
            for (int i=0;i<returnString.count;i++) {
                NSString *strFirLetter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([returnString[i][@"communityshortname"] characterAtIndex:0])];
                if ([[index allKeys]containsObject:strFirLetter]) {
                    //判断index字典中，是否有这个key如果有，取出值进行追加操作
                    [[index objectForKey:strFirLetter] addObject:returnString[i]];
                    
                }else{
                    
                    NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
                    [tempArray addObject:returnString[i]];
                    
                    [index setObject:tempArray forKey:strFirLetter];
                }
            }
            
            arraylist=nil;
            [self.indexView removeFromSuperview];
            self.indexView.dataSource = nil;
            
            arraylist= [[index allKeys] sortedArrayUsingSelector:@selector(compare:)];
            self.indexView = [[MJNIndexView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH-2, UISCREENHEIGHT)];
            self.indexView.dataSource = self;
            self.indexView.fontColor = [UIColor blackColor];
            [self.view addSubview:self.indexView];
            // 结束刷新
            [self.communityTableview headerEndRefreshing];
            [self.communityTableview reloadData];
            
        }else{
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您所选择区域还没有添加社区信息" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
        }
        
    } failure:^(NSError *erro) {
        
    }];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - tableView delagate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arraylist.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [index[arraylist[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    communitycell = [tableView dequeueReusableCellWithIdentifier:@"cityCell2" forIndexPath:indexPath];
    if (!communitycell) {
        
        communitycell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell2"];
    }
    
    communitycell.cityNameLable.text = index[arraylist[indexPath.section]][indexPath.row][@"communityshortname"];
    
    return communitycell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


//分组的名称
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 22)];
    headerView.backgroundColor=[UIColor whiteColor];
    UILabel *headerLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 22)];
    headerLable.textColor=[UIColor colorWithRed:255/255.0f green:37/255.0f blue:106/255.0f alpha:1.0f];
    headerLable.text= arraylist[section];
    
    [headerView addSubview:headerLable];
    
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [saveCityName setObject:index[arraylist[indexPath.section]][indexPath.row][@"communityshortname"] forKey:saveCommunityName];
    [saveCityName setObject:index[arraylist[indexPath.section]][indexPath.row][@"communityname"] forKey:saveCommunityLongName];
    [saveCityName setObject:index[arraylist[indexPath.section]][indexPath.row][@"communityid"] forKey:userCommunityID];
    
    //更改社区信息
    [self toSaveCommunityID];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.communityTableview.delegate=nil;
    self.communityTableview.dataSource=nil;
    self.communityTableview=nil;
    communitycell=nil;
    cityToCommunity=nil;
    returnString=nil;
    index=nil;
    arraylist=nil;
    [super removeFromParentViewController];
}


#pragma mark - MJNIndexView delegate

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    [self.communityTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
}


- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView{
    
    NSMutableArray *IndexTitles=[[NSMutableArray alloc]init];
    [IndexTitles addObject:@""];
    
    if(arraylist.count>0){
        for (int i=0; i<arraylist.count; i++) {
            
            [IndexTitles addObject:arraylist[i]];
        }
    }
    
    return IndexTitles;
}


//社区保存到用户信息
-(void)toSaveCommunityID{
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"updatecommunity"];
    
    NSDictionary *arry=@{@"phone":[NSString stringWithFormat:@"%@",[saveCityName objectForKey:userAccount]],@"cid":[NSString stringWithFormat:@"%d",[[saveCityName objectForKey:userCommunityID] intValue ]]};
    
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id resposeObject) {
    
        
    } failure:^(NSError *erro) {
        
    }];
}


- (IBAction)communitySelect_bt:(id)sender {
    
    self.communityTableview.delegate=nil;
    self.communityTableview.dataSource=nil;
    self.communityTableview=nil;
    communitycell=nil;
    cityToCommunity=nil;
    returnString=nil;
    index=nil;
    arraylist=nil;
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    [super removeFromParentViewController];
}


@end
