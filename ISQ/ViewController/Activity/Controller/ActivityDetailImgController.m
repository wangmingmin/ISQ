//
//  ActivityDetailImgController.m
//  ISQ
//
//  Created by Mac_SSD on 15/11/22.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "ActivityDetailImgController.h"
#import "ActivityDetailImagCell.h"
#import "HotVideoModel.h"
#import "StartActivityPhotosView.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"

@interface ActivityDetailImgController ()<MBProgressHUDDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    
    ActivityDetailImagCell *cell;
    NSMutableArray *cellHeight;
    HotVideoModel *data;
    UILabel *contentLabel;
    UIView *photosView;
    UIView *joinView;
    NSArray *imgUrlArray;
    UILabel *numOfJoin;
    MBProgressHUD *HUD;
    NSString *imgStr;
    UIScrollView *imgScroView;
    UILabel *pageNum;
    UIImageView *imageView;
    CGFloat currentScale;
    NSDictionary *theLikeDic;
    NSDictionary *userDic;
    NSString *useraccount;
}


@end

@implementation ActivityDetailImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityDetailImgTableView.layer.borderWidth=0.5f;
    self.activityDetailImgTableView.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.praiseButton.layer.borderWidth=0.5f;
    self.praiseButton.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
     currentScale = 1;
    //数据源
      data = [HotVideoModel objectWithKeyValues:_httpData];
    //cell的高度
    cellHeight=[[NSMutableArray alloc]init];
    [cellHeight addObject:@"72.0"];
    
    
    //图片
    [self theImg];
    //内容
    [self theContent];
    [cellHeight addObject:@"35.0"];
    //参与人员
    [cellHeight addObject:[NSString stringWithFormat:@"28"]];
    [self joinPeople];
    
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [cellHeight[indexPath.row] floatValue];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indentifier=@"activityDetaileImagCell";
    indentifier=[NSString stringWithFormat:@"%@%ld",indentifier,(long)indexPath.row];
     
    cell=[tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            
            [cell.userHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYHEADIMGURL,data.userFace]] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
            cell.activityTitle.text=data.title;
            cell.activityTime.text=[NSString stringWithFormat:@"时间：%@",data.uploadTime];
            cell.activityPlace.text=[NSString stringWithFormat:@"地点：%@",data.address];
            
            break;
        case 1:
            
            [cell addSubview:photosView];
            break;
        case 2:
            contentLabel.x=55;
            contentLabel.y=1;
            [cell addSubview:contentLabel];
            break;
        case 3:
            cell.layer.borderWidth=0.7f;
            cell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.6].CGColor;
            numOfJoin.x=8;
            numOfJoin.y=0;
            [cell addSubview:numOfJoin];
            
            break;
        case 4:
            joinView.x=15;
            joinView.y=1;
            [cell addSubview:joinView];
            
            break;
    }
    
    return cell;
}


#pragma  mark 图片
-(void)theImg{
    
    
    photosView = [[UIView alloc] init];
    NSString *imageurls = data.image;
    imgUrlArray = [imageurls componentsSeparatedByString:@","];
    photosView.width=UISCREENWIDTH-55;
    photosView.x=55;
    
    int theX=0;
    int theY=0;
    for (int i=0;i< imgUrlArray.count;i++) {
        
        
        if (theX/3>=1) {
            
            theX=0;
            theY++;
        }
        
        UIImageView *img=[[UIImageView alloc]init];
        img.userInteractionEnabled=YES;
        img.width=60;
        img.height=60;
        img.x= theX * (60 +8);
        img.y=theY * (60 + 8);
        theX++;
        
        img.tag=i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClik:)];
        [img addGestureRecognizer:tap];
        
        [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrlArray[i]]] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        [photosView addSubview:img];
        
    }
    
    photosView.height= 60 * ( imgUrlArray.count /3 >=1 ? theY+1:1) +theY*8;
    [cellHeight addObject:[NSString stringWithFormat:@"%f",photosView.height]];
}

