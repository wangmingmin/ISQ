//
//  ActivityViewController.m
//  ISQ
//
//  Created by mac on 15-9-17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ActivityViewController.h"
#import "DropDownListView.h"
#import "UIViewExt.h"
#import "SearchBar.h"
#import "StartActivityViewController.h"
#import "ImageCell.h"
#import "videoCell.h"
#import "HotVideoModel.h"
#import "imageCellModel.h"
#import "VideoDetailController.h"
#import "AppDelegate.h"
//#import "ActivityDetailController.h"
#import "MJRefresh.h"
#import "SRRefreshView.h"
#import "hotCell.h"
#import "hotModel.h"
#import "TestJSObject.h"
#import "MainViewController.h"
#import "SeconWebController.h"
#import "ActivityDetailImgController.h"
#import "AnnouncementModel.h"
#import "zhanBoViewController.h"
@interface ActivityViewController ()<SRRefreshDelegate>

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) SearchBar *searchBar;
@property (nonatomic,strong) NSDictionary *tagDic;

@property (nonatomic, strong) SRRefreshView         *slimeView;     //附件刷新
@property (nonatomic, strong) SRRefreshView         *hotSlimeView;  //热门刷新

@end

@implementation ActivityViewController{

    BOOL isHotView;
    NSMutableArray *hotChooseArray;
    NSMutableArray *nearChooseArray;
    DropDownListView *hotDropDownView;
    DropDownListView *nearDropDownView;
    UIView *bgview;
    UIView *buttonView;
    NSMutableArray *nearData;
    NSUserDefaults *userInfo;
    NSMutableArray *fromHttpData;
    NSMutableArray *hotArray;
    NSDictionary *dic;
    HotVideoModel *data;
    NSString *joinData;
    NSInteger nearRows;
    AnnouncementModel *announcement;
    NSArray *arrayNormalImg;
    NSArray *arrayligtImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isHotView = YES;
    dic = [[NSDictionary alloc] init];
    bgview = [[UIView alloc]init];
   
    userInfo = [NSUserDefaults standardUserDefaults];
    fromHttpData=[[NSMutableArray alloc]init];
    bgview.backgroundColor = [UIColor clearColor];
    self.topbgView.backgroundColor = [UIColor clearColor];
    [self.navigationItem.titleView addSubview:bgview];
    [self.hotTableView setScrollEnabled:YES];
    self.hotTableView.dataSource = self;
    self.hotTableView.delegate = self;
    self.nearTableView.dataSource = self;
    self.nearTableView.delegate = self;
    self.hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nearTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hotContantView.hidden = NO;
    self.nearContantView.hidden = YES;
    
    arrayNormalImg=[[NSArray alloc ]initWithObjects:@"join",@"clickz",@"share", nil];
    arrayligtImg=[[NSArray alloc ]initWithObjects:@"joinSelected",@"clickzSelect",@"shareSelected", nil];
    [self showHudInView:self.view hint:@"正在加载..."];
    //获取热门数据
    [self loadHotListData];
    //附近数据
    
    [self loadNearListData:0];
    [self initNavigationView];
    
    //刷新
    [self.nearTableView addSubview:self.slimeView];
    [self.hotTableView addSubview:self.hotSlimeView];
    
    //上拉加载更多
    [self addFooter];
    
}


#pragma mark - initView

- (void)initNavigationView{
    self.searchBar = [SearchBar shareSearchBar];
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"search"] action:@selector(searchItemAction:)];
}

- (void)initNearHeaderView{
    nearChooseArray = [NSMutableArray arrayWithArray:@[@[@"排序",@"最多参与",@"最多分享",@"最多点赞"]]];
    nearDropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, 5, UISCREENWIDTH, 30) dataSource:self delegate:self];
    nearDropDownView.backgroundColor = [UIColor clearColor];
    nearDropDownView.mSuperView = self.view;
    [self.view addSubview:nearDropDownView];
    [hotDropDownView removeFromSuperview];
}

- (void)initStartActionView{
    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 40, 30)];
    [button2 setTitle:@"发起" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button1];
    [buttonView addSubview:button2];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}


#pragma mark - 刷新

//两个不同的tablevie所以分开比较好
- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    
    }
    
    return _slimeView;
}

