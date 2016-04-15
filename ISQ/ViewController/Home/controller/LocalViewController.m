//
//  LocalViewController.m
//  ISQ
//
//  Created by mac on 15-3-19.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "LocalViewController.h"
#import "JSDropDownMenu.h"
#import "LocalTableViewCell.h"
#import "ConstantFileld.h"
#import "CommunityHelpController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "ADLivelyTableView.h"
#import "SeconWebController.h"
#import "BDMLocationController.h"
#import "ImgURLisFount.h"
#import "BusinessModle.h"

@interface LocalViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UIAlertViewDelegate>{
    JSDropDownMenu *menu;
    NSArray *_data1;
    NSArray *_data2;
//    NSMutableArray *_data3;
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
//    NSInteger _currentData3Index;
    UIView *theView;
    UIActivityIndicatorView* progressInd;
    NSMutableArray *businessData;
    AppDelegate *locationDelegate;
    CGFloat  TheLat_location;
    CGFloat  TheLong_location;
    NSInteger dataNum;
    NSString *isCertificationOrOnCall;//是否认证||上门||热门
    NSArray *noDealData;//直接从网络获取到的数组（未处理，未排序）
    double distanceUseing;
//    BMKMapPoint point1;
//    BMKMapPoint point2;
    
    UIAlertView *alerLoaction;//提示需定位的警告
    BDMLocationController *bdmapVC;
    
    
}

@end

@implementation LocalViewController
@synthesize showAdress;
@synthesize shTableView;
@synthesize locationTopLable,LocalBack_ol;

-(void)setFormHomeData:(NSArray *)oldFormHomeData{
    
    if (_formHomeData!=oldFormHomeData) {
        _formHomeData=oldFormHomeData;
        
    }
    
}

-(instancetype)initWithMaintenance:(NSArray *)aDecoder{
    
    if (_formHomeData==nil) {
        
        _formHomeData=aDecoder;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    bdmapVC=[[BDMLocationController alloc]init];
    locationDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
       UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];//初始化图像视图（桃红色）

    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    ADLivelyTableView * groupLively = (ADLivelyTableView *)self.shTableView;
    groupLively.initialCellTransformBlock = ADLivelyTransformTilt;
 
    //不为商户的时候
    if([[_formHomeData objectAtIndex:1] isEqualToString:@"home"]){
       
        
        //区域选择tableview
        [self areaSelect];
        
        //上拉加载
        [self addFooter];
        //下拉刷新
        [self addHeader];
        
        
        self.LocalBack_ol.hidden=NO;
        
        self.locationTopLable.text=[_formHomeData objectAtIndex:0];
        
        self.tabBarController.tabBar.hidden=YES;
        
     //为商户的时候
    }else {
        
        self.locationTopLable.text=@"商户";
        //区域选择tableview
        [self areaSelect];
        
        _formHomeData=nil;
        _formHomeData=@[@"sh",@"sh",@"5"];
        
        //上拉加载
        [self addFooter];
        //下拉刷新
        [self addHeader];
  
    }
    
  
    self.refresh_sta.hidden=YES;
    
    businessData=[[NSMutableArray alloc]init];
  
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


//从服务器获取商家信息
-(void)business:(NSString*)infotype:(double)distan:(NSInteger)theDataNum{
    
    //是否已经有定位信息了
    if(locationDelegate.theDistrict){
        
        if (theDataNum==0) {
            
            businessData=[[NSMutableArray alloc]init];
        }
        
        NSString *http=[getHomePic stringByAppendingString:@"getinfo"];
        NSDictionary *arry=@{@"infotype":infotype,@"la":[NSString stringWithFormat:@"%f",locationDelegate.theLa],@"lo":[NSString stringWithFormat:@"%f",locationDelegate.theLo],@"dname":locationDelegate.theDistrict,@"start":[NSString stringWithFormat:@"%ld",(long)theDataNum],@"num":@"20",@"distance":[NSString stringWithFormat:@"%f",distan]
                             };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *thaData = responseObject;
                    
            noDealData=[NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil];
            
            if([isCertificationOrOnCall isEqualToString:@"上门"]){
                
                for (int i=0; i<noDealData.count;i++) {
                    
                    if ([noDealData[i][@"companyIsOnCall"] intValue]==1) {
                        
                        [businessData addObject:noDealData[i]];
                    }
                    
                }
                
            }else if([isCertificationOrOnCall isEqualToString:@"已认证"]){
                
                for (int i=0; i<noDealData.count;i++) {
                    
                    if ([noDealData[i][@"companyChecked"] intValue]==1) {
                        
                         [businessData addObject:noDealData[i]];
                    }
                    
                }
                
                
            }else if([isCertificationOrOnCall isEqualToString:@"热门"]){
                
              //根据拨打字数降序排列
                NSSortDescriptor *_sorter  = [[NSSortDescriptor alloc] initWithKey:@"companyCallNums" ascending:NO];
                NSMutableArray *temp=[[NSMutableArray alloc]init];
                
                [temp addObjectsFromArray:businessData];
                [temp addObjectsFromArray:noDealData];
                
                businessData=[[temp sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_sorter, nil]] copy];
                
                
            }
            
            else {
                
                [businessData addObjectsFromArray:noDealData];
            }
            
            
            [self.shTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
        }];
    }
}