#pragma  mark 内容
-(void)theContent{
    //内容
    contentLabel=[[UILabel alloc]init];
    contentLabel.width=UISCREENWIDTH-70;
    contentLabel.height=[UILabel getLabelHeight:data.detail theUIlabel:contentLabel].height+10;
    contentLabel.numberOfLines=0;
    contentLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
    [cellHeight addObject:[NSString stringWithFormat:@"%f",contentLabel.height]];
    contentLabel.text=data.detail;
    
}

#pragma  mark 参与人员
-(void)joinPeople{
    
    
    
    numOfJoin=[[UILabel alloc]init];
    numOfJoin.font = [UIFont systemFontOfSize:16];
    numOfJoin.width=360;
    numOfJoin.height=35;
    numOfJoin.text=[NSString stringWithFormat:@"%@ 人参加活动",data.joinNum];
    
    
    if (data.activeID) {
        joinView=[[UIView alloc]init];
       
        joinView.width=UISCREENWIDTH-30;
        NSMutableDictionary *parames=[NSMutableDictionary dictionary];
        
        parames[@"activeID"]=data.activeID;
        parames[@"userAccount"]=[NSString stringWithFormat:@"%@",[user_info objectForKey:userAccount]];
        
        [ISQHttpTool getHttp:@"http://121.41.18.126:8080/isqbms/getNearActiveDetail.from" contentType:nil params:parames success:^(id rect) {
            
            theLikeDic=[NSJSONSerialization JSONObjectWithData:rect options:NSJapaneseEUCStringEncoding error:nil];
            
             if (theLikeDic[@"nearActive"]) {
                 
                 //点赞、分享、参加
                 [self foolBarView:theLikeDic[@"nearActive"]];
                 
             }
           
            if (theLikeDic[@"userInfo"]) {
                
                int theX=0;
                int theY=0;
                NSArray *array = theLikeDic[@"userInfo"];
                for (int i = 0; i<array.count; i++) {
                    userDic = array[i];
                    if (theX/4>=1) {

                        theX=0;
                        theY++;
                    }
                    UIButton *joinPeople=[[UIButton alloc]init];
                    joinPeople.width=(joinView.width/4-8);
                    joinPeople.height=17;
                    joinPeople.x= theX * joinPeople.width;
                    joinPeople.y=theY * (17+8)+3;
                    [joinPeople setTitle:userDic[@"userNickname"] forState:UIControlStateNormal];
                    [joinPeople setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    [joinPeople setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]] forState:UIControlStateHighlighted];
                    joinPeople.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
                    theX++;
                    [joinView addSubview:joinPeople];
                     useraccount = [userDic objectForKey:@"userAccount"];
                    
                    joinPeople.tag = [[userDic objectForKey:@"userAccount"] integerValue];
                    //如果是自己发起的活动
                      if (useraccount.length >5) {
                          
                          numOfJoin.text=[NSString stringWithFormat:@"%@ 人参加活动   %@ %@ %@",data.joinNum,@"(",@"点击参与者昵称可与其电话联系",@")"];
                          [joinPeople addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
                          
                    }

                }
                
                joinView.height=theY * (17+8)+3+17+8;
            }
            
            [cellHeight replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%f",joinView.height]];
            [self.activityDetailImgTableView reloadData];
            
        } failure:^(NSError *erro) {
            
            
        }];
    }
   
}

- (void)callAction:(UIButton *)sender{
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",@"电话联系 ",sender.titleLabel.text] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    [alertView show];
    NSString *phoneNum = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    //拨号
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNum]]];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (<#condition#>) {
//        <#statements#>
//    }
//    
//}

-(void)foolBarView:(NSDictionary *)likeDic{
    
    
    NSArray *arrayNormalImg=[[NSArray alloc ]initWithObjects:@"join",@"clickz",@"share", nil];
    NSArray *arrayligtImg=[[NSArray alloc ]initWithObjects:@"joinSelected",@"clickzSelect",@"shareSelected", nil];
    
    if ([[NSString stringWithFormat:@"%@",likeDic[@"join"]] isEqualToString:@"1"]) {
        
        self.addButton.selected=YES;
        
    }
    if ([[NSString stringWithFormat:@"%@",likeDic[@"like"]] isEqualToString:@"1"]) {
        
        self.praiseButton.selected=YES;
        
        
    }
    
    [self.addButton setImage:[UIImage imageNamed:arrayNormalImg[0]] forState:UIControlStateNormal];
    [self.addButton setTitle:[NSString stringWithFormat:@"%@参加",likeDic[@"joinNum"]] forState:UIControlStateNormal];
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%@点赞",likeDic[@"likeNum"]] forState:UIControlStateNormal];
    
    [self.praiseButton setImage:[UIImage imageNamed:arrayligtImg[1]] forState:UIControlStateSelected];
    [self.praiseButton setImage:[UIImage imageNamed:arrayNormalImg[1]] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:arrayligtImg[0]] forState:UIControlStateSelected];
    
    
}