- (SRRefreshView *)hotSlimeView{
    if (!_hotSlimeView) {
        _hotSlimeView = [[SRRefreshView alloc] init];
        _hotSlimeView.delegate = self;
        _hotSlimeView.upInset = 0;
        _hotSlimeView.slimeMissWhenGoingBack = YES;
        _hotSlimeView.slime.bodyColor = [UIColor grayColor];
        _hotSlimeView.slime.skinColor = [UIColor grayColor];
        _hotSlimeView.slime.lineWith = 1;
        _hotSlimeView.slime.shadowBlur = 4;
        _hotSlimeView.slime.shadowColor = [UIColor grayColor];
        _hotSlimeView.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    
    return _hotSlimeView;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    [_hotSlimeView scrollViewDidScroll];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
    [_hotSlimeView scrollViewDidEndDraging];
    
}

#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    
    if (_slimeView == refreshView) {
        
        //附近
        [self loadNearListData:0];
        
        [_slimeView endRefresh];
        
    }else if (_hotSlimeView == refreshView){
        
        //热门
        
        [self loadHotListData];
        
        [_hotSlimeView endRefresh];
    }
    
}
#pragma mark 上拉加载更多
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.nearTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self loadNearListData:nearRows];
            
            //结束刷新
            [vc.nearTableView footerEndRefreshing];
        });
    }];
    
}


#pragma mark - 获取数据

//获取热门数据
- (void)loadHotListData{

    [ISQHttpTool getHttp:getHotList contentType:nil params:nil success:^(id resposeObject) {
        
        hotArray = [NSMutableArray array];
        hotArray = [NSJSONSerialization JSONObjectWithData:resposeObject options:NSJapaneseEUCStringEncoding error:nil];
        fromHttpData = hotArray;
        
        [self hideHud];
        [self.hotTableView reloadData];
        
    } failure:^(NSError *erro) {
        
         [self hideHud];
        
       
    }];
}

//获取附近数据
- (void)loadNearListData:(NSInteger) rows{
    
    AppDelegate *locationCityDelegate;
    locationCityDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    CGFloat la = locationCityDelegate.theLa;
    CGFloat lo = locationCityDelegate.theLo;
    NSString *location_x = [NSString stringWithFormat:@"%f",la];
    NSString *location_y = [NSString stringWithFormat:@"%f",lo];
    NSString *account = [userInfo objectForKey:userAccount];
    NSDictionary *dict = @{@"location_x":location_x,@"location_y":location_y,@"userAccount":account,@"rows":[NSString stringWithFormat:@"%ld",(long)rows]};
    [ISQHttpTool getHttp:getNearActiveList contentType:nil params:dict success:^(id responseObject) {
       
        if (rows==0) {
            nearRows=0;
            [nearData removeAllObjects];
            nearData = [[NSMutableArray alloc] init];
        }
        
        
       NSDictionary *nearDic=[[NSDictionary alloc]init];
       
       nearDic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding  error:nil];
       
       nearRows=nearRows+[nearDic[@"nearavtives"] count];
      
       if (nearDic)
       [nearData addObjectsFromArray:nearDic[@"nearavtives"]];
       [self hideHud];
        
      [self.nearTableView reloadData];
        
  } failure:^(NSError *erro) {
      [self hideHud];
  }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self loadNearListData:0];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - segmentControllerChange

- (IBAction)segmentController:(id)sender {

    NSInteger numIndexSelect = self.segmentController.selectedSegmentIndex;
    switch (numIndexSelect) {
        case 0:
            [self.topbgView setImage:[UIImage imageNamed:@"Rectangle 512.png"]];
            self.hotLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            self.nearLabel.textColor = [UIColor whiteColor];
            self.hotContantView.hidden = NO;
            self.nearContantView.hidden = YES;
            buttonView.hidden = YES;
            fromHttpData = hotArray;
            [nearDropDownView removeFromSuperview];
            [self.hotTableView reloadData];

            break;
            
       case 1:
            [self.topbgView setImage:[UIImage imageNamed:@"Rectangle 512 + Rectangle 513.png"]];
            isHotView = NO;
            self.nearLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            self.hotLabel.textColor=[UIColor whiteColor];
            self.hotContantView.hidden = YES;
            self.nearContantView.hidden = NO;
            [self initStartActionView];
            [self initNearHeaderView];
            [hotDropDownView removeFromSuperview];

            
            [self.nearTableView reloadData];
            
            
            break;
    }
}

