//
//  zhanBoViewController.m
//  chuanwanList
//
//  Created by 123 on 15/12/3.
//  Copyright © 2015年 wang. All rights reserved.
//

#import "zhanBoViewController.h"
#import "CollectionViewLayoutZhanBo.h"
#import "zhanBo_CollectionViewCell.h"
#import "ISQHttpTool.h"
#import "VideoDetailController_forSpring.h"
#import "HotVideoModel.h"
#import "MainViewController.h"
#import "SeconWebController.h"
#import "SRRefreshView.h"
static NSString * const reuseIdentifier = @"cell";
#define backColor [UIColor groupTableViewBackgroundColor]

@interface zhanBoViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,VideoDetailController_forSpringDelegate,SRRefreshDelegate>
@property (nonatomic, strong) UIScrollView * allScrollView;//节目列表总视图
@property (nonatomic, strong) UIView * tabBarView;//春晚简介，最新动态，投票规则
@property (weak, nonatomic) IBOutlet UIImageView *imageView;//赶紧来报名吧
@property (weak, nonatomic) IBOutlet UIView *topButtonsView;//当前市、看专场、排行榜、我关注
@property (nonatomic, strong) UIButton * introduceBtn;//春晚简介
@property (nonatomic, strong) UIButton * trendsBtn;//最新动态
@property (nonatomic, strong) UIButton * voteBtn;//投票规则
@property (nonatomic, strong) UIView * movingView;

@property (nonatomic, strong) NSArray * arrayDataCity;
@property (nonatomic, strong) NSArray * arrayDataSpecial;
@property (nonatomic, strong) NSArray * arrayDataRank;
@property (nonatomic, strong) NSArray * arrayDataFollow;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *specialBtn;
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) VideoDetailController_forSpring *videoDetail;
@property (nonatomic, strong) SRRefreshView *slimeViewCity;
@property (nonatomic, strong) SRRefreshView *slimeViewSpecial;
@property (nonatomic, strong) SRRefreshView *slimeViewRank;
@property (nonatomic, strong) SRRefreshView *slimeViewFollow;
@end

@implementation zhanBoViewController
{
    CGFloat screenHeight;
    CGFloat screenWidth;
    CGFloat tabBarHeight;
    CGFloat tabBarWidth;
    
    UICollectionView * CityCollectionView;//当前市
    UICollectionView * SpecialCollectionView;//看专场
    UICollectionView * RankCollectionView;//排行榜
    UICollectionView * FollowCollectionView;//我关注
    
    NSString * showBanner;
    
    BOOL isAddRefresh;//是否row的行数多加10后再刷新，如果是no则依然获取相同数量的数据
    BOOL isPullRefresh;//是否下拉刷新
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    tabBarWidth = self.tabBarController.tabBar.frame.size.width;
    self.view.backgroundColor = backColor;
    isAddRefresh = YES;
    isPullRefresh = NO;
    
    UITapGestureRecognizer * tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapImageView];
}

-(void)tapImageView:(UIGestureRecognizer *)sender
{
    SeconWebController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
    webVC.theUrl = @"http://webapp.wisq.cn/Spring/index";
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark 上拉加载更多
- (void)addFooter
{
    __block UICollectionView * vc = CityCollectionView;
    __block UICollectionView * vc2 = SpecialCollectionView;
    __block UICollectionView * vc3 = RankCollectionView;
    __block UICollectionView * vc4 = FollowCollectionView;

    // 添加上拉刷新尾部控件
    [CityCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新
            [vc footerEndRefreshing];
        });
    }];
    // 添加上拉刷新尾部控件
    [SpecialCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新
            [vc2 footerEndRefreshing];
        });
    }];
    // 添加上拉刷新尾部控件
    [RankCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新
            [vc3 footerEndRefreshing];
        });
    }];
    // 添加上拉刷新尾部控件
    [FollowCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新
            [vc4 footerEndRefreshing];
        });
    }];

}

#pragma mark - 刷新