//导航条背景
-(void)viewDidAppear:(BOOL)animated{
    
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];;
    self.showAdress.text= locationDelegate.theAddress;
    
}


-(void)areaSelect{
    
    _data1 = @[@"3000m", @"2000m", @"1000m", @"500m"];
    _data2 = @[@"默认", @"已认证", @"热门", @"上门"];
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
   
    
    [self.view addSubview:menu];
    

}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.shTableView addHeaderWithCallback:^{
        //进入刷新状态就会回调这个Block
        // 模拟延迟加载数据，因此1.5秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
            //重新请求(默认3000m)
            distanceUseing=3.0;
            [self business:[_formHomeData objectAtIndex:2]:distanceUseing:0];
            // 结束刷新
            [vc.shTableView headerEndRefreshing];        });
        
    }];
    
    //自动刷新(一进入程序就下拉刷新)
    [self.shTableView headerBeginRefreshing];
    
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.shTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            dataNum=dataNum+20;
            //分类http请求(默认3000m)
            distanceUseing=3.0;
            [self business:[_formHomeData objectAtIndex:2]:distanceUseing:dataNum];
            
            //结束刷新
            [vc.shTableView footerEndRefreshing];
        });
    }];
    
    
}

// LocalTableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return businessData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UISCREENWIDTH*0.234666;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LocalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LocalCell" forIndexPath:indexPath];
    
    if (businessData.count>0) {
        
        BusinessModle *data=[BusinessModle objectWithKeyValues:businessData[indexPath.row]];
        cell.businessName.text=data.companyName;
        cell.businessDistance.text=data.companyAddress;
        cell.companyCallNumsLable.text=[NSString stringWithFormat:@"%@",data.companyCallNums];
        
        //上门标志
        if ([data.companyIsOnCall intValue]==1  ) {
            
            cell.companyIsOnCall.image=[UIImage imageNamed:@"Rectangle 244"];
        }else {
            
            cell.companyIsOnCall.image=nil;
            
        }
        //认证标志
        if ([data.companyChecked intValue]==1 ) {
            
            cell.companyChecked.image=[UIImage imageNamed:@"v"];
            
        }else{
            cell.companyChecked.image=nil;
        }
        
        NSURL *imgURL=[NSURL URLWithString:[theImgURL stringByAppendingString:data.companyImage]];
        [cell.businessImg setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        
        cell.businessImg.canClick=YES;
        
        if ([ImgURLisFount TheDataIsImgage:cell.businessImg.image]!=0) {
            
            
        }else{
            cell.businessImg.image=[UIImage imageNamed:@"defuleImg"];
        }
        
        
        cell.TellToShop_ol.tag=indexPath.row;
        
        [cell.TellToShop_ol addTarget:self action:@selector(callTheShop:) forControlEvents:UIControlEventTouchUpInside];
        
        //星级算法
        float companyLevel=([data.companyLevel floatValue])/2;
        int companyLevelInt=([data.companyLevel floatValue])/2;
        
        if (companyLevel==companyLevelInt) {
            
            cell.LevelImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"lv_%.1f",companyLevel]];
        }else{
            
            cell.LevelImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"lv_%d_5",companyLevelInt]];
        }

        
        
    }
    
    
        return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.shTableView deselectRowAtIndexPath:indexPath animated:YES];
    BusinessModle *data=[BusinessModle objectWithKeyValues:businessData[indexPath.row]];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SeconWebController *seconWebVC=[storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
    seconWebVC.theUrl=[NSString stringWithFormat:@"%@bid/%@/uid/%d/type/%@",shDetailURL,data.companyId,[[user_info objectForKey:MyUserID] intValue],_formHomeData[2]];
    [user_info setObject:data.companyId forKey:@"companyId"];
    [seconWebVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:seconWebVC animated:YES];
    
}

