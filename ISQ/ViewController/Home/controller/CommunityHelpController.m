//
//  CommunityHelpController.m
//  ISQ
//
//  Created by mac on 15-3-28.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "CommunityHelpController.h"
#import "CommunityMyViewCell.h"
#import "AppDelegate.h"
#import "SendHelpController.h"
#import "SRRefreshView.h"
#import "ChekMyHelpController.h"
#import "CommunityViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"


@interface CommunityHelpController ()<SRRefreshDelegate,UIAlertViewDelegate>{
    
    UIView *ComLine;
    AppDelegate *locationDelegate;
    NSMutableArray *messageData;
    NSInteger messageStrtNum;
    NSString *name;
}

@end

@implementation CommunityHelpController
@synthesize ComHelpView,ComMyView,helpAdressEd,helpCommunity_ed;
@synthesize selectView,myMessageTableview,selectMy_Help_ol;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书记信箱";
    locationDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.selectView.layer.borderWidth=0.5f;
    self.selectView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;    
    self.tabBarController.tabBar.hidden=YES;
    ComLine=[[UIView alloc]initWithFrame:CGRectMake(0, 38, UISCREENWIDTH/2, 3)];
    ComLine.backgroundColor=[UIColor colorWithRed:144/255.0f green:208/225.0f blue:1 alpha:0.8];
    [self.selectView addSubview:ComLine];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if ([user_info objectForKey:userAccount] && [user_info objectForKey:userPassword]){
        
        if (locationDelegate.theAddress) {
            
            self.helpAdressEd.text=locationDelegate.theAddress;
        }
        if ([user_info objectForKey:@"saveCommunityName"]) {
            self.helpCommunity_ed.text=[user_info objectForKey:@"saveCommunityName"];
            name = self.helpCommunity_ed.text;
            
        }
        //上拉加载
        [self addFooter];
        //下拉刷新
        [self addHeader];
    }else{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登陆后才能使用此功能" message:@"立刻登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
        UIStoryboard *mainStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *mainVC=[mainStory instantiateViewControllerWithIdentifier:@"MainViewStory"];
        self.navigationController.navigationBar.hidden=YES;
        [self.navigationController pushViewController:mainVC animated:YES];
        
    }else if (buttonIndex == 1){
    
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
        LoginViewController *loginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.myMessageTableview addHeaderWithCallback:^{

        // 模拟延迟加载数据，因此1秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [vc.HornTableView reloadData];
            //重新请求
            [self getSecretaryMessageData:0];
            // 结束刷新
            [vc.myMessageTableview headerEndRefreshing];
            
            
        });
    }];
    
    //自动刷新(一进入程序就下拉刷新)
    [self.myMessageTableview headerBeginRefreshing];
    
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.myMessageTableview addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            messageStrtNum=messageStrtNum+18;
            [self getSecretaryMessageData:messageStrtNum];
            
            //结束刷新
            [vc.myMessageTableview footerEndRefreshing];
        });
    }];
    
}


//获取信箱记录
-(void)getSecretaryMessageData:(NSInteger)staNum{
    
    
    if (staNum==0) {
        
        messageData=[[NSMutableArray alloc]init];
    }
    
    NSDictionary *arry=@{@"start":[NSString stringWithFormat:@"%ld",(long)staNum],@"num":@"18",@"phone":[user_info objectForKey:userAccount]};
    [ISQHttpTool getHttp:getMessage contentType:nil params:arry success:^(id responseObject) {
        
        NSData *thaData = responseObject;

        [messageData addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:thaData options:NSJapaneseEUCStringEncoding  error:nil]];
        
                [self.myMessageTableview reloadData];

        
    } failure:^(NSError *erro) {
         
        
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return messageData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunityMyViewCell *cell=[[CommunityMyViewCell alloc ]init];
    cell=[tableView dequeueReusableCellWithIdentifier:@"ComMycell" forIndexPath:indexPath];
    
    if (messageData.count>0) {
        
        NSString *str = messageData[indexPath.row][@"helpContent"];
        if (str.length >0) {
            NSString *substr = [NSString stringWithFormat:@"%@%@",[str substringWithRange:NSMakeRange(0, 2)],@"..."];
            cell.messageContent.text = substr;
            cell.messageTime.text=[self timeTurn:[NSString stringWithFormat:@"%@",messageData[indexPath.row][@"helpPosttime"]]];
        }
    
    }
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.myMessageTableview deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (IBAction)CommunityBack_bt:(id)sender {
    
    
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}


//时间戳转时间
-(NSString*)timeTurn:(NSString*)theTime{
    
    double lastactivityInterval = [theTime doubleValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"M月dd日 HH:MM"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
//导航条背景
-(void)viewDidAppear:(BOOL)animated{
    
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"chekMyhelpSegue"]&&messageData.count>0) {
        
        
        NSIndexPath  *indexthPath=[self.myMessageTableview indexPathForSelectedRow];

        [[segue destinationViewController] setChekHelpData:@[messageData[indexthPath.row][@"helpUserName"],messageData[indexthPath.row][@"helpContact"],messageData[indexthPath.row][@"helpAddress"],messageData[indexthPath.row][@"helpToUserName"],messageData[indexthPath.row][@"helpTitle"],messageData[indexthPath.row][@"helpContent"]]];
    }if ([[segue identifier] isEqualToString:@"toTheHelpSegue"]) {
        SendHelpController *sendVC = [segue destinationViewController];
        sendVC.communityName = name;
    }
    
}


- (IBAction)selectMy_Help_bt:(id)sender {
    
    NSInteger index=self.selectMy_Help_ol.selectedSegmentIndex;
    
    switch (index) {
        
        case 1:
            
            self.ComHelpView.hidden=YES;
            self.ComMyView.hidden=NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            ComLine.transform=CGAffineTransformMakeTranslation(UISCREENWIDTH/2, 0);
            [UIView commitAnimations];
            
            
           
            break;
            
        default:
            
            self.ComHelpView.hidden=NO;
            self.ComMyView.hidden=YES;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            ComLine.transform=CGAffineTransformMakeTranslation(0, 0);
            [UIView commitAnimations];
            
           
            break;
    }
    
}
@end