- (SRRefreshView *)slimeViewCity
{
    if (!_slimeViewCity) {
        _slimeViewCity = [[SRRefreshView alloc] init];
        _slimeViewCity.delegate = self;
        _slimeViewCity.upInset = 0;
        _slimeViewCity.slimeMissWhenGoingBack = YES;
        _slimeViewCity.slime.bodyColor = [UIColor grayColor];
        _slimeViewCity.slime.skinColor = [UIColor grayColor];
        _slimeViewCity.slime.lineWith = 1;
        _slimeViewCity.slime.shadowBlur = 4;
        _slimeViewCity.slime.shadowColor = [UIColor grayColor];
        _slimeViewCity.backgroundColor = self.view.backgroundColor;
        
    }
    return _slimeViewCity;
}
- (SRRefreshView *)slimeViewFollow
{
    if (!_slimeViewFollow) {
        _slimeViewFollow = [[SRRefreshView alloc] init];
        _slimeViewFollow.delegate = self;
        _slimeViewFollow.upInset = 0;
        _slimeViewFollow.slimeMissWhenGoingBack = YES;
        _slimeViewFollow.slime.bodyColor = [UIColor grayColor];
        _slimeViewFollow.slime.skinColor = [UIColor grayColor];
        _slimeViewFollow.slime.lineWith = 1;
        _slimeViewFollow.slime.shadowBlur = 4;
        _slimeViewFollow.slime.shadowColor = [UIColor grayColor];
        _slimeViewFollow.backgroundColor = self.view.backgroundColor;
        
    }
    return _slimeViewFollow;
}
- (SRRefreshView *)slimeViewSpecial
{
    if (!_slimeViewSpecial) {
        _slimeViewSpecial = [[SRRefreshView alloc] init];
        _slimeViewSpecial.delegate = self;
        _slimeViewSpecial.upInset = 0;
        _slimeViewSpecial.slimeMissWhenGoingBack = YES;
        _slimeViewSpecial.slime.bodyColor = [UIColor grayColor];
        _slimeViewSpecial.slime.skinColor = [UIColor grayColor];
        _slimeViewSpecial.slime.lineWith = 1;
        _slimeViewSpecial.slime.shadowBlur = 4;
        _slimeViewSpecial.slime.shadowColor = [UIColor grayColor];
        _slimeViewSpecial.backgroundColor = self.view.backgroundColor;
        
    }
    return _slimeViewSpecial;
}
- (SRRefreshView *)slimeViewRank
{
    if (!_slimeViewRank) {
        _slimeViewRank = [[SRRefreshView alloc] init];
        _slimeViewRank.delegate = self;
        _slimeViewRank.upInset = 0;
        _slimeViewRank.slimeMissWhenGoingBack = YES;
        _slimeViewRank.slime.bodyColor = [UIColor grayColor];
        _slimeViewRank.slime.skinColor = [UIColor grayColor];
        _slimeViewRank.slime.lineWith = 1;
        _slimeViewRank.slime.shadowBlur = 4;
        _slimeViewRank.slime.shadowColor = [UIColor grayColor];
        _slimeViewRank.backgroundColor = self.view.backgroundColor;
        
    }
    return _slimeViewRank;
}