//call 商家
-(void)callTheShop:(UIButton*)btn{
    
    if (businessData.count>0) {
        
        BusinessModle *data=[BusinessModle objectWithKeyValues:businessData[btn.tag]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:data.companyFixedphone]]];
        //拨打电话次数
        [self callNumHttp:btn.tag];
    
    }
   
  
}

//拨打电话次数
-(void)callNumHttp:(NSInteger)theCompanyid{
    
    NSString *http=[getHomePic stringByAppendingString:@"addcallnum"];
    NSDictionary *arry=@{@"companyid":[NSString stringWithFormat:@"%@",businessData[theCompanyid][@"companyId"]],@"typeid":[NSString stringWithFormat:@"%@",[_formHomeData objectAtIndex:2]]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:http parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            }];
    
    
}


- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
   
    
    return YES;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
   
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
   
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
        if (column==0) {
    
            return _currentData1Index;
    
        }
        else if (column==1) {
    
            return _currentData2Index;
        }
    
      return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
        if (column==0) {
          
                return _data1.count;
            }else if (column==1){
    
           return _data2.count;
    
            }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
        switch (column) {
            case 0:
                
                return _data1[0];
                break;
            case 1:
                return _data2[0];
                break;
            default:
                return nil;
                break;
        }
    
    return _data1[0];
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
        if (indexPath.column==0) {
            return  _data1[indexPath.row];
            }
        else if(indexPath.column==1){
    
            return _data2[indexPath.row];
    
        }
    
    return _data1[indexPath.row];
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    //根据距离来筛选
        if (indexPath.column == 0) {
    
            if (indexPath.row==0) {
                
                //分类http请求3000m
                distanceUseing=3.0;
                [self business:[_formHomeData objectAtIndex:2]:distanceUseing:0];
                
            } else if (indexPath.row==1) {
                //分类http请求2000m
                distanceUseing=2.0;
                [self business:[_formHomeData objectAtIndex:2]:distanceUseing:0];
                
            }
            else if (indexPath.row==2) {
                
                //分类http请求1000m
                distanceUseing=1.0;
                [self business:[_formHomeData objectAtIndex:2]:distanceUseing:0];
            }
            else if (indexPath.row==3) {
                //分类http请求3000m
                distanceUseing=3.0;
                [self business:[_formHomeData objectAtIndex:2]:distanceUseing:0];
                
            }

        }
        else if(indexPath.column==1){
            //默认
            if (indexPath.row==0) {
                
                isCertificationOrOnCall=@"默认";


            }//已认证
            else if (indexPath.row==1){
                
                isCertificationOrOnCall=@"已认证";
            
            }//热门
            else if (indexPath.row==2){
                isCertificationOrOnCall=@"热门";
    
                
            }//上门
            else if (indexPath.row==3){
                isCertificationOrOnCall=@"上门";
                
            }
            
            
        }
    //显示刷新控件
    [self.shTableView headerBeginRefreshing];
    //请求服务器数据
     [self business:[_formHomeData objectAtIndex:2]:distanceUseing:0];
    
    //刷新表格
       [self.shTableView reloadData];
       _currentData1Index=indexPath.row;
       _currentData2Index=indexPath.row;
}


- (IBAction)LocalBack_bt:(id)sender {
    

    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
  
}
//手动刷新地理位置
- (IBAction)refreshLocation:(id)sender {
    
    //百度地图定位
    
    [bdmapVC baiduMapLocationL];
    [bdmapVC startLocation];
    
    
    
    self.refresh_ol.hidden=YES;
    self.refresh_sta.hidden=NO;
    self.refresh_sta.hidesWhenStopped=YES;
    
    [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(refreshHiden) userInfo:nil repeats:NO];
    [self.refresh_sta startAnimating];
}

-(void)refreshHiden{

    self.showAdress.text= locationDelegate.theAddress;
   self.refresh_ol.hidden=NO;
   [self.refresh_sta stopAnimating];
    
}

-(void)didReceiveMemoryWarning{
    
   [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (IBAction)jionInUs_bt:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",BUSINESSADDPHONE]]];
    
}
@end
