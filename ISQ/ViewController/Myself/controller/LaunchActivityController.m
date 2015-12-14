//
//  LaunchActivityController.m
//  ISQ
//
//  Created by Mac_SSD on 15/12/4.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "LaunchActivityController.h"
#import "videoCell.h"
#import "ImageCell.h"
#import "HotVideoModel.h"
#import "imageCellModel.h"
#import "ISQCommonFunc.h"
#import "videoCell.h"
#import "ImageCell.h"
#import "HotVideoModel.h"
#import "imageCellModel.h"
#import "SRRefreshView.h"
#import "ActivityDetailImgController.h"
#import "VideoDetailController.h"
#import "MainViewController.h"
@interface LaunchActivityController ()<SRRefreshDelegate>{
    
    NSMutableArray *fromHttpData;
    NSInteger launchRows;
    HotVideoModel *data;
    NSArray *arrayNormalImg;
    NSArray *arrayligtImg;
}
@property (nonatomic, strong) SRRefreshView         *slimeView;
@end

@implementation LaunchActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showHudInView:self.view hint:@"正在加载..."];
    fromHttpData = [[NSMutableArray alloc] init];
    launchRows=0;
    arrayNormalImg=[[NSArray alloc ]initWithObjects:@"join",@"clickz",@"share", nil];
    arrayligtImg=[[NSArray alloc ]initWithObjects:@"joinSelected",@"clickzSelect",@"shareSelected", nil];
    [self loadJoinActivityData:0];
    
    //刷新
    [self.tableView addSubview:self.slimeView];
    //上拉加载更多
    [self addFooter];
}

#pragma mark - 刷新

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
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
    
    
}

#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    
    [self loadJoinActivityData:0];
    [_slimeView endRefresh];
    
}

#pragma mark 上拉加载更多
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self loadJoinActivityData:launchRows];
            
            //结束刷新
            [vc.tableView footerEndRefreshing];
        });
    }];
    
}