//参加
- (IBAction)addAction:(UIButton*)sender {
    
    
    [self loadJoinData];
   
    
}

//点赞
- (IBAction)praiseAction:(UIButton*)sender {
    sender.selected=!sender.selected;
    
    if (sender.selected) {
        
        //赞
        [self praise:sender];
      
        
    }else {
        
        //取消赞
        [self cancelPraise:sender];
        
      
       
    }

}

//分享
- (IBAction)shareAction:(id)sender {
    NSMutableDictionary *shareDic=[NSMutableDictionary dictionary];
    shareDic[@"img"]= imgUrlArray?imgUrlArray[0]:@"";
    shareDic[@"title"]=data.title;
    shareDic[@"desc"]=data.detail;
    shareDic[@"url"]=@"http://down.app.wisq.cn";
   
    [MainViewController theShareSDK:shareDic];
    
}


//参加
- (void)loadJoinData{
    
    NSMutableDictionary *joinDic = [[NSMutableDictionary alloc] init];
    joinDic[@"activeID"] = data.activeID;
    joinDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool post:joininNearActive contentType:nil params:joinDic success:^(id responseObj) {
        
        NSString *joinData = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if([joinData isEqualToString:@"Joined"]){
            
            [self showHint:@"您已经参加了哦，亲~"];
            
        }else{
            [self showHint:@"成功参与，嘻嘻~"];
    
            
            [self joinPeople];
            [self.addButton setTitle:[NSString stringWithFormat:@"%d参加",[data.joinNum intValue]+1] forState:UIControlStateNormal];
            
            self.addButton.selected=YES;
        }
        
        
        
    } failure:^(NSError *error) {
        
        [self showHint:@"请稍后再试，谢谢~"];
    }];
    
}
//点赞
-(void)praise:(UIButton*)sender{
    
    NSMutableDictionary *clickzDic = [[NSMutableDictionary alloc] init];
    clickzDic[@"id"] = data.activeID;
    clickzDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool post:activityClickz contentType:nil params:clickzDic success:^(id responseObj) {

        
        NSString *clickzData2 = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            
            if (theLikeDic[@"nearActive"]) {
                
                
                
                if ([[NSString stringWithFormat:@"%@",theLikeDic[@"nearActive"][@"like"]] isEqualToString:@"1"]) {
                    
                    
                    
                    //赞+1
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]] forState:UIControlStateNormal];
                    
                }else {
                    
                    
                    
                    //赞+1
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]+1] forState:UIControlStateNormal];
                    
                }
            }
                        
        }
        
    } failure:^(NSError *error) {
        
        [self showHint:@"请稍后再试..."];
        
    }];
    
    ISQLog(@"赞");
}

