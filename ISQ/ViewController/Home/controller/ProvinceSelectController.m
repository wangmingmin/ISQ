//
//  CitySelectController.m
//  ISQ
//
//  Created by mac on 15-4-25.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ProvinceSelectController.h"
#import "CityTableViewCell.h"
#import "MJNIndexView.h"
#import "CommunitySelectController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "pinyin.h"
#import "MD5Func.h"
#import "HMAC-SHA1.h"
#include "CitySelectController.h"

@interface ProvinceSelectController ()<MJNIndexViewDataSource>{
    
    NSString *cityKey;
    CityTableViewCell *cell;
    NSArray *returnString;
    AppDelegate *locationCityDelegate;
    NSArray *communityData;
    NSMutableDictionary*index;
    NSArray*arraylist;
}
@property (nonatomic, strong) MJNIndexView *indexView;

@end

@implementation ProvinceSelectController
@synthesize cityTableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityTableview.showsVerticalScrollIndicator = NO;
    locationCityDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取定位到的社区信息,这个信息里包含需要的城市ID
    [self getCommunityInfo];
    
    //下拉刷新
    [self addHeader];
    
}

-(void)viewDidAppear:(BOOL)animated{
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [vc.cityTableview addHeaderWithCallback:^{
        
        //获取城市信息
        [self getCityData];
        
    }];
    
    //自动刷新(一进入程序就下拉刷新)
    [vc.cityTableview headerBeginRefreshing];
    
}
#pragma mark- 获取定位到的社区信息

-(void)getCommunityInfo{
    
    
    if (locationCityDelegate.theDistrict) {
        
        NSString *http=[communityURL stringByAppendingString:@""];
        NSDictionary *arry=@{@"la":[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLa],@"lo":[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLo],@"dname":locationCityDelegate.theDistrict};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            communityData=  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
            NSLog(@"communityData---%@",communityData);
            
            
            [self.cityTableview reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
        }];
        
        
    }
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    
    //LBS查询附近社区
    AppDelegate *location = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *url = @"http://api.wisq.cn/rest/community/locationCommunity";
    NSString *timestamp = [NSString stringWithFormat:@"%@",[HMAC_SHA1 getTime]];
    NSString *key = @"FkFITeRW";
    NSString *s = [NSString stringWithFormat:@"%@%@lat=%flimit=%@lng=%ftimestamp=%@%@",@"GET",url,location.theLa,@"3",location.theLo,timestamp,key];
    NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"/+=\n:"] invertedSet];
    NSString *str1 = [s stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
    NSString *sign = [MD5Func md5:str1];
    NSString *URL = [NSString stringWithFormat:@"%@?lat=%f&lng=%f&timestamp=%@&sign=%@&limit=%@",url,location.theLa,location.theLo,timestamp,sign,@"3"];
    
    NSLog(@"URL1---%@",URL);
    
       
    //查询省份
    NSString *url2 = @"http://api.wisq.cn/rest/community/province";
    NSString *s2 = [NSString stringWithFormat:@"%@%@timestamp=%@%@",@"GET",url2,timestamp,key];
    NSString *str3 = [s2 stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
    NSString *sign2 = [MD5Func md5:str3];
    NSString *URL2 = [NSString stringWithFormat:@"%@?timestamp=%@&sign=%@",url2,timestamp,sign2];
    NSLog(@"查询省份-----%@",URL2);
    

    
    //建立一个字典，字典保存key是A-Z  值是数组
    index=[NSMutableDictionary dictionaryWithCapacity:0];
    [index removeAllObjects];
    returnString=nil;
    
    [ISQHttpTool getHttp:URL2 contentType:nil params:nil success:^(id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
        returnString = [[dic objectForKey:@"data"] objectForKey:@"content"] ;
        for (int i=0;i<returnString.count;i++) {
            NSString *strFirLetter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([returnString[i][@"provincename"] characterAtIndex:0])];
            
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
        [self.cityTableview headerEndRefreshing];
        [self.cityTableview reloadData];
        
    } failure:^(NSError *erro) {
        
        NSLog(@"获取省份数据错误----%@",erro);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arraylist.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        
        return 1;
    }
    
    return [index[arraylist[section-1]] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell2" forIndexPath:indexPath];
    
    if (indexPath.section==0){
        
        if (locationCityDelegate.theAddress_city) {
            cell.cityNameLable.text=locationCityDelegate.theAddress_city;
            
        }else {
            
            cell.cityNameLable.text=@"正在定位...";
        }
    }else {
        
        cell.cityNameLable.text=index[arraylist[indexPath.section-1]][indexPath.row][@"provincename"];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
        if (communityData.count>0) {
            [saveCityName setObject:locationCityDelegate.theAddress_city forKey:userCityName];
            [saveCityName setObject:communityData[0][@"cityId"] forKey:userCityID];
        }else {
            
            [saveCityName setObject:@"武汉" forKey:userCityName];
            
        }
        
    }else{
        
        //保存省份id
        [saveCityName setObject:index[arraylist[indexPath.section-1]][indexPath.row] [@"provinceid"] forKey:userProvinceid];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
        CitySelectController *citySelectVC = [storyboard instantiateViewControllerWithIdentifier:@"SelectCityId"];
        [self.navigationController pushViewController:citySelectVC animated:YES];
        
        NSLog(@"province--%@",index[arraylist[indexPath.section-1]][indexPath.row] [@"provinceid"]);
        
    }
    
//    [saveCityName removeObjectForKey:saveCommunityName];
    
}



//分组的名称
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 22)];
    headerView.backgroundColor=[UIColor whiteColor];
    UILabel *headerLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 22)];
    headerLable.textColor=[UIColor colorWithRed:255/255.0f green:37/255.0f blue:106/255.0f alpha:1.0f];
    
    if (section==0){
        
        headerLable.text=@"当前定位的城市";
        
    }else{
        
        headerLable.text= arraylist[section-1];
    }
    
    [headerView addSubview:headerLable];
    
    return headerView;
    
}


#pragma mark - MJNIndex delegate

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    [self.cityTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
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



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([[segue identifier] isEqualToString:@"toCitySegue"]){
//        NSIndexPath *indexPath=[self.cityTableview indexPathForSelectedRow];
//        
    
        
//        if (indexPath.section == 0) {
//            
//            [[segue destinationViewController] setFromCityData:communityData];
//            
//        }else{
//    
//            [segue destinationViewController] ;
//
//        }
        
//    }
}


- (IBAction)citySelect_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