#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([[NSString stringWithFormat:@"%@",[fromHttpData firstObject]] length]<=6){
        
        return 0;
    }
    return fromHttpData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 222;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    videoCell *vCell;
    if (fromHttpData) {
        data = [HotVideoModel objectWithKeyValues:fromHttpData[indexPath.row]];
        if (![self isNullString:data.videoID]) {
            
            vCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
            
            if ([[NSString stringWithFormat:@"%@",data.join] isEqualToString:@"1"]) {
                
                vCell.joinButton.selected=YES;
                
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
                
            }else if (urlArray.count >= 3){
                
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
    
    return vCell;
    
    
    
}
#pragma mark - 获取数据

//参与附近活动  getJoinActive

- (void) loadJoinActivityData:(NSInteger )rows{
    
    
    
    //获取系统当前时间
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [dateFormatter stringFromDate:senddate];
    
    //约定的key
    NSString *key = @"michae12";
    
    //获取随机字符串
    NSString *randomString = [self ret5bitString];
    
    NSString*stringParams = [NSString stringWithFormat:@"%@CurrentTime=%@;userAccount=%@%@digest=%@",@"name=active_list;QRAPID=kentop;QRAPName=kentop;",time,[user_info objectForKey:userAccount],@"&",randomString];
    //加密
    ISQCommonFunc *commonfunc = [[ISQCommonFunc alloc] init];
    NSString *text = [commonfunc encryptUseDES:stringParams key:key];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *token = [data base64Encoding];
    NSString *name = @"active_list";
    
    NSString *http = [NSString stringWithFormat:@"%@?&rows=%@&name=%@&token=%@",getLaunchActive,[NSString stringWithFormat:@"%ld",(long)rows],name,token];
    [ISQHttpTool getHttp:http contentType:nil params:nil success:^(id responseObject) {
        
        if (rows==0) {
            
            launchRows=0;
            
            fromHttpData = [[NSMutableArray alloc] init];
            
        }
        NSArray *launchArry=[[NSArray alloc]init];
        launchArry=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
        
        if (launchArry) {
            
            if([[NSString stringWithFormat:@"%@",launchArry[0] ] isEqualToString:@"empty"]){
                
                
            }else {
                
                launchRows=launchRows+[launchArry count];
                [fromHttpData  addObjectsFromArray:launchArry];
                
                
                [self.tableView reloadData];
            }
            
        }
        
        [self hideHud];
        
    } failure:^(NSError *erro) {
        
        [self hideHud];
    }];
}

//获取5位随机数
- (NSString *)ret5bitString{
    
    char datas[5];
    for (int x=0;x<5;datas[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:datas length:5 encoding:NSUTF8StringEncoding];
}

//点赞活动
- (void)clickzAction:(UIButton *)sender{
    
    sender.selected=!sender.selected;
    
    if (sender.selected) {
        
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
    NSString *imgPaths = fromHttpData[sender.tag-20000][@"image"];
    if ([self isNullString:imgPaths]) {
        
        shareDic[@"img"] = [NSString stringWithFormat:@"icon58"];
        
    }else{
        
        imgArray = [imgPaths componentsSeparatedByString:@","];
        shareDic[@"img"]= imgArray?imgArray[0]:@"";
    }
    shareDic[@"title"]=fromHttpData[sender.tag-20000][@"title"];
    shareDic[@"desc"]=fromHttpData[sender.tag-20000][@"detail"];
    shareDic[@"url"]=@"http://down.app.wisq.cn";
    
    [MainViewController theShareSDK:shareDic];
}
//附近活动参加
- (void)loadJoinData:(UIButton *)sender{
    
    NSMutableDictionary *joinDic = [[NSMutableDictionary alloc] init];
    joinDic[@"activeID"] = [NSString stringWithFormat:@"%@",fromHttpData[sender.tag-10000][@"activeID"]];
    joinDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool post:joininNearActive contentType:nil params:joinDic success:^(id responseObj) {
        
        NSString *joinData2 = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if([joinData2 isEqualToString:@"Joined"]){
            
            [self showHint:@"您已经参加了哦，亲~"];
            
        }else{
            
            [self showHint:@"成功参与，嘻嘻~"];
            
            [sender setTitle:[NSString stringWithFormat:@"%d参加",[fromHttpData[sender.tag-10000][@"joinNum"] intValue]+1] forState:UIControlStateNormal];
            sender.selected=YES;
        }
        
    } failure:^(NSError *error) {
        
        [self showHint:@"参与失败，请稍后再试~"];
    }];
}


//点赞
-(void)praise:(UIButton *)sender{
    
    
    NSMutableDictionary *clickzDic = [[NSMutableDictionary alloc] init];
    clickzDic[@"id"] =  [NSString stringWithFormat:@"%@",fromHttpData[sender.tag-1000][@"activeID"]];
    clickzDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool post:activityClickz contentType:nil params:clickzDic success:^(id responseObj) {
        
        NSString *clickzData2 = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            
            if ([[NSString stringWithFormat:@"%@",fromHttpData[sender.tag-1000][@"like"]] isEqualToString:@"1"]) {
                
                
                
                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[fromHttpData[sender.tag-1000][@"likeNum"] intValue]] forState:UIControlStateNormal];
                ISQLog(@"点赞---%@",clickzData2);
                
            }else {
                
                
                
                //赞+1
                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[fromHttpData[sender.tag-1000][@"likeNum"] intValue]+1] forState:UIControlStateNormal];
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
    clickzDic[@"id"] = [NSString stringWithFormat:@"%@",fromHttpData[sender.tag-1000][@"activeID"]];
    clickzDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool getHttp:cancelActivityClickz contentType:nil params:clickzDic success:^(id responseObject) {
        
        NSString *clickzData2 = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            if ([[NSString stringWithFormat:@"%@",fromHttpData[sender.tag-1000][@"like"]] isEqualToString:@"1"]) {
                
                
                //赞-1
                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[fromHttpData[sender.tag-1000][@"likeNum"] intValue]-1] forState:UIControlStateNormal];
                
            }else {
                
                
                
                [sender setTitle:[NSString stringWithFormat:@"%d点赞",[fromHttpData[sender.tag-1000][@"likeNum"] intValue]] forState:UIControlStateNormal];
            }
            
            
            
        }
        
        
    } failure:^(NSError *erro) {
        
        [self showHint:@"请稍后再试..."];
    }];
}

#pragma mark prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath  *indexPath=[self.tableView indexPathForSelectedRow];
    
    if ([[segue identifier] isEqualToString:@"ActivityDetailImgController"]) {
        
        ActivityDetailImgController *imgDetail=[segue destinationViewController];
        imgDetail.title=[NSString stringWithFormat:@"%@",fromHttpData[indexPath.row][@"title"]];
        imgDetail.httpData=fromHttpData[indexPath.row];
        
    }else if ([[segue identifier] isEqualToString:@"VideoDetailController"]){
        
        VideoDetailController *videoDetail=[segue destinationViewController];
        videoDetail.title=[NSString stringWithFormat:@"%@",fromHttpData[indexPath.row][@"title"]];
        videoDetail.httpData=fromHttpData[indexPath.row];
        
    }
}

- (BOOL) isNullString:(NSString *)string {
    
    string=[NSString stringWithFormat:@"%@",string];
    
    if (string.length<=6) {
        return YES;
    }
    
    return NO;
}




@end


