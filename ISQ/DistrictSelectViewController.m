//
//  DistrictSelectViewController.m
//  ISQ
//
//  Created by xindongni on 16/3/24.
//  Copyright © 2016年 cn.ai-shequ. All rights reserved.
//

#import "DistrictSelectViewController.h"
#import "MJNIndexView.h"
#import "CityTableViewCell.h"
#import "MD5Func.h"
#import "HMAC-SHA1.h"
#import "pinyin.h"
#import "CommunitySelectController.h"

@interface DistrictSelectViewController ()<MJNIndexViewDataSource>{

    CityTableViewCell *districtcell;
    NSArray *returnString;
    NSMutableDictionary*index;
    NSArray*arraylist;
}

@property (nonatomic,strong) MJNIndexView *indexView;

@end

@implementation DistrictSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    returnString = [NSArray array];
    self.districtSelectTableView.showsVerticalScrollIndicator = NO;
    
    //下拉刷新
    [self addHeader];
}

- (void)addHeader{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [vc.districtSelectTableView addHeaderWithCallback:^{
        
        //获取城市信息
        [self getDistrictData];
        
    }];
    
    //自动刷新(一进入程序就下拉刷新)
    [vc.districtSelectTableView headerBeginRefreshing];
    
}

//根据cityid 获取district
- (void)getDistrictData{

    //建立一个字典，字典保存key是A-Z  值是数组
    index=[NSMutableDictionary dictionaryWithCapacity:0];
    [index removeAllObjects];
    returnString=nil;
    NSString *url = @"http://api.wisq.cn/rest/region/district";
    NSString *key = @"FkFITeRW";
    NSString *str = [NSString stringWithFormat:@"%@%@city=%@timestamp=%@%@",@"GET",url,[saveCityName objectForKey:userCityID],[HMAC_SHA1 getTime],key];
    NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"/+=\n:"] invertedSet];
    NSString *s = [str stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
    NSString *sign = [MD5Func md5:s];
    NSString *http = [NSString stringWithFormat:@"%@?timestamp=%@&sign=%@&city=%@",url,[HMAC_SHA1 getTime],sign,[saveCityName objectForKey:userCityID]];
    [ISQHttpTool getHttp:http contentType:nil params:NULL success:^(id reponseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:reponseObject options:NSJapaneseEUCStringEncoding  error:nil];
        returnString = [[dic objectForKey:@"data"] objectForKey:@"content"] ;
        for (int i=0;i<returnString.count;i++) {
            NSString *strFirLetter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([returnString[i][@"districtname"] characterAtIndex:0])];
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
        [self.districtSelectTableView headerEndRefreshing];
        [self.districtSelectTableView reloadData];
        
    } failure:^(NSError *erro) {
        
    }];
}


#pragma mark - UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arraylist.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [index[arraylist[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    districtcell = [tableView dequeueReusableCellWithIdentifier:@"cityCell2" forIndexPath:indexPath];
    if (!districtcell) {
        
        districtcell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell2"];
    }
    
    districtcell.cityNameLable.text = index[arraylist[indexPath.section]][indexPath.row][@"districtname"];
    
    return districtcell;
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
    
    [saveCityName setObject:index[arraylist[indexPath.section]][indexPath.row] [@"districtid"] forKey:userDistrictid];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
    CommunitySelectController *communitySelect = [storyboard instantiateViewControllerWithIdentifier:@"SelectCommunityId"];
    [self.navigationController pushViewController:communitySelect animated:YES];
}


#pragma mark - MJNIndex delegate

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    [self.districtSelectTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
