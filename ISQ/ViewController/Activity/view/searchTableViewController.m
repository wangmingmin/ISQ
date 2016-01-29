//
//  searchTableViewController.m
//  ISQ
//
//  Created by 123 on 15/12/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "searchTableViewController.h"
#import "ISQHttpTool.h"
#import "HotVideoModel.h"
#import "MainViewController.h"
#import "VideoDetailController_forSpring.h"
@interface searchTableViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,VideoDetailController_forSpringDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController * searchDisplayController;
@property (strong, nonatomic) NSArray * dataSearch;
@property (strong, nonatomic) VideoDetailController_forSpring *videoDetail;
@end

@implementation searchTableViewController
{
    float width;
    float height;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView.tableHeaderView = self.searchBar;
    width = (UISCREENWIDTH-24)/2.0;
    height = width+43;

    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchBar.delegate = self;
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];

    NSString * stringType = @"";
    
    if ([self.type isEqualToString:@"positive"]) stringType = @"网络春晚正片搜索";
    if ([self.type isEqualToString:@"city"])  {
        stringType = @"当前市节目搜索";
        if (!self.isCurrentCity) {
            stringType = @"所选城市节目搜索";
        }
    }
    if ([self.type isEqualToString:@"special"]) stringType = @"专场节目搜索";
    if ([self.type isEqualToString:@"rank"]) stringType = @"排行榜节目搜索";
    if ([self.type isEqualToString:@"follow"]) stringType = @"我关注节目搜索";
    self.title = stringType;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing:)];
    [self.searchDisplayController.searchResultsTableView addGestureRecognizer:tap];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing:)];
    [self.tableView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing:)];
    [self.view addGestureRecognizer:tap2];

}

-(void)nothing:(UIGestureRecognizer *)sender
{
    //只是修改一下用户体验而已
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = self.dataSearch.count/2 + self.dataSearch.count%2;
    if (tableView==self.tableView) {
        rows = 0;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //一个cell中放两个数据
    NSMutableArray * dataArrIneed = [[NSMutableArray alloc] init];
    NSInteger indexOu = indexPath.row*2;//0、2、4、6、8...
    NSInteger indexJi = indexOu +1;//1、3、5、7、9...
    NSDictionary * dataIndexDic1 = self.dataSearch[indexOu];
    [dataArrIneed addObject:dataIndexDic1];
    if (indexJi< self.dataSearch.count) {
        NSDictionary * dataIndexDic2 = self.dataSearch[indexOu+1];
        [dataArrIneed addObject:dataIndexDic2];
    }
    
    // Configure the cell...
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        for (int i = 0; i<dataArrIneed.count; i++) {
            NSDictionary * dataIndexDic = dataArrIneed[i];
            
            UIView * cellView = [[UIView alloc] initWithFrame:CGRectMake(8+i*(width+8), 8, width, height)];
            cellView.layer.borderColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1].CGColor;
            cellView.layer.borderWidth = 0.8;
            cellView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:cellView];
            
            UILabel * title = [[UILabel alloc] init];
            title.frame = CGRectMake(3, 2, cellView.frame.size.width-6, 30);
            title.textColor = [UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1];
            [cellView addSubview:title];
            
            UILabel *address = [[UILabel alloc] init];
            address.frame = CGRectMake(3,2+title.frame.size.height,cellView.frame.size.width-6, 15);
            address.textColor = [UIColor colorWithRed:132.0/255 green:132.0/255 blue:132.0/255 alpha:1];
            address.font = [UIFont systemFontOfSize:12];
            [cellView addSubview:address];
            
            UILabel *voteString = [[UILabel alloc] init];
            voteString.frame = CGRectMake(3, cellView.frame.size.height-50, 30, 50);
            voteString.textColor = [UIColor colorWithRed:132.0/255 green:132.0/255 blue:132.0/255 alpha:1];
            voteString.font = [UIFont systemFontOfSize:12];
            voteString.text = @"得票:";
            [cellView addSubview:voteString];
            
            UILabel *voteNum = [[UILabel alloc] init];
            voteNum.frame = CGRectMake(3+voteString.frame.size.width, cellView.frame.size.height-50, 90, 50);
            voteNum.textColor = [UIColor colorWithRed:116.0/255 green:0.0/255 blue:0.0/255 alpha:1];
            voteNum.font = [UIFont systemFontOfSize:14];
            [cellView addSubview:voteNum];
            
            CGFloat imageOriginY = address.frame.origin.y + address.frame.size.height + 8;
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageOriginY, cellView.frame.size.width, cellView.frame.size.height-imageOriginY-voteNum.frame.size.height)];//120:90
            [cellView addSubview:imageView];
            
            UIButton* shareBtn = [[UIButton alloc] init];
            shareBtn.frame = CGRectMake(cellView.frame.size.width-70, cellView.frame.size.height-50, 70, 50);
            [shareBtn setTitleColor:[UIColor colorWithRed:132.0/255 green:132.0/255 blue:132.0/255 alpha:1] forState:UIControlStateNormal];
            [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            UIImage * image = [UIImage imageNamed:@"share"];
            [shareBtn setImage:image forState:UIControlStateNormal];
            shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [cellView addSubview:shareBtn];
            
#pragma data
            title.text = [NSString stringWithFormat:@"%@",dataIndexDic[@"title"]];
            address.text = [NSString stringWithFormat:@"选送单位:%@",dataIndexDic[@"address"]];
            voteNum.text = [NSString stringWithFormat:@"%ld",[dataIndexDic[@"voteNum"] integerValue]];
            
            cellView.tag = shareBtn.tag = i==0?indexOu:indexJi;
            [shareBtn addTarget:self action:@selector(onShareVideo:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCellToShow:)];
            cellView.userInteractionEnabled = YES;
            [cellView addGestureRecognizer:tap];
            
            if ([self.type isEqualToString:@"special"]) {//专场不显示投票数
                voteString.text = @"浏览数:";
                voteString.frame = CGRectMake(voteString.frame.origin.x, voteString.frame.origin.y, 40, voteString.frame.size.height);
                voteNum.frame = CGRectMake(3+voteString.frame.size.width, voteNum.frame.origin.y, cellView.frame.size.width, voteNum.frame.size.height);
                voteNum.text = [NSString stringWithFormat:@"%ld",[dataIndexDic[@"viewNum"] integerValue]];
            }
            
            NSString * imageUrlStr = dataIndexDic[@"image"];
            if (imageUrlStr.length != 0) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [ISQHttpTool getHttp:imageUrlStr contentType:nil params:nil success:^(id image) {
                        // 耗时的操作
                        UIImage * image2 = [UIImage imageWithData:image];//120:90
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 更新界面
                            imageView.image = image2;
                        });
                    } failure:^(NSError *erro) {
                        
                    }];
                    
                });
                
            }
            

        }
    }
    else{
//        [cell.textLabel setText:@"tableView"];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return height+8;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self refresh];
    [searchBar resignFirstResponder];
}

