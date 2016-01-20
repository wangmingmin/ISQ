////
//  HomeViewController.m
//  ISQ
//
//  Created by mac on 15-3-12.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "HomeViewController.h"
#import "ConstantFileld.h"
#import "AppDelegate.h"
#import "ApplyViewController.h"
#import "CitySelectController.h"
#import "CommunitySelectController.h"
#import "UIImageView+AFNetworking.h"
#import "BDMLocationController.h"
#import "SeconWebController.h"
#import "ThreeWebController.h"
#import "SRRefreshView.h"
#import "ImgURLisFount.h"
#import "BusinessModle.h"
#import "AnnouncementCell.h"
#import "CategoryCell.h"
#import "OrderDetailCell.h"
#import "OrderCell.h"
#import "SeconWebController.h"
#import "HMAC-SHA1.h"
#import "OrderDetailModel.h"
#import "OrderDetailimageCell.h"

@interface HomeViewController()<IChatManagerDelegate,SRRefreshDelegate>{
    
    AppDelegate *HomeDelegate;
    NSArray *hornData;
    NSUserDefaults *saveCityName;
    NSArray *locationSelectData;
    NSMutableArray *locationEssenceAdRUL1;
    NSMutableArray *locationEssenceimgRight;
    NSInteger bannerNumFalt;
    BDMLocationController *bdmapVC;
    NSArray *businessData;
    NSArray *contentDic;
    OrderDetailModel *orderModel;
    NSDictionary *arrayDic;
}

@property (nonatomic,strong) NSArray *announcements;
@property (nonatomic,strong) SRRefreshView *homeSlimeView;    //首页刷新

@end

@implementation HomeViewController
@synthesize tabelview,HomeSelectCity_ol;
@synthesize searchView;
@synthesize topCenterView;


bool theTop=true;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:UPDATEAPPLYCOUNT object:nil];
    contentDic = [[NSArray alloc] init];
    self.tabelview.tableFooterView = [[UIView alloc] init];
    //记录城市选择或者定位的结果
    saveCityName=[NSUserDefaults standardUserDefaults];
    HomeDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self navigationControllerView];
    
    [self setupUnreadMessageCount];
    
    [self registerNotifications];
    
    self.announcements = [NSArray array];
    
    [self loadAnnouncementData];
    
    //百度地图定位
    bdmapVC=[[BDMLocationController alloc]init];
    [bdmapVC baiduMapLocationL];
    [bdmapVC startLocation];
   
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //刷新
    [self.tabelview addSubview:self.homeSlimeView];
    [self addFooter];
}


- (void)loadNewThingDetailData{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    //获取cid
    NSString *communityID = [NSString stringWithFormat:@"%@",([saveCityName objectForKey:userCommunityID]?[saveCityName objectForKey:userCommunityID]:@"717")];
    //5-15位随机字符
    NSString *nonce = [NSString stringWithFormat:@"nonce=%@",[HMAC_SHA1 randomNonce]];
    //时间
    NSString *timestamp = [NSString stringWithFormat:@"timestamp=%@",[HMAC_SHA1 getTime]];
    [array addObject:timestamp];
    [array addObject:nonce];
    [array addObject:@"name=news"];
    [array addObject:@"action=news_lists"];
    //key--Q2sE#FeNK8%6awIO,signature为加密后字符串
    NSString *signature = [HMAC_SHA1 hmac_sha1:@"Q2sE#FeNK8%6awIO" parames:array url:@"http://webapp.wisq.cn/api"];

    NSString *url = [NSString stringWithFormat:@"%@%@&%@&name=%@&action=%@&cid=%@&page=%@&num=%@&signature=%@",@"http://webapp.wisq.cn/api?",timestamp,nonce,@"news",@"news_lists",communityID,@"1",@"10",signature];
    
    [ISQHttpTool getHttp:url contentType:nil params:nil success:^(id responseObject) {
        
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
       
            contentDic = [dic objectForKey:@"data"][@"content"];
        
      
        
        [self.tabelview reloadData];
        
    } failure:^(NSError *erro) {
        
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self loadNewThingDetailData];
}


- (void)loadAnnouncementData{

    [ISQHttpTool getHttp:getHomePic contentType:nil params:nil success:^(id responseObject) {
        NSData *thaData = responseObject;
        NSArray *dataArr = [[NSArray alloc] init];
        dataArr = [NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil];
        self.announcements = dataArr;
        [self.tabelview reloadData];

    } failure:^(NSError *erro) {
        
    }];
}



-(void)viewDidAppear:(BOOL)animated{
    
    
    if([saveCityName objectForKey:@"saveCommunityName"]){
        
        [self.HomeSelectCity_ol setTitle:[NSString stringWithFormat:@"%@%@",[saveCityName objectForKey:userCityName],[saveCityName objectForKey:saveCommunityName]] forState:UIControlStateNormal];
 
    }else {
        
        [self.HomeSelectCity_ol setTitle:@"请选择社区" forState:UIControlStateNormal];
        
    }
    
    //首页广告图
    [self.tabelview reloadData];
    
}


//刷新

- (SRRefreshView *)homeSlimeView{
    
    if (!_homeSlimeView) {
        _homeSlimeView = [[SRRefreshView alloc] init];
        _homeSlimeView.delegate = self;
        _homeSlimeView.upInset = 0;
        _homeSlimeView.slimeMissWhenGoingBack = YES;
        _homeSlimeView.slime.bodyColor = [UIColor grayColor];
        _homeSlimeView.slime.skinColor = [UIColor grayColor];
        _homeSlimeView.slime.lineWith = 1;
        _homeSlimeView.slime.shadowBlur = 4;
        _homeSlimeView.slime.shadowColor = [UIColor grayColor];
        _homeSlimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _homeSlimeView;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [_homeSlimeView scrollViewDidScroll];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [_homeSlimeView scrollViewDidEndDraging];
}


#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView{

    if (_homeSlimeView == refreshView) {
        
        [self loadAnnouncementData];
        [self loadNewThingDetailData];
        
        [_homeSlimeView endRefresh];
    }
}

#pragma mark - 上拉加载更多

- (void)addFooter{

   __unsafe_unretained typeof(self) vc = self;
    [self.tabelview addFooterWithCallback:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadNewThingDetailData];
            [self loadAnnouncementData];
            
            //刷新结束
            [vc.tabelview footerEndRefreshing];
            
        });
    }];
}