#pragma mark - clicks

//- (void)searchItemAction:(UIButton *)sender{
//    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"cancel"] action:@selector(leftCancelButtonPress:)];
//    [bgview addSubview:self.searchBar];
//    self.searchBar.text = nil;
//    self.topbgView.hidden = YES;
//    self.segmentController.hidden = YES;
//    buttonView.hidden = YES;
//    [self.searchBar becomeFirstResponder];
//}
//
//- (void)leftCancelButtonPress:(UIButton *)sender{
//    self.searchBar.text = nil;
//    [self.searchBar resignFirstResponder];
//    [self.searchBar removeFromSuperview];
//    self.topbgView.hidden = NO;
//    buttonView.hidden = NO;
//    self.segmentController.hidden = NO;
//    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"search"] action:@selector(searchItemAction:)];
//}

- (void)startAction:(UIButton *)button{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StartActivityViewController *startActivityVC = [storyBoard instantiateViewControllerWithIdentifier:@"startActivity"];
    [self.navigationController pushViewController:startActivityVC animated:YES];
}


- (BOOL) isNullString:(NSString *)string {
    
    string=[NSString stringWithFormat:@"%@",string];
    
    if (string.length<=6) {
        return YES;
    }
    
    return NO;
}

//点赞活动
- (void)clickzAction:(UIButton *)sender{
    
    sender.selected=!sender.selected;
    
    if (sender.selected==YES) {
        
        //赞
        [self praise:sender];
       
        
    }else {
        
        //取消赞
        [self cancelPraise:sender];
    }
}


//参加活动
- (void)joinAction:(UIButton *)sender{
    
    [self loadJoinData:sender];
    
}


//附近活动分享
- (void)nearshareAction:(UIButton *)sender{

    NSMutableDictionary *shareDic=[NSMutableDictionary dictionary];
    NSArray *imgArray = [[NSArray alloc] init];
    NSString *imgPaths = nearData[sender.tag-20000][@"image"];
    if ([self isNullString:imgPaths]) {
        
        shareDic[@"img"] = [NSString stringWithFormat:@"icon58"];
        
    }else{
        
        imgArray = [imgPaths componentsSeparatedByString:@","];
        shareDic[@"img"]= imgArray?imgArray[0]:@"";        
    }    
    shareDic[@"title"]=nearData[sender.tag-20000][@"title"];
    shareDic[@"desc"]=nearData[sender.tag-20000][@"detail"];
    shareDic[@"url"]=@"http://down.app.wisq.cn";
    
    [MainViewController theShareSDK:shareDic];
}


//热门分享
- (void)hotshareAction:(UIButton *)sender{

    if(fromHttpData){
    NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
    
    dic1[@"img"]=fromHttpData[sender.tag][@"shareUrl"];
    dic1[@"title"]=fromHttpData[sender.tag][@"title"];
    dic1[@"desc"]=fromHttpData[sender.tag][@"content"];
    
    if ([fromHttpData[sender.tag][@"titleUrl"] isEqualToString:@"SPRING_NIGHT"]) {
        
        dic1[@"url"] = @"http://webapp.wisq.cn/Spring/index";

    }else{
    
        dic1[@"url"]=fromHttpData[sender.tag][@"titleUrl"];
        
    }

    [MainViewController theShareSDK:dic1];
        
    }
}


