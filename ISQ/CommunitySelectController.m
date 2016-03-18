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

@interface CommunitySelectController ()<MJNIndexViewDataSource,UIWebViewDelegate>{
    
    CityTableViewCell *cell;
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


-(void)setFromCityData:(NSArray *)oldFromCityData{
    
    if (_fromCityData!=oldFromCityData) {
        _fromCityData=oldFromCityData;
        cityToCommunity=[self.fromCityData copy];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];//初始化图像视图（桃红色）
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //下拉刷新
    [self addHeader];
    
    //获取社区数据(定位)
    [self getCommnityDataLocation];
    
    self.communityTableview.tableFooterView=[[UITableView alloc]init];
}

- (void)addHeader
{
//    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.communityTableview addHeaderWithCallback:^{
        //进入刷新状态就会回调这个Block
        //           NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
        //                          NSMakeRange(0,20)];
        
        //获取社区数据(非定位)
        [self getCommnityData];
        
        //模拟延迟加载数据，因此1.5秒后才调用）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        //        });
    }];
    // 自动刷新(一进入程序就下拉刷新)
    [self.communityTableview headerBeginRefreshing];
    
}

-(void)viewDidAppear:(BOOL)animated{

    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

//获取社区数据(定位)
-(void)getCommnityDataLocation{
    
    locationCityDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (locationCityDelegate.theDistrict) {

        NSString *http=[communityURL stringByAppendingString:@""];
        NSDictionary *arry=@{@"la":[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLa],@"lo":[NSString stringWithFormat:@"%f" ,locationCityDelegate.theLo],@"dname":locationCityDelegate.theDistrict};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            cityToCommunity=  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
            
            [self.communityTableview reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
        }];
        
    }
    
}


#pragma mark - 获取社区数据
-(void)getCommnityData
{
    //建立一个字典，字典保存key是A-Z  值是数组
    index=[NSMutableDictionary dictionaryWithCapacity:0];
    
    [index removeAllObjects];
    returnString=nil;
    NSString *http=[requestTheCodeURL stringByAppendingString:@"getcommunity"];
    NSDictionary *arry;
    if([saveCityName objectForKey:userCityID]){
        
        arry=@{@"cityid":[saveCityName objectForKey:userCityID]};
    }else {
        
        arry=@{@"cityid":@"267"};
    }
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id responseObject) {
        
        returnString=  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
        
        
        for (int i=0;i<returnString.count;i++) {
            
            NSString *strFirLetter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([returnString[i][@"communityShortName"] characterAtIndex:0])];
            
            
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
        [self.communityTableview reloadData];
        [self.communityTableview headerEndRefreshing];
        
    } failure:^(NSError *erro) {
        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您好，当前网络状态不佳，请稍后再试！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [aler show];
        
        [self.communityTableview headerEndRefreshing];
        [aler removeFromSuperview];
        
    }];

}
   
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delagate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2+arraylist.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        
        return 1+cityToCommunity.count;
        
        
    }else if(section==1){
        
        return 1;
    }else if ([arraylist[0] isEqualToString:@"#"]){
        
        if(section==arraylist.count+1){
            
            
            return [index[arraylist[0]] count];
            
        }
        return [index[arraylist[section-1]] count];
        
    }
    
    return [index[arraylist[section-2]] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section==0&&indexPath.row==0)||indexPath.section==1) {
        return 23;
    }
    
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell1" forIndexPath:indexPath];
            cell.hopCity.text=@"附近的社区";
            
            
        }else if (indexPath.row>=1){
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell2" forIndexPath:indexPath];
            cell.cityNameLable.text=cityToCommunity[indexPath.row-1][@"communityShortName"];
        }                
    }else if(indexPath.section==1){
        
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell1" forIndexPath:indexPath];
        cell.hopCity.text=@"其他社区";
        
    }
    
    else if([arraylist[0] isEqualToString:@"#"]){
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell2" forIndexPath:indexPath];
        if (indexPath.section==arraylist.count+1) {
            
            cell.cityNameLable.text=index[arraylist[0]][indexPath.row][@"communityShortName"];
        }
        else if(indexPath.section!=arraylist.count+1&&indexPath.section>=2){
            
            cell.cityNameLable.text=index[arraylist[indexPath.section-1]][indexPath.row][@"communityShortName"];
            
        }
        
        
    }
    else {
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell2" forIndexPath:indexPath];
        
        cell.cityNameLable.text=index[arraylist[indexPath.section-2]][indexPath.row][@"communityShortName"];
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row>=1) {
            
            [saveCityName setObject:cityToCommunity[indexPath.row-1][@"communityShortName"] forKey:saveCommunityName];
            [saveCityName setObject:[cityToCommunity[indexPath.row-1] objectForKey:@"communityId"] forKey:userCommunityID];
        }
        
    }else if ([arraylist[0] isEqualToString:@"#"]){
        
        if(indexPath.section>=2&&arraylist.count+1!=indexPath.section){
            
            NSString *theTitleIndex=arraylist[indexPath.section-1];
            
            [saveCityName setObject:index[theTitleIndex][indexPath.row][@"communityShortName"] forKey:saveCommunityName];
            [saveCityName setObject:index[theTitleIndex][indexPath.row][@"communityId"] forKey:userCommunityID];
            
        }else if(arraylist.count+1==indexPath.section){
            
            NSString *theTitleIndex=arraylist[0];
            [saveCityName setObject:index[theTitleIndex][indexPath.row][@"communityShortName"] forKey:saveCommunityName];
            [saveCityName setObject:index[theTitleIndex][indexPath.row][@"communityId"] forKey:userCommunityID];
        }
        }else{
        
        [saveCityName setObject:index[arraylist[indexPath.section-2]][indexPath.row][@"communityShortName"] forKey:saveCommunityName];
        [saveCityName setObject:index[arraylist[indexPath.section-2]][indexPath.row][@"communityId"] forKey:userCommunityID];
    }
    
    //更改社区信息
    [self toSaveCommunityID];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.communityTableview.delegate=nil;
    self.communityTableview.dataSource=nil;
    self.communityTableview=nil;
    cell=nil;
    cityToCommunity=nil;
    returnString=nil;
    index=nil;
    arraylist=nil;
    [super removeFromParentViewController];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 22)];
    headerView.backgroundColor=[UIColor whiteColor];
    UILabel *headerLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 20, 22)];
    headerLable.textColor=[UIColor colorWithRed:255/255.0f green:37/255.0f blue:106/255.0f alpha:1.0f];
    
    if (section==0||section==1) {
        
        headerLable.text=@"";
        
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
    
    [self.communityTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
}


//社区保存到用户信息
-(void)toSaveCommunityID{
    
    NSString *http=[requestTheCodeURL stringByAppendingString:@"updatecommunity"];
    
    NSLog(@"saveCityName---%@",saveCityName);
    
    NSDictionary *arry=@{@"phone":[NSString stringWithFormat:@"%@",[saveCityName objectForKey:userAccount]],@"cid":[NSString stringWithFormat:@"%d",[[saveCityName objectForKey:userCommunityID] intValue ]]};
    
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id resposeObject) {
    
        
    } failure:^(NSError *erro) {
        
    }];
}


- (IBAction)communitySelect_bt:(id)sender {
    
    self.communityTableview.delegate=nil;
    self.communityTableview.dataSource=nil;
    self.communityTableview=nil;
    cell=nil;
    cityToCommunity=nil;
    returnString=nil;
    index=nil;
    arraylist=nil;
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    [super removeFromParentViewController];
}


@end