-(void)refresh
{
    NSString * httpStr = [NSString stringWithFormat:@"%@type=%@",getSpringVideoListServer,self.type];
    
    NSMutableDictionary *parames=[NSMutableDictionary dictionary];
    
    parames[@"type"]=self.type;
    if ([self.type isEqualToString:@"city"]) {
        id cityID = [user_info objectForKey:userCityID];
        parames[@"cityId"]=cityID;
    }
    if ([self.type isEqualToString:@"follow"]) {
        id userAccountNumber = [user_info objectForKey:userAccount];
        parames[@"userAccount"]=userAccountNumber;
    }
    
    NSInteger rowsCount = 0;
    parames[@"rows"] =[NSString stringWithFormat:@"%ld",(long)rowsCount];
    
    parames[@"title"] =self.searchBar.text;//标题(加标题字段为搜索接口)
    
    if ( ! self.isCurrentCity && ![self.type isEqualToString:@"special"]) {
        httpStr = getSpringVideoByPidOrCid;
        parames[@"pid"] = [NSString stringWithFormat:@"%d",self.pid];
        parames[@"cid"] = [NSString stringWithFormat:@"%d",self.cid];
    }

    [ISQHttpTool getHttp:httpStr contentType:nil params:parames success:^(id res) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
        NSLog(@"search item dic = %@",dic);
        NSArray * data = dic[@"retData"];
        if (data.count == 0) {
            
        }else {
            self.dataSearch = [[NSArray alloc] initWithArray:data];
            [self.tableView reloadData];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    } failure:^(NSError *erro) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"查询失败" message:@"稍后请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length == 0) {
        [self.searchDisplayController setActive:NO animated:NO];
        self.dataSearch = @[];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    return YES;
}
#pragma 点击分享
-(void)onShareVideo:(UIButton *)button
{
    NSDictionary * dataIndexDic = self.dataSearch[button.tag];
    
    HotVideoModel * dataHot = [HotVideoModel objectWithKeyValues:dataIndexDic];
    
    NSMutableDictionary *shareDic=[NSMutableDictionary dictionary];
    NSString *imageurls = dataHot.image;
    NSArray * imgUrlArray = [imageurls componentsSeparatedByString:@","];
    shareDic[@"img"]= imgUrlArray?imgUrlArray[0]:@"";
    shareDic[@"title"]=dataHot.title;
    shareDic[@"desc"]=dataHot.detail;
    shareDic[@"url"]=@"http://down.app.wisq.cn";
    
    [MainViewController theShareSDK:shareDic];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma 观看
-(void)onCellToShow:(UIGestureRecognizer *)sender
{
    NSDictionary * dataIndexDic = self.dataSearch[sender.view.tag];
    
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
        if ([self.type isEqualToString:@"special"]) {
            self.videoDetail.isSpecial = YES;
        }else {
            self.videoDetail.isSpecial = NO;
        }
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
        if ([self.type isEqualToString:@"special"]) {
            self.videoDetail.isSpecial = YES;
        }else {
            self.videoDetail.isSpecial = NO;
        }
        [self.navigationController pushViewController:palyView animated:YES];
        [palyView addChildViewController:self.videoDetail];
        [palyView.view addSubview:self.videoDetail.view];
        
    }];

}

-(void)VideoDetailController_forSpringIsFinshedRefresh//投票刷新
{
    [self refresh];
    self.searched(self.type);
}

-(void)VideoDetailController_forSpringIsFinshedFollow//关注刷新
{
    self.searched(@"follow");
}

-(void)VideoDetailController_forSpringRefreshViewNum//专场浏览数刷新
{
    if ([self.type isEqualToString:@"special"]) {
        [self refresh];
        self.searched(self.type);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