-(void)viewDidLayoutSubviews//storyboard中view的所有维度在layoutSubviews时会被计算和设置
{
    [super viewDidLayoutSubviews];
    if (self.tabBarView == nil && self.allScrollView == nil && self.movingView== nil) {
        [self initTabBarView];
        [self initAllScrollView];
        [self initMovingView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkWhichOneIsOnSelect:0];
    if (self.movingView != nil) {
        int pageNumber = self.movingView.center.x/(screenWidth/4);
        [self checkWhichOneIsOnSelect:pageNumber];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTabBarView
{
    self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-tabBarHeight, tabBarWidth, tabBarHeight)];
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBarView];
    
    self.introduceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tabBarWidth/3.0, tabBarHeight)];
    [self.introduceBtn setTitle:@"春晚简介" forState:UIControlStateNormal];
    [self.introduceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.introduceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.tabBarView addSubview:self.introduceBtn];
    
    self.trendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(tabBarWidth/3.0, 0, tabBarWidth/3.0, tabBarHeight)];
    [self.trendsBtn setTitle:@"最新动态" forState:UIControlStateNormal];
    [self.trendsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.trendsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.tabBarView addSubview:self.trendsBtn];

    self.voteBtn = [[UIButton alloc] initWithFrame:CGRectMake(tabBarWidth/3.0*2.0, 0, tabBarWidth/3.0, tabBarHeight)];
    [self.voteBtn setTitle:@"投票规则" forState:UIControlStateNormal];
    [self.voteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.voteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.tabBarView addSubview:self.voteBtn];

    self.introduceBtn.titleLabel.font = self.trendsBtn.titleLabel.font =self.voteBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    
    for (int i = 1; i < 3; i++) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(tabBarWidth/3.0*i-0.5, 5, 1, tabBarHeight-10)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.tabBarView addSubview:line];
    }

    [self.introduceBtn addTarget:self action:@selector(OnIntroduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.trendsBtn addTarget:self action:@selector(OnTrendsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.voteBtn addTarget:self action:@selector(OnVoteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)initAllScrollView//初始化列表总视图
{
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, screenWidth, screenWidth/(750.0/71.0));
    
    CGFloat scrollViewOriginY = self.imageView.frame.origin.y+ self.imageView.frame.size.height;
    self.allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewOriginY, screenWidth, screenHeight-scrollViewOriginY-tabBarHeight)];
    self.allScrollView.contentSize = CGSizeMake(screenWidth*4, self.allScrollView.contentSize.height);
    self.allScrollView.pagingEnabled = YES;
    self.allScrollView.backgroundColor = backColor;
    self.allScrollView.delegate = self;
    self.allScrollView.bounces = NO;
    self.allScrollView.showsVerticalScrollIndicator = NO;
    self.allScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.allScrollView];

    [self initCityCollectionView];
    [self initSpecialCollectionView];
    [self initRankCollectionView];
    [self initFollowCollectionView];
    
    [self addFooter];
}

-(void)initMovingView
{
    [self.movingView removeFromSuperview];
    CGFloat topButtonViewHeight = self.topButtonsView.frame.size.height;

    CGFloat movingViewOriginY = topButtonViewHeight-3;
    self.movingView = [[UIView alloc] initWithFrame:CGRectMake(2, movingViewOriginY, screenWidth/4.0-4, 3)];
    self.movingView.backgroundColor = [UIColor colorWithRed:51.0/255 green:167.0/255 blue:245.0/255 alpha:1];
    [self.topButtonsView addSubview:self.movingView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==CityCollectionView) {
        [_slimeViewCity scrollViewDidScroll];
    }
    if (scrollView==SpecialCollectionView) {
        [_slimeViewSpecial scrollViewDidScroll];
    }
    if (scrollView==RankCollectionView) {
        [_slimeViewRank scrollViewDidScroll];
    }
    if (scrollView==FollowCollectionView) {
        [_slimeViewFollow scrollViewDidScroll];
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.allScrollView) {
        CGFloat offX = scrollView.contentOffset.x;
        int currentPage = offX/scrollView.frame.size.width;
        [self checkWhichOneIsOnSelect:currentPage];
        [UIView animateWithDuration:0.2 animations:^{
            self.movingView.center = CGPointMake(2+screenWidth/8.0+currentPage*screenWidth/4.0, self.movingView.center.y);
        }];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offY = scrollView.contentOffset.y;
    
    if (scrollView == CityCollectionView) {
        if (offY > CityCollectionView.contentSize.height-CityCollectionView.frame.size.height+50) {
            [self refreshCity];
        }
        [_slimeViewCity scrollViewDidEndDraging];
    }
    if (scrollView == SpecialCollectionView) {
        if (offY > SpecialCollectionView.contentSize.height-SpecialCollectionView.frame.size.height+50) {
            [self refreshSpecial];
        }
        [_slimeViewSpecial scrollViewDidEndDraging];
    }
    if (scrollView == RankCollectionView) {
        if (offY > RankCollectionView.contentSize.height-RankCollectionView.frame.size.height+50) {
            [self refreshRank];
        }
        [_slimeViewRank scrollViewDidEndDraging];
    }
    if (scrollView == FollowCollectionView) {
        if (offY > FollowCollectionView.contentSize.height-FollowCollectionView.frame.size.height+50) {
            [self refreshFollow];
        }
        [_slimeViewFollow scrollViewDidEndDraging];
    }
    if (scrollView!=self.allScrollView) {
        if (offY<-88) {
            isPullRefresh = YES;
        }
    }
}

#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    CGFloat offX = self.allScrollView.contentOffset.x;
    int currentPage = offX/self.allScrollView.frame.size.width;
    if (currentPage == 0) [self.slimeViewCity endRefresh];
    if (currentPage == 1) [self.slimeViewSpecial endRefresh];
    if (currentPage == 2) [self.slimeViewRank endRefresh];
    if (currentPage == 3) [self.slimeViewFollow endRefresh];
}