#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

#pragma mark - IChatMangerDelegate
//监听未读消息变化
-(void)didUnreadMessagesCountChanged
{
    
    [self setupUntreatedApplyCount];
    
    
}

//统计未读消息数(包括申请等)
- (void)setupUntreatedApplyCount
{
    
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger m_unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        m_unreadCount += conversation.unreadMessagesCount;
    }
    
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    NSString *badgeValue = [NSString stringWithFormat:@"%li",(long)unreadCount+m_unreadCount];
    int indexICareAbout = 2;
    if (unreadCount+m_unreadCount>0) {
        [[[[[self tabBarController] viewControllers] objectAtIndex: indexICareAbout] tabBarItem] setBadgeValue:badgeValue];
    }else{
        
        [[[[[self tabBarController] viewControllers] objectAtIndex: indexICareAbout] tabBarItem] setBadgeValue:nil];
    }
    
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:m_unreadCount+unreadCount];
    
}


-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
}


//navigationController的导航栏
-(void)navigationControllerView{
    
    
    //社区显示框,文字居中
    self.HomeSelectCity_ol.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    
    
    //去掉导航栏黑线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    //navigationItem的中部位置
    CustomBarItem *centerView=[self.navigationItem setItemWithCustomView:searchView itemType:center];
    
    CGRect rect=self.topCenterView.frame;
    
    double bili=0.60;//社区选择 的宽度比例
    int bianyi=0;//社区选择 的偏移量
    //    if (UISCREENWIDTH>374) {
    //        bili=0.65;
    //        bianyi=-16;
    //    }
    rect.size.width=UISCREENWIDTH*bili;
    self.topCenterView.frame=rect;
    [centerView  setOffset:bianyi];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (contentDic.count==2) {
        return 7;
        
    }else if (contentDic.count>2) {
        return 8;
    }
    else if (contentDic.count==1) {
        return 6;
    }
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return UISCREENWIDTH*0.50133333;
    }
    else if (indexPath.row==2){
        
        return 170;
    }
    else if (indexPath.row == 1 || indexPath.row == 3){
        return 10;
    }
    else if (indexPath.row == 4){
        return 35;
    }
    return 90;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AnnouncementCell *announcementCell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
        announcementCell.announcements = self.announcements;
        
        return announcementCell;
    }else if (indexPath.row == 1 || indexPath.row == 3){
        UITableViewCell * intervalCell = [tableView dequeueReusableCellWithIdentifier:@"intervalCell"];

        return intervalCell;
    }else if (indexPath.row == 2){
        CategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        [categoryCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return categoryCell;
    }else if (indexPath.row >=5&&contentDic.count>=1){
        
        if(contentDic.count>0){
            orderModel = [OrderDetailModel objectWithKeyValues:contentDic[indexPath.row-5]];
            
            if(orderModel.newstitlepic.length>0){
                
                OrderDetailimageCell *orderDetailimageCell=[tableView dequeueReusableCellWithIdentifier:@"orderDetailimageCell"];
                orderDetailimageCell.titleLabel.text = [NSString stringWithFormat:@"%@",orderModel.newstitle];
                orderDetailimageCell.timeLabel.text = [NSString stringWithFormat:@"%@",orderModel.newsaddtime];
                
                NSURL *imgUrl=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",orderModel.newstitlepic]];
                [orderDetailimageCell.detailImage setImageWithURL:imgUrl];
                
                // 调整行间距
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:orderModel.newssmalltext];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:4];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [orderModel.newssmalltext length])];
                orderDetailimageCell.detailLabel.attributedText = attributedString;
                return orderDetailimageCell;
                
                
            }else{
                
                
                OrderDetailCell *orderDetailCell=[tableView dequeueReusableCellWithIdentifier:@"orderDetailCell"];
                orderDetailCell.orderTitle.text = orderModel.newstitle;
                orderDetailCell.timeLabel.text = orderModel.newsaddtime;
                
                orderDetailCell.detailLabel.font = [UIFont systemFontOfSize:14];
                orderDetailCell.detailLabel.text = orderModel.newssmalltext;
                
                return orderDetailCell;
            }
            
            
        }
    }
    
    
    OrderCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    
    return titleCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AppDelegate *locationCityDelegate;
     locationCityDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //美食
    if ([[segue identifier] isEqualToString:@"foodAction"]){
      
        NSString *url = [NSString stringWithFormat:@"%@%f,%f.html",RestaurantURL,locationCityDelegate.theLa,locationCityDelegate.theLo];
        
        SeconWebController *webVC = [segue destinationViewController];
        webVC.theUrl = url;
        
    //家政
    }else if ([[segue identifier] isEqualToString:@"housekeeping"]){
        
        NSString *url = [NSString stringWithFormat:@"%@%f,%f.html",housekeepingURL,locationCityDelegate.theLa,locationCityDelegate.theLo];
        SeconWebController *webVC = [segue destinationViewController];
        webVC.theUrl = url;
        
    //医疗
    }else if ([[segue identifier] isEqualToString:@"Medical"]){
    
        NSString *url = [NSString stringWithFormat:@"%@%f,%f.html",MedicalURL,locationCityDelegate.theLa,locationCityDelegate.theLo];
        SeconWebController *webVC = [segue destinationViewController];
        webVC.theUrl = url;
        
    //居委会
    }else if ([[segue identifier] isEqualToString:@"committee"]){
        NSString *url = [NSString stringWithFormat:@"%@%f,%f.html",officeURL,locationCityDelegate.theLa,locationCityDelegate.theLo];
        SeconWebController *webVC = [segue destinationViewController];
        webVC.theUrl = url;
        
    //物业
    }else if ([[segue identifier] isEqualToString:@"tenement"]){
        SeconWebController *webVC = [segue destinationViewController];
        if ([[saveCityName objectForKey:saveCommunityName] hasPrefix:@"百步亭"]) {
            
            NSString *url = [NSString stringWithFormat:@"%@%@%@",@"http://webapp.wisq.cn/property/index/uid/",[saveCityName objectForKey:MyUserID],@".html"];
            webVC.theUrl = url;
        }else{
            NSString *url = [NSString stringWithFormat:@"%@",tenementURL];
            webVC.theUrl = url;
        }
        
   //议事厅
    }else if ([[segue identifier] isEqualToString:@"discuss"]){        
        SeconWebController *webVC = [segue destinationViewController];
        if ([[saveCityName objectForKey:saveCommunityName] hasPrefix:@"百步亭"]) {
            webVC.theUrl = discuss;
        }else{
            NSString *url = [NSString stringWithFormat:@"%@",tenementURL];
            webVC.theUrl = url;
        }

    //新鲜事
    }else if ([[           segue identifier] isEqualToString:@"communityNewThing"]){
        NSString *communityID = [saveCityName objectForKey:userCommunityID];
        NSString *url = [NSString stringWithFormat:@"%@%@",communityNewThing,communityID];
        SeconWebController *webVC = [segue destinationViewController];
        webVC.theUrl = url;
        
    //新鲜事列表进入详情
    }else if ([[segue identifier] isEqualToString:@"news_text"]){
        
        NSIndexPath *indexPath=[self.tabelview indexPathForSelectedRow];
        orderModel = [OrderDetailModel objectWithKeyValues:contentDic[indexPath.row-5]];
        NSString *nid = orderModel.newsid;
        NSString *url = [NSString stringWithFormat:@"%@/nid/%@",@"http://webapp.wisq.cn/Communitynews/detail/",nid];
        SeconWebController *webVC = [segue destinationViewController];
        webVC.theUrl = url;
        
    }
}

- (IBAction)HomeSelectCity_bt:(id)sender {
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
    CitySelectController *citySelectVC=[storyBoard instantiateViewControllerWithIdentifier:@"SeclecticCityId"];
    
    [citySelectVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController  pushViewController:citySelectVC animated:YES];
}



//时间戳转时间
-(NSString*)timeTurn:(NSString*)theTime{
    
    double lastactivityInterval = [theTime doubleValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"M月dd日"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


//统计未读消息数(包括申请等)
- (void)setupUnreadMessageCount
{
    
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger m_unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        m_unreadCount += conversation.unreadMessagesCount;
    }
    
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    NSString *badgeValue = [NSString stringWithFormat:@"%li",(long)unreadCount+m_unreadCount];
    int indexICareAbout = 2;
    if (unreadCount+m_unreadCount>0) {
        [[[[[self tabBarController] viewControllers] objectAtIndex: indexICareAbout] tabBarItem] setBadgeValue:badgeValue];
    }else{
        
        [[[[[self tabBarController] viewControllers] objectAtIndex: indexICareAbout] tabBarItem] setBadgeValue:nil];
        
    }
    
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:m_unreadCount+unreadCount];
    
    
    
}

@end