//热门参加
- (void)hotJoinAction:(UIButton *)sender{

    if (fromHttpData) {
        
        NSString *uid = [userInfo objectForKey:MyUserID];
        NSDictionary *dict = fromHttpData[sender.tag];
        if ([[dict objectForKey:@"titleUrl"] isEqualToString:@"springVideoShow"]) {
            zhanBoViewController * zhanbo = [self.storyboard instantiateViewControllerWithIdentifier:@"zhanBoViewController"];
            [self.navigationController pushViewController:zhanbo animated:YES];
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SeconWebController *webVC = [storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
        webVC.theUrl = [NSString stringWithFormat:@"%@%@%@%@",[dict objectForKey:@"titleUrl"],@"/uid/",uid,@".html"];
        [webVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}


//附近活动参加
- (void)loadJoinData:(UIButton *)sender{
    
    NSMutableDictionary *joinDic = [[NSMutableDictionary alloc] init];
    joinDic[@"activeID"] = [NSString stringWithFormat:@"%@",nearData[sender.tag-10000][@"activeID"]];
    joinDic[@"userAccount"] = [userInfo objectForKey:userAccount];
    [ISQHttpTool post:joininNearActive contentType:nil params:joinDic success:^(id responseObj) {
        
        NSString *joinData2 = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if([joinData2 isEqualToString:@"Joined"]){
            
            [self showHint:@"您已经参加了哦，亲~"];
            
        }else{
            
            [self showHint:@"成功参与，嘻嘻~"];
            
            [sender setTitle:[NSString stringWithFormat:@"%d参加",[nearData[sender.tag-10000][@"joinNum"] intValue]+1] forState:UIControlStateNormal];
            sender.selected=YES;
        }
        
    } failure:^(NSError *error) {
        
        [self showHint:@"参与失败，请稍后再试~"];
    }];
}


//点赞
-(void)praise:(UIButton *)sender{
    
    
    NSMutableDictionary *clickzDic = [[NSMutableDictionary alloc] init];
    clickzDic[@"id"] =  [NSString stringWithFormat:@"%@",nearData[sender.tag-1000][@"activeID"]];
    clickzDic[@"userAccount"] = [userInfo objectForKey:userAccount];
    [ISQHttpTool post:activityClickz contentType:nil params:clickzDic success:^(id responseObj) {
        
         NSString *clickzData2 = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            
            if ([[NSString stringWithFormat:@"%@",nearData[sender.tag-1000][@"like"]] isEqualToString:@"1"]) {
                
                
                
                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[nearData[sender.tag-1000][@"likeNum"] intValue]] forState:UIControlStateNormal];
                ISQLog(@"点赞---%@",clickzData2);
                
            }else {
                
                
                
                //赞+1
                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[nearData[sender.tag-1000][@"likeNum"] intValue]+1] forState:UIControlStateNormal];
                ISQLog(@"点赞---%@",clickzData2);
            }
            
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self showHint:@"请稍后再试..."];
        
    }];
    
}