-(void)slimeRefreshEndRefresh:(SRRefreshView *)refreshView
{
    if (isPullRefresh) {
        isPullRefresh = NO;
        CGFloat offX = self.allScrollView.contentOffset.x;
        int currentPage = offX/self.allScrollView.frame.size.width;
        if (currentPage == 0) [self refreshCity];
        if (currentPage == 1) [self refreshSpecial];
        if (currentPage == 2) [self refreshRank];
        if (currentPage == 3) [self refreshFollow];
    }
}

- (IBAction)onCurrentCity:(UIButton *)sender {
    [self movingByButton:sender.tag];
}

- (IBAction)onSpecial:(UIButton *)sender {
    [self movingByButton:sender.tag];
}

- (IBAction)onRank:(UIButton *)sender {
    [self movingByButton:sender.tag];
}

- (IBAction)onFollow:(UIButton *)sender {
    [self movingByButton:sender.tag];
}

-(void)movingByButton:(NSInteger)pageNumber
{
    [self checkWhichOneIsOnSelect:pageNumber];
    [UIView animateWithDuration:0.2 animations:^{
        self.movingView.center = CGPointMake(2+screenWidth/8.0+pageNumber*screenWidth/4.0, self.movingView.center.y);
        self.allScrollView.contentOffset = CGPointMake(pageNumber*screenWidth, self.allScrollView.contentOffset.y);
    }];

}

-(void)checkWhichOneIsOnSelect:(NSInteger)pageNumber
{
    self.cityBtn.selected = pageNumber==0?YES:NO;
    self.specialBtn.selected = pageNumber==1?YES:NO;
    self.rankBtn.selected = pageNumber==2?YES:NO;
    self.followBtn.selected = pageNumber==3?YES:NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma 展播列表视图
-(void)initCityCollectionView
{
    CollectionViewLayoutZhanBo *flowLayout =[[CollectionViewLayoutZhanBo alloc]init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height) collectionViewLayout:flowLayout];

    CityCollectionView.dataSource = self;
    CityCollectionView.delegate = self;
    CityCollectionView.showsVerticalScrollIndicator = NO;
    [self.allScrollView addSubview:CityCollectionView];
    
    CityCollectionView.backgroundColor = backColor;
    [CityCollectionView addSubview:self.slimeViewCity];
}

-(void)initSpecialCollectionView
{
    CollectionViewLayoutZhanBo *flowLayout =[[CollectionViewLayoutZhanBo alloc]init];
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    SpecialCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(screenWidth, 0, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height) collectionViewLayout:flowLayout];
    
    SpecialCollectionView.dataSource = self;
    SpecialCollectionView.delegate = self;
    SpecialCollectionView.showsVerticalScrollIndicator = NO;
    [self.allScrollView addSubview:SpecialCollectionView];
    
    SpecialCollectionView.backgroundColor = backColor;
    [SpecialCollectionView addSubview:self.slimeViewSpecial];
}

