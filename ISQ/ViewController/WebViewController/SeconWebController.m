//
//  LocationSeconWebController.m
//  ISQ
//
//  Created by mac on 15-6-21.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "SeconWebController.h"
#import "TestJSObject.h"
#import "BDMLocationController.h"
#import "AppDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BeeCloud.h"

@interface SeconWebController ()<UIWebViewDelegate,BeeCloudDelegate,UIAlertViewDelegate>{
    
    UIView *errorView;
    BDMLocationController *bdmapVC;
    BOOL isFristLoad;
    int timesssss;
}
@property (strong, nonatomic)NSTimer *timer;

@property (strong, nonatomic)NSTimer *timerLocation;

@property (strong, nonatomic)NSTimer *payTimer;
@property (strong, nonatomic)UIAlertView *payAlertView;

@end



@implementation SeconWebController


@synthesize theTitle,back_ol,seconWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
   
     isFristLoad=true;
    self.navigationController.navigationBar.hidden=YES;
    self.seconWebView.scrollView.bounces=NO;
    self.seconWebView.scalesPageToFit = YES ;
    self.seconWebView.delegate=self;
    [self loadWeb:self.theUrl];
    
    //加载错误时出现的页面
    [self loadErrorView];
    
    timesssss=0;
    //监听触摸
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toRefresh:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    [errorView addGestureRecognizer:tapGestureRecognizer];
    //30秒获取一次经纬度
    self.timerLocation= [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(ocToJs) userInfo:nil repeats:YES];
    

}


# pragma mark - timer
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(ErrorViewShow) userInfo:nil repeats:NO];
    
}

-(void)loadWeb:(NSString*)loadUrL{
    
    NSURL *thewebUrl=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",loadUrL]];
    
   
    [self.seconWebView loadRequest:[NSURLRequest requestWithURL:thewebUrl]];
    
}


-(void)ErrorViewShow{
    
    //显示错误页面
    errorView.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
}

//错误页面
-(void)loadErrorView{
    
    self.title=@"加载出现问题";
    errorView=[[UIView alloc ]init];
    errorView.backgroundColor=[UIColor lightGrayColor];
    errorView.x=0;
    errorView.y=64;
    errorView.width=UISCREENWIDTH;
    errorView.height=UISCREENHEIGHT;
    
    errorView.hidden=YES;
    
    UIImageView *img=[[UIImageView alloc]init];
    img.width=100;
    img.height=100;
    img.x=UISCREENWIDTH/2-50;
    img.y=UISCREENHEIGHT/2-50;
    img.image=[UIImage imageNamed:@"errorWeb"];
    
    UILabel *lable=[[UILabel alloc]init];
    lable.x=UISCREENWIDTH/2-150/2;
    lable.y=img.y+img.height+5;
    lable.width=150;
    lable.height=20;
    lable.textColor=[UIColor grayColor];
    lable.text=@"轻点屏幕重新加载";
    
    [errorView addSubview:lable];
    [errorView addSubview:img];
    [self.view addSubview:errorView];
    [self hideHud];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    errorView.hidden=YES;
    self.seconWebView.hidden=NO;
    [self hideHud];
    [self showHudInView:self.view hint:@"正在加载..."];
    
    //计时器
    [self addTimer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.seconWebView.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [BeeCloud setBeeCloudDelegate:self];

}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
     if ([request.mainDocumentURL.relativeString rangeOfString:@"isq_back_native"].location !=NSNotFound){
        
         isFristLoad=true;
         self.navigationController.navigationBar.hidden=NO;
         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
         [self.navigationController popViewControllerAnimated:YES];
         
         [self.payAlertView removeFromSuperview];
         [self.payTimer invalidate];
     }
    if([request.mainDocumentURL.relativeString rangeOfString:@"http://map.baidu.com/mobile/webapp/index/streetview/ss_id"].location !=NSNotFound){
        
        
        if (isFristLoad) {
            
            isFristLoad=false;
            return YES;
            
        }else{
            
            
            return NO;
        }
        
        
    }
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    self.navigationController.navigationBar.hidden=NO;
    self.seconWebView.hidden=YES;
    errorView.hidden=NO;
    [self removeTimer];
    [self hideHud];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
   //JS调用分享
    TestJSObject *testJO=[TestJSObject new];
    context[@"UseNative"]=testJO;
    testJO.passBill = ^(NSDictionary * billDic) {
        if (billDic != nil) {
            NSLog(@"bill Dic = %@",billDic);
            [self doPayWithBill:billDic];//支付物业费
        }
    };
    
    [self removeTimer];
    [self hideHud];
    
}

