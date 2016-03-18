//
//  CitySelectController.m
//  ISQ
//
//  Created by mac on 15-4-25.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "CitySelectController.h"
#import "CityTableViewCell.h"
#import "MJNIndexView.h"
#import "CommunitySelectController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "pinyin.h"
#import "MD5Func.h"
#import "HMAC-SHA1.h"

@interface CitySelectController ()<MJNIndexViewDataSource>{
    
    NSString *cityKey;
    CityTableViewCell *cell;
    NSArray *returnString;
    AppDelegate *locationCityDelegate;
    NSArray *communityData;
    NSMutableArray *ishotCity;
    NSMutableDictionary*index;
    NSArray*arraylist;
}
@property (nonatomic, strong) MJNIndexView *indexView;

@end

@implementation CitySelectController
@synthesize cityTableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
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
    
    NSString *url = @"http://192.168.2.107/isq1.0/public/index.php/rest/community/locationCommunity";
    NSString *timestamp = [NSString stringWithFormat:@"%@",[HMAC_SHA1 getTime]];
    NSString *key = @"FkFITeRW";
    
    NSString *s = [NSString stringWithFormat:@"%@%@lat=%flimit=%@lng=%ftimestamp=%@%@",@"GET",url,location.theLa,@"3",location.theLo,timestamp,key];
    NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"/+=\n:"] invertedSet];
    NSString *str1 = [s stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
    NSString *sign = [MD5Func md5:str1];
    NSString *URL = [NSString stringWithFormat:@"%@?lat=%f&lng=%f&timestamp=%@&sign=%@&limit=%@",url,location.theLa,location.theLo,timestamp,sign,@"3"];
    
    NSLog(@"URL1---%@",URL);

    
    //建立一个字典，字典保存key是A-Z  值是数组
    index=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [index removeAllObjects];
    returnString=nil;
    ishotCity=[[NSMutableArray alloc]init];
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"getcity"];
    [ISQHttpTool getHttp:http contentType:nil params:nil success:^(id responseObject) {
        
        returnString = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
                
        for (int i=0;i<returnString.count;i++) {
            NSString *strFirLetter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([returnString[i][@"cityName"] characterAtIndex:0])];
            
            if ([[index allKeys]containsObject:strFirLetter]) {
                //判断index字典中，是否有这个key如果有，取出值进行追加操作
                [[index objectForKey:strFirLetter] addObject:returnString[i]];
                
            }else{
                
                NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
                [tempArray addObject:returnString[i]];
                
                [index setObject:tempArray forKey:strFirLetter];
            }
            
            if([returnString[i][@"ishot"] intValue]==1){
                
                [ishotCity addObject:returnString[i]];
                
                
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
        
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器异常，请稍后再试。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return arraylist.count+2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        
        return 1;
        
        
    }else if(section==1){
        
        return ishotCity.count;
        
        
    }else if ([arraylist[0] isEqualToString:@"#"]){
        
        if(section==arraylist.count+1){
            
            
            return [index[arraylist[0]] count];
            
        }
        return [index[arraylist[section-1]] count];
        
    }
    
    return [index[arraylist[section-2]] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell2" forIndexPath:indexPath];
    
    if (indexPath.section==0){
        
        if (locationCityDelegate.theAddress_city) {
            cell.cityNameLable.text=locationCityDelegate.theAddress_city;
            
        }else {
            
            cell.cityNameLable.text=@"正在定位...";
        }
        
        
    }else if (indexPath.section==1){
        
        
        cell.cityNameLable.text=ishotCity[indexPath.row][@"cityName"];
        
        
    }else {
        
        cell.cityNameLable.text=index[arraylist[indexPath.section-2]][indexPath.row][@"cityName"];
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
        
    }else if(indexPath.section==1){
        
        [saveCityName setObject:ishotCity[indexPath.row][@"cityName"] forKey:userCityName];
        [saveCityName setObject:ishotCity[indexPath.row][@"cityId"] forKey:userCityID];
        
    }else{
        
        
        [saveCityName setObject:index[arraylist[indexPath.section-2]][indexPath.row][@"cityName"] forKey:userCityName];
        [saveCityName setObject:index[arraylist[indexPath.section-2]][indexPath.row][@"cityId"] forKey:userCityID];
        
    }
    
    [saveCityName removeObjectForKey:saveCommunityName];
    
}
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    
    NSMutableArray *IndexTitles=[[NSMutableArray alloc]init];
    [IndexTitles addObject:@""];
    [IndexTitles addObject:@""];
    
    if(arraylist.count>0){
        if([arraylist[0] isEqualToString:@"#"]){
            for (int i=0; i<arraylist.count; i++) {
                
                if (i!=0) {
                    
                    [IndexTitles addObject:arraylist[i]];
                }
                
            }
            [IndexTitles addObject:arraylist[0]];
        }else{
            
            for (int i=0; i<arraylist.count; i++) {
                
                [IndexTitles addObject:arraylist[i]];
                
            }
        }
    }
    
    
    
    return IndexTitles;
}

//分组的名称
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 22)];
    headerView.backgroundColor=[UIColor whiteColor];
    UILabel *headerLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 22)];
    headerLable.textColor=[UIColor colorWithRed:255/255.0f green:37/255.0f blue:106/255.0f alpha:1.0f];
    
    if (section==0){
        
        headerLable.text=@"当前定位的城市";
        
    }else if(section==1){
        
        headerLable.text=@"热门城市";
        
    }else if([arraylist[0] isEqualToString:@"#"]){
        
        if (section!=arraylist.count+1&&section!=0&&section!=1){
            
            headerLable.text= arraylist[section-1];
        }
        else if (section==arraylist.count+1){
            headerLable.text= arraylist[0];
        }
        
    }else{
        
        headerLable.text= arraylist[section-2];
    }
    
    [headerView addSubview:headerLable];
    
    
    return headerView;
    
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    
    [self.cityTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
}





#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"toCommunitySegue"]){
        NSIndexPath *indexPath=[self.cityTableview indexPathForSelectedRow];
        
        if (indexPath.section==0) {
            
            [[segue destinationViewController] setFromCityData:communityData];
        }
    }
}


- (IBAction)citySelect_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