-(void)initRankCollectionView
{
    CollectionViewLayoutZhanBo *flowLayout =[[CollectionViewLayoutZhanBo alloc]init];
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    RankCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(screenWidth*2, 0, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height) collectionViewLayout:flowLayout];
    
    RankCollectionView.dataSource = self;
    RankCollectionView.delegate = self;
    RankCollectionView.showsVerticalScrollIndicator = NO;
    [self.allScrollView addSubview:RankCollectionView];
    
    RankCollectionView.backgroundColor = backColor;
    [RankCollectionView addSubview:self.slimeViewRank];
}

-(void)initFollowCollectionView
{
    CollectionViewLayoutZhanBo *flowLayout =[[CollectionViewLayoutZhanBo alloc]init];
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    FollowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(screenWidth*3, 0, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height) collectionViewLayout:flowLayout];
    
    FollowCollectionView.dataSource = self;
    FollowCollectionView.delegate = self;
    FollowCollectionView.showsVerticalScrollIndicator = NO;
    [self.allScrollView addSubview:FollowCollectionView];
    
    FollowCollectionView.backgroundColor = backColor;
    [FollowCollectionView addSubview:self.slimeViewFollow];
}

#pragma mark <UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (collectionView == CityCollectionView) {
        count = self.arrayDataCity.count;
    }
    if (collectionView == SpecialCollectionView) {
        count = self.arrayDataSpecial.count;
    }
    if (collectionView == RankCollectionView) {
        count = self.arrayDataRank.count;
    }
    if (collectionView == FollowCollectionView) {
        count = self.arrayDataFollow.count;
    }

    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *data = [[NSArray alloc] init];
    
    if (collectionView == CityCollectionView) {
        data = self.arrayDataCity;
    }
    if (collectionView == SpecialCollectionView) {
        data = self.arrayDataSpecial;
    }
    if (collectionView == RankCollectionView) {
        data = self.arrayDataRank;
    }
    if (collectionView == FollowCollectionView) {
        data = self.arrayDataFollow;
    }

    NSDictionary * dataIndexDic = data[indexPath.row];
    [collectionView registerClass:[zhanBo_CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    zhanBo_CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1].CGColor;
    cell.layer.borderWidth = 0.8;
    
    cell.title.text = [NSString stringWithFormat:@"%@",dataIndexDic[@"title"]];
    cell.address.text = [NSString stringWithFormat:@"选送单位:%@",dataIndexDic[@"address"]];
    cell.voteNum.text = [NSString stringWithFormat:@"%ld",[dataIndexDic[@"voteNum"] integerValue]];
    
    cell.tag = [dataIndexDic[@"activeID"] integerValue];
    cell.shareBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(onShareVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * imageUrlStr = dataIndexDic[@"image"];
    if (imageUrlStr.length != 0) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [ISQHttpTool getHttp:imageUrlStr contentType:nil params:nil success:^(id image) {
                // 耗时的操作
                UIImage * image2 = [UIImage imageWithData:image];//120:90
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    cell.imageView.image = image2;
                });
            } failure:^(NSError *erro) {
                
            }];
            
        });

    }

    return cell;
}