//取消赞
-(void)cancelPraise:(UIButton *)sender{
    
    
    NSMutableDictionary *clickzDic = [[NSMutableDictionary alloc] init];
    clickzDic[@"id"] = data.activeID;
    clickzDic[@"userAccount"] = [user_info objectForKey:userAccount];
    [ISQHttpTool getHttp:cancelActivityClickz contentType:nil params:clickzDic success:^(id responseObject) {
        
        NSString *clickzData2 = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([clickzData2 isEqualToString:@"ok"]) {
            
            
            if (theLikeDic[@"nearActive"]) {
                
               
            
                
                if ([[NSString stringWithFormat:@"%@",theLikeDic[@"nearActive"][@"like"]] isEqualToString:@"1"]) {
                    
                    
                    //赞-1
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]-1] forState:UIControlStateNormal];
                    
                }else {
                    
                    
                    [sender setTitle:[NSString stringWithFormat:@"%d点赞",[theLikeDic[@"nearActive"][@"likeNum"] intValue]] forState:UIControlStateNormal];
                }
                
                
            }
            
            
        }
        
    } failure:^(NSError *erro) {
        
    }];

}



//点击详情图片
-(void)imgClik:(UIGestureRecognizer*)sender{
    
    
    NSString *imageurls = data.hqImage;
    NSArray *imgArry2=[imageurls componentsSeparatedByString:@","];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    imgScroView.delegate=self;
    imgScroView.bounces=YES;
    imgScroView.showsHorizontalScrollIndicator = NO;
    imgScroView.contentSize=CGSizeMake(UISCREENWIDTH, UISCREENHEIGHT-70);
    [self.navigationController.view addSubview:HUD];
    
    imgScroView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH*imgArry2.count, UISCREENHEIGHT)];
    
    // 图片的宽
    CGFloat imageW = UISCREENWIDTH;
    CGFloat imageH = UISCREENWIDTH;

    NSInteger totalCount = imgArry2.count;
    
    for (int i=0; i<imgArry2.count; i++) {
        
        imageView = [[UIImageView alloc] init];
        
        CGFloat imageX = i * imageW;
        // 设置frame
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES;
        imageView.center=CGPointMake((UISCREENWIDTH/2)+(UISCREENWIDTH*i), (UISCREENHEIGHT-70)/2);
        // 设置图片
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgArry2[i]]]];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [imageView addGestureRecognizer:pinchGestureRecognizer];
        [imgScroView addSubview:imageView];
    }
    
    //用于显示当前图片的页数
    pageNum=[[UILabel alloc]initWithFrame:CGRectMake(UISCREENWIDTH/2-25, UISCREENHEIGHT-70, 50, 20)];
    pageNum.text=[NSString stringWithFormat:@" %d/ %lu",sender.view.tag+1,(unsigned long)imgUrlArray.count];
    [HUD addSubview:pageNum];
    
    
    //.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    imgScroView.contentSize = CGSizeMake(contentW, 0);
    
    //设置分页
    imgScroView.pagingEnabled = YES;
    imgScroView.backgroundColor = [UIColor blackColor];
    
    //移动至选中的图片
    [imgScroView setContentOffset:CGPointMake(UISCREENWIDTH*sender.view.tag, imageH) animated:YES];
    HUD.customView = imgScroView ;
    HUD.margin=0.1f;
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD show:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Hidden)];
    [HUD.customView addGestureRecognizer:tap];
    
}


#pragma  mark UIScrollViewDidScrolldelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    
    pageNum.text=[NSString stringWithFormat:@" %d/ %lu",page+1,(unsigned long)imgUrlArray.count];
    
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{

    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        currentScale = pinchGestureRecognizer.scale;
    }else if(pinchGestureRecognizer.state == UIGestureRecognizerStateBegan && currentScale != 0.0f){
        pinchGestureRecognizer.scale = currentScale;
    }
    if (pinchGestureRecognizer.scale !=NAN && pinchGestureRecognizer.scale != 0.0) {
        pinchGestureRecognizer.view.transform = CGAffineTransformMakeScale(pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    }

}


-(void)Hidden{
    
    [HUD hide:YES];
}


@end