- (void)doPayWithBill:(NSDictionary *)billDic{
    NSDictionary * data = billDic[@"data"];
    NSString * channelFromData = data[@"channel"];
    NSString *billno = data[@"order_no"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = [channelFromData isEqualToString:@"ali_pay"]?PayChannelAliApp:PayChannelWxApp;//"ali_pay"和"wx_pay"
    payReq.title = data[@"title"];
    CGFloat totalFeeFloat = [data[@"total_fee"] floatValue]*100;
    if (totalFeeFloat <1) {
        [self showAlertView:@"请输入正确的金额，至少一分钱哦"];
        return;
    }
    payReq.totalFee = [NSString stringWithFormat:@"%.0f",totalFeeFloat];
    payReq.billNo = billno;
    payReq.scheme = [channelFromData isEqualToString:@"ali_pay"]?@"payZhiFuBao":weixinAppID;
    payReq.billTimeOut = 300;
//    payReq.viewController = self;//银联支付需要
    payReq.optional = dict;
    [BeeCloud sendBCReq:payReq];
}

#pragma beecloud响应
-(void)onBeeCloudResp:(BCBaseResp *)resp
{
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            //支付响应事件类型，包含微信、支付宝、银联、百度
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                BCPayReq *payReq = (BCPayReq *)resp.request;
                if (payReq.channel == PayChannelBaiduApp) {
                } else {
                    [self checkPay:(BCPayResp *)resp];//支付宝成功后公司后台再验证才算成功
//                    [self showAlertView:resp.resultMsg];
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];

            }
        }
            break;
            
            //暂时没有查询功能，开放时参考桌面案例beecloudTest
//        case BCObjsTypeQueryResp:
//        {
//            //查询订单或者退款记录响应事件类型
//            BCQueryResp *tempResp = (BCQueryResp *)resp;
//            if (resp.resultCode == 0) {
//                if (tempResp.count == 0) {
//                    [self showAlertView:@"未找到相关订单信息"];
//                } else {
//                    self.payList = tempResp.results;
//                    [self performSegueWithIdentifier:@"queryResult" sender:self];
//                }
//            } else {
//                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
//            }
//        }
//            break;
        default:
        {
            if (resp.resultCode == 0) {
                [self showAlertView:resp.resultMsg];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",resp.resultMsg, resp.errDetail]];
            }
        }
            break;
    }
    
}

-(void)checkPay:(BCPayResp *)resp
{
    [self addPayAlertView];

    [self.payTimer invalidate];
    self.payTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkPayIsSucceed:) userInfo:resp repeats:YES];
}

-(void)addPayAlertView
{
    [self.payAlertView dismissWithClickedButtonIndex:[self.payAlertView cancelButtonIndex] animated:YES];

    self.payAlertView = [[UIAlertView alloc] initWithTitle:@"提示5" message:@"支付验证中，请稍等..." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    self.payAlertView.delegate = self;
    [self.payAlertView show];
}

-(void)willPresentAlertView:(UIAlertView *)alertView
{
    alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y, 275, alertView.frame.size.height);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertView.bounds.size.width, 40)];
    
    UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(view.frame.size.width / 2.0f, activityIndicatorView.center.y);
    [view addSubview:activityIndicatorView];
    [alertView setValue:view forKey:@"accessoryView"];
    [activityIndicatorView startAnimating];
}

-(void)checkPayIsSucceed:(NSTimer *)sender
{
    timesssss ++;
    BCPayResp * resp = sender.userInfo;
    [self.payAlertView setTitle:[NSString stringWithFormat:@"提示%d",5-timesssss]];
    if (timesssss==5) {
        [self finishCheckPay:resp.resultMsg];
    }
}

-(void)finishCheckPay:(NSString *)resultMsg
{
    
    [self.payTimer invalidate];
    
    [self.payAlertView dismissWithClickedButtonIndex:[self.payAlertView cancelButtonIndex] animated:YES];
    
    [self showAlertView:resultMsg];
    
    timesssss =0;

}

- (void)showAlertView:(NSString *)msg {
    NSString *title = @"";
    NSString *message = msg;
    NSString *cancelButtonTitle = @"确定";
    //    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}





-(void)ocToJs{
    
    //百度地图定位
    bdmapVC=[[BDMLocationController alloc]init];
    [bdmapVC baiduMapLocationL];
    [bdmapVC startLocation];
    
    AppDelegate *locationCityDelegate;
    locationCityDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    JSContext *context=[self.seconWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //OC调用JS，传送地理位置
    NSString *OCToJs=[NSString stringWithFormat:@"get_native_loc('%f,%f')",locationCityDelegate.theLa,locationCityDelegate.theLo];
    [context evaluateScript:OCToJs];
}

- (IBAction)back_bt:(id)sender {
    
    self.navigationController.navigationBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self removeTimer];
    [self.timerLocation invalidate];
    self.seconWebView.delegate = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
}

- (void)removeTimer
{
    [self.timer invalidate];
}

//刷新
-(void)toRefresh:(UITapGestureRecognizer*)tap{
    
    [self loadWeb:self.theUrl];
    [self removeTimer];
}


@end