#pragma 点击观看
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSInteger activeID = cell.tag;
    NSLog(@"NSInteger activeID = %ld",(long)activeID);
    
    NSArray *data = [[NSArray alloc] init];
    
    if (collectionView == CityCollectionView) {
        data = self.arrayDataCity;
    }
    if (collectionView == SpecialCollectionView) {
        data = self.arrayDataSpecial;
    }
    if (collectionView == RankCollectionView) {
        data = self.arrayDataRank;
    }
    if (collectionView == FollowCollectionView) {
        data = self.arrayDataFollow;
    }
    NSDictionary * dataIndexDic = data[indexPath.row];

    NSString * strUrl = [NSString stringWithFormat:@"%@activeID=%@&userAccount=%@",httpDetailServer,dataIndexDic[@"activeID"],[user_info objectForKey:userAccount]];
    [ISQHttpTool getHttp:strUrl contentType:nil params:nil success:^(id res) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
//        NSLog(@"resDic ************   %@",dic);
        NSDictionary * dataNeed = dic[@"retData"];
        
        UIViewController * palyView = [[UIViewController alloc] init];
        palyView.view.frame = self.view.frame;
        palyView.edgesForExtendedLayout = UIRectEdgeNone;
        palyView.view.backgroundColor = [UIColor whiteColor];
        self.videoDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetail_forSpring"];
        palyView.title= self.videoDetail.title=dataNeed[@"title"];
        self.videoDetail.httpData=dataNeed;
        self.videoDetail.delegate = self;
        [self.navigationController pushViewController:palyView animated:YES];
        [palyView addChildViewController:self.videoDetail];
        [palyView.view addSubview:self.videoDetail.view];

    } failure:^(NSError *erro) {
        //如果失败换一个数据dataIndexDic
        UIViewController * palyView = [[UIViewController alloc] init];
        palyView.view.frame = self.view.frame;
        palyView.edgesForExtendedLayout = UIRectEdgeNone;
        palyView.view.backgroundColor = [UIColor whiteColor];
        self.videoDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetail_forSpring"];
        palyView.title= self.videoDetail.title=dataIndexDic[@"title"];
        self.videoDetail.httpData=dataIndexDic;
        self.videoDetail.delegate = self;
        [self.navigationController pushViewController:palyView animated:YES];
        [palyView addChildViewController:self.videoDetail];
        [palyView.view addSubview:self.videoDetail.view];

    }];
}

-(void)VideoDetailController_forSpringIsFinshedRefresh//投票刷新
{
    CGFloat offX = self.allScrollView.contentOffset.x;
    int currentPage = offX/self.allScrollView.frame.size.width;
    isAddRefresh = NO;
    if (currentPage == 0) [self refreshCity];
    if (currentPage == 1) [self refreshSpecial];
    if (currentPage == 2) [self refreshRank];
    if (currentPage == 3) [self refreshFollow];
}

-(void)VideoDetailController_forSpringIsFinshedFollow//关注刷新
{
    [self refreshFollow];
}
#pragma 点击分享
-(void)onShareVideo:(UIButton *)button
{
    NSArray *data = [[NSArray alloc] init];
    int pageNumber = self.movingView.center.x/(screenWidth/4);

    if (pageNumber==0) {
        data = self.arrayDataCity;
    }
    if (pageNumber==1) {
        data = self.arrayDataSpecial;
    }
    if (pageNumber==2) {
        data = self.arrayDataRank;
    }
    if (pageNumber==3) {
        data = self.arrayDataFollow;
    }
    
    NSDictionary * dataIndexDic = data[button.tag];
    
    HotVideoModel * dataHot = [HotVideoModel objectWithKeyValues:dataIndexDic];
    
    NSMutableDictionary *shareDic=[NSMutableDictionary dictionary];
    NSString *imageurls = dataHot.image;
    NSArray * imgUrlArray = [imageurls componentsSeparatedByString:@","];
    shareDic[@"img"]= imgUrlArray?imgUrlArray[0]:@"";
    shareDic[@"title"]=dataHot.title;
    shareDic[@"desc"]=dataHot.detail;
    shareDic[@"url"]=@"";
    
    [MainViewController theShareSDK:shareDic];

}

-(void)OnIntroduceBtn:(UIButton *)button//春晚简介
{
    SeconWebController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
    webVC.theUrl = @"http://webapp.wisq.cn//hot/cwzb/type/cwjj";
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController pushViewController:webVC animated:YES];

}

-(void)OnTrendsBtn:(UIButton *)button//最新动态
{
    SeconWebController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
    webVC.theUrl = @"http://webapp.wisq.cn/springnews/lists";
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController pushViewController:webVC animated:YES];

}