//取消赞
-(void)cancelPraise:(UIButton *)sender{
    
    
    NSMutableDictionary *clickzDic = [[NSMutableDictionary alloc] init];
    clickzDic[@"id"] = [NSString stringWithFormat:@"%@",nearData[sender.tag-1000][@"activeID"]];
    clickzDic[@"userAccount"] = [userInfo objectForKey:userAccount];
    [ISQHttpTool getHttp:cancelActivityClickz contentType:nil params:clickzDic success:^(id responseObject) {
       
        NSString *clickzData2 = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            if ([[NSString stringWithFormat:@"%@",nearData[sender.tag-1000][@"like"]] isEqualToString:@"1"]) {
                
                
                //赞-1
                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[nearData[sender.tag-1000][@"likeNum"] intValue]-1] forState:UIControlStateNormal];
                
            }else {
                
                

                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[nearData[sender.tag-1000][@"likeNum"] intValue]] forState:UIControlStateNormal];
            }
            
           
            
        }
       
        
    } failure:^(NSError *erro) {
        
        [self showHint:@"请稍后再试..."];
    }];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView==self.hotTableView){
        return fromHttpData.count;
    }else if (tableView==self.nearTableView){
      return [nearData count];
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    
    if(tableView==self.hotTableView){
        
        hotCell * cell=[tableView dequeueReusableCellWithIdentifier:@"hot" forIndexPath:indexPath];
        if ([fromHttpData[indexPath.row] objectForKey:@"specialId"]) {
            
            hotModel *hotmodel = [hotModel objectWithKeyValues:fromHttpData[indexPath.row]];
            [cell.hotimage  setImageWithURL:[NSURL URLWithString:hotmodel.image] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
            cell.contentLabel.text = hotmodel.content;
            if (indexPath.row == 0) {
                [cell.joinButton setImage:[UIImage imageNamed:@"icon_eye"] forState:UIControlStateNormal];
                [cell.joinButton setTitle:@"   观看" forState:UIControlStateNormal];
            }
            cell.shareButton.tag = indexPath.row;
            cell.joinButton.tag = indexPath.row;
            [cell.joinButton addTarget:self action:@selector(hotJoinAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareButton addTarget:self action:@selector(hotshareAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (tableView==self.nearTableView){
        
            if(nearData){

            data = [HotVideoModel objectWithKeyValues:nearData[indexPath.row]];
            if (![self isNullString:data.videoID]) {
                
           
                videoCell *vCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
                
                if ([[NSString stringWithFormat:@"%@",data.join] isEqualToString:@"1"]) {
                    
                    vCell.joinButton.selected=YES;
                    
                }else{
                
                
                    vCell.joinButton.selected = NO;
                }
                
                if ([[NSString stringWithFormat:@"%@",data.like] isEqualToString:@"1"]) {
                    
                    vCell.clickzButton.selected=YES;
                    
                   
                    
                }else {
                    vCell.clickzButton.selected=NO;
                    
                }
               
                [vCell.joinButton setImage:[UIImage imageNamed:arrayNormalImg[0]] forState:UIControlStateNormal];
                [vCell.joinButton setTitle:[NSString stringWithFormat:@"%@参加",data.joinNum] forState:UIControlStateNormal];
                [vCell.clickzButton setTitle:[NSString stringWithFormat:@"%@点赞",data.likeNum] forState:UIControlStateNormal];
                [vCell.clickzButton addTarget:self action:@selector(clickzAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [vCell.clickzButton setImage:[UIImage imageNamed:arrayligtImg[1]] forState:UIControlStateSelected];
                [vCell.clickzButton setImage:[UIImage imageNamed:arrayNormalImg[1]] forState:UIControlStateNormal];
                [vCell.joinButton setImage:[UIImage imageNamed:arrayligtImg[0]] forState:UIControlStateSelected];
                [vCell.joinButton addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [vCell.shareButton addTarget:self action:@selector(nearshareAction:) forControlEvents:UIControlEventTouchUpInside];
                vCell.titleLabel.text = data.title;
                vCell.timeLabel.text = [NSString stringWithFormat:@"时间: %@",data.uploadTime];
                vCell.nickName.text = data.userNickName;
                vCell.describeLabel.text = data.detail;
                [vCell.userFace setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYHEADIMGURL,data.userFace]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                [vCell.videoImage setImageWithURL:[NSURL URLWithString:data.image] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                
                vCell.clickzButton.tag=indexPath.row+1000;
                vCell.joinButton.tag=indexPath.row+10000;
                vCell.shareButton.tag=indexPath.row+20000;
                
                vCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return vCell;
                
            }else {
                
                static NSString *iden = @"imageCell";
                
                ImageCell *imagecell = [tableView dequeueReusableCellWithIdentifier:iden];
                
                if (!imagecell) {
                    
                    imagecell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
                }
                
                
                NSString *imageurls = data.image;
                NSArray *urlArray =[[NSArray alloc ]init];
                urlArray=[imageurls componentsSeparatedByString:@","];
                if (urlArray.count == 0) {
                    
                    imagecell.cellImageOne.hidden = YES;
                    imagecell.cellImageTow.hidden = YES;
                    imagecell.cellImageThree.hidden = YES;
                    
                }else if (urlArray.count == 1) {
                    
                    [imagecell.cellImageOne setImageWithURL:[NSURL URLWithString:urlArray[0]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                    imagecell.cellImageOne.hidden = NO;
                    imagecell.cellImageTow.hidden = YES;
                    imagecell.cellImageThree.hidden = YES;
                    
                }else if (urlArray.count == 2){
                    
                    [imagecell.cellImageOne setImageWithURL:[NSURL URLWithString:urlArray[0]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                    [imagecell.cellImageTow setImageWithURL:[NSURL URLWithString:urlArray[1]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                    imagecell.cellImageOne.hidden = NO;
                    imagecell.cellImageTow.hidden = NO;
                    imagecell.cellImageThree.hidden = YES;
                    
                }else if (urlArray.count >= 3)
{
                    [imagecell.cellImageOne setImageWithURL:[NSURL URLWithString:urlArray[0]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                    [imagecell.cellImageTow setImageWithURL:[NSURL URLWithString:urlArray[1]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                    [imagecell.cellImageThree setImageWithURL:[NSURL URLWithString:urlArray[2]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                    imagecell.cellImageOne.hidden = NO;
                    imagecell.cellImageTow.hidden = NO;
                    imagecell.cellImageThree.hidden = NO;
                }
                
                imagecell.titleLabel.text = data.title;
                
                if ([[NSString stringWithFormat:@"%@",data.join] isEqualToString:@"1"]) {
                    
                    imagecell.joinButton.selected=YES;
                    
                }else{
                
                    imagecell.joinButton.selected = NO;
                }
                
                if ([[NSString stringWithFormat:@"%@",data.like] isEqualToString:@"1"]) {
                    
                    imagecell.clickzButton.selected=YES;
                    
                }else {
                    imagecell.clickzButton.selected=NO;
                }
                
                imagecell.clickzButton.tag=indexPath.row+1000;
                imagecell.joinButton.tag=indexPath.row+10000;
                imagecell.shareButton.tag=indexPath.row+20000;
                
                [imagecell.joinButton setImage:[UIImage imageNamed:arrayNormalImg[0]] forState:UIControlStateNormal];
                [imagecell.joinButton setTitle:[NSString stringWithFormat:@"%@参加",data.joinNum] forState:UIControlStateNormal];
                [imagecell.clickzButton setTitle:[NSString stringWithFormat:@"%@点赞",data.likeNum] forState:UIControlStateNormal];
                [imagecell.clickzButton addTarget:self action:@selector(clickzAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [imagecell.clickzButton setImage:[UIImage imageNamed:arrayligtImg[1]] forState:UIControlStateSelected];
                [imagecell.clickzButton setImage:[UIImage imageNamed:arrayNormalImg[1]] forState:UIControlStateNormal];
                [imagecell.joinButton setImage:[UIImage imageNamed:arrayligtImg[0]] forState:UIControlStateSelected];
                [imagecell.joinButton addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];
                [imagecell.shareButton addTarget:self action:@selector(nearshareAction:) forControlEvents:UIControlEventTouchUpInside];
                
                imagecell.nickName.text = data.userNickName;
                imagecell.detailLabel.text = data.detail;
                imagecell.timeLabel.text = [NSString stringWithFormat:@"时间: %@",data.uploadTime];
                [imagecell.userFace setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYHEADIMGURL,data.userFace]] placeholderImage:[UIImage imageNamed:@"empty_photo"]];
                
                imagecell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return imagecell;
                
            }
        }

        
    }
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.hotTableView ==tableView){
        if (fromHttpData) {
            
            NSString *uid = [userInfo objectForKey:MyUserID];
            NSDictionary *dict = fromHttpData[indexPath.row];
            if ([[dict objectForKey:@"titleUrl"] isEqualToString:@"springVideoShow"]) {
                zhanBoViewController * zhanbo = [self.storyboard instantiateViewControllerWithIdentifier:@"zhanBoViewController"];
                [self.navigationController pushViewController:zhanbo animated:YES];
                return;
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            SeconWebController *webVC = [storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
            webVC.theUrl = [NSString stringWithFormat:@"%@%@%@%@",[dict objectForKey:@"titleUrl"],@"/uid/",uid,@".html"];
            [webVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 254;
}


#pragma mark -- dropDownListDelegate

-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    
}

#pragma mark -- dropdownList DataSource

-(NSInteger)numberOfSections
{
    if (self.hotTableView) {        
        return [hotChooseArray count];
    }
    return [nearChooseArray count];
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (self.hotTableView) {
        NSArray *arry = hotChooseArray[section];
        return [arry count];
    }
    NSArray *arry = nearChooseArray[section];
    return [arry count];
    
}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    if (self.hotTableView) {
        return hotChooseArray[section][index];
    }
    return nearChooseArray[section][index];
    
}

-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}


#pragma mark prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath  *indexPath=[self.nearTableView indexPathForSelectedRow];
    
    if ([[segue identifier] isEqualToString:@"ActivityDetailImgController"]) {
        
        ActivityDetailImgController *imgDetail=[segue destinationViewController];
        imgDetail.title=[NSString stringWithFormat:@"%@",nearData[indexPath.row][@"title"]];
        imgDetail.httpData=nearData[indexPath.row];
        
    }else if ([[segue identifier] isEqualToString:@"VideoDetailController"]){
        
        VideoDetailController *videoDetail=[segue destinationViewController];
        videoDetail.title=[NSString stringWithFormat:@"%@",nearData[indexPath.row][@"title"]];
        videoDetail.httpData=nearData[indexPath.row];
        
    }
}


@end