-(void)OnVoteBtn:(UIButton *)button//投票规则
{
    SeconWebController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
    webVC.theUrl = @"http://webapp.wisq.cn/hot/cwzb/type/tpgz";
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController pushViewController:webVC animated:YES];

}


#pragma 网络访问
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.videoDetail != nil) {
        self.videoDetail.httpData=@{};
    }
    if (self.arrayDataCity == nil && self.arrayDataFollow==nil && self.arrayDataRank==nil && self.arrayDataSpecial==nil) {
        self.arrayDataCity = [[NSArray alloc] init];
        self.arrayDataSpecial = [[NSArray alloc] init];
        self.arrayDataRank = [[NSArray alloc] init];
        self.arrayDataFollow = [[NSArray alloc] init];
        [self refresh];
    }else{
        
    }
}

-(void)refresh
{
    [self refreshCity];
    [self refreshSpecial];
    [self refreshRank];
    [self refreshFollow];
}

-(void)refreshCity
{
    NSMutableDictionary *paramesCityID=[NSMutableDictionary dictionary];
    
    id cityID = [user_info objectForKey:userCityID];
    paramesCityID[@"cityId"]=cityID;

    NSString * httpUrl = [NSString stringWithFormat:@"%@type=city&row=%lu",getSpringVideoListServer,(self.arrayDataCity.count/10)*(isAddRefresh?10:1)];
    isAddRefresh = YES;
    [ISQHttpTool getHttp:httpUrl contentType:nil params:paramesCityID success:^(id res) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
//        NSLog(@"showVoide city===== %@",dic);
        self.arrayDataCity = dic[@"retData"];
        showBanner = [[NSString alloc] init];
        showBanner = dic[@"showBanner"];
        [CityCollectionView reloadData];
        [ISQHttpTool getHttp:showBanner contentType:nil params:nil success:^(id image) {
            UIImage * image2 = [UIImage imageWithData:image];
            self.imageView.image = image2;
        } failure:^(NSError *erro) {
            
        }];
    } failure:^(NSError *erro) {

    }];

}

-(void)refreshSpecial
{
    NSString * httpUrl = [NSString stringWithFormat:@"%@type=special&row=%lu",getSpringVideoListServer,(self.arrayDataSpecial.count/10)*(isAddRefresh?10:1)];
    isAddRefresh = YES;
    [ISQHttpTool getHttp:httpUrl contentType:nil params:nil success:^(id res) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
//        NSLog(@"showVoide special===== %@",dic);
        self.arrayDataSpecial = dic[@"retData"];
        [SpecialCollectionView reloadData];

    } failure:^(NSError *erro) {

    }];

}
-(void)refreshRank
{
    NSString * httpUrl = [NSString stringWithFormat:@"%@type=rank&row=%lu",getSpringVideoListServer,(self.arrayDataRank.count/10)*(isAddRefresh?10:1)];
    isAddRefresh = YES;
    [ISQHttpTool getHttp:httpUrl contentType:nil params:nil success:^(id res) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
//        NSLog(@"showVoide rank===== %@",dic);
        self.arrayDataRank = dic[@"retData"];
        [RankCollectionView reloadData];

    } failure:^(NSError *erro) {

    }];

}
-(void)refreshFollow
{
    NSMutableDictionary *paramesUserAccount=[NSMutableDictionary dictionary];

    id userAccountNumber = [user_info objectForKey:userAccount];
    paramesUserAccount[@"userAccount"]=userAccountNumber;

    NSString * httpUrl = [NSString stringWithFormat:@"%@type=follow&row=%lu",getSpringVideoListServer,(self.arrayDataFollow.count/10)*(isAddRefresh?10:1)];
    isAddRefresh = YES;
    [ISQHttpTool getHttp:httpUrl contentType:nil params:paramesUserAccount success:^(id res) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
//        NSLog(@"showVoide follow===== %@",dic);
        self.arrayDataFollow = dic[@"retData"];
        [FollowCollectionView reloadData];

    } failure:^(NSError *erro) {

    }];

}

@end
