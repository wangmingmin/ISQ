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
    
    TestJSObject *testJO;
    NSTimer *payTimer;
    NSString * totalFeeFromISQ;
    BOOL isCancelPayFromOtherApp;
}
@property (strong, nonatomic)NSTimer *timer;

@property (strong, nonatomic)NSTimer *timerLocation;

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
    
    isCancelPayFromOtherApp = NO;
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SeconWebControllerDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SeconWebControllerDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
     if ([request.mainDocumentURL.relativeString rangeOfString:@"isq_back_native"].location !=NSNotFound){
        
         isFristLoad=true;
         self.navigationController.navigationBar.hidden=NO;
         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
         [self.navigationController popViewControllerAnimated:YES];
         
         [self.payAlertView removeFromSuperview];
         [payTimer invalidate];
         payTimer = nil;
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
    testJO=[TestJSObject new];
    context[@"UseNative"]=testJO;
    __weak typeof(self) weakSelf = self;
    testJO.passBill = ^(NSDictionary * billDic) {
        if (billDic != nil) {
            NSLog(@"bill Dic = %@",billDic);
            [weakSelf addPayAlertViewWith:nil andMessage:@"支付请求中..."];
//            BOOL isHadAlipay = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf finishCheckPay:nil];
            });
            [weakSelf doPayWithBill:billDic];//支付物业费
        }
    };
    
    testJO.passPayRes = ^(NSDictionary * payDic) {//检查是否成功
        if (payDic != nil) {
            if ([payDic[@"data"] isEqualToString:@"SUCCESS"]) {
                [weakSelf SuccessPay];
            }
            else if ([payDic[@"data"] isEqualToString:@"FAIL"]) {
                [weakSelf FailPay];
            }
            else if ([payDic[@"data"] isEqualToString:@"WAITING"]){
                
            }

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
    payReq.totalFee = totalFeeFromISQ = [NSString stringWithFormat:@"%.0f",totalFeeFloat];
    payReq.billNo = billno;
    payReq.scheme = [channelFromData isEqualToString:@"ali_pay"]?@"payZhiFuBao":weixinAppID;
    payReq.billTimeOut = 300;
//    payReq.viewController = self;//银联支付需要
    payReq.optional = dict;
    [BeeCloud sendBCReq:payReq];
    isCancelPayFromOtherApp = YES;
}
//#pragma mark - 订单查询
//
//- (void)doQuery:(PayChannel)channel {
//    BCQueryReq *req = [[BCQueryReq alloc] init];
//    req.channel = channel;
//    req.billNo = billnono;
//    req.skip = 0;
//    req.limit = 1;
//    [BeeCloud sendBCReq:req];
//}

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
                    NSString * totalFeeFromBC = payReq.totalFee;
                    if (totalFeeFromISQ.integerValue != totalFeeFromBC.integerValue) {
                        [self ExceptionPay];
                        return;
                    }
                    [self checkPay:(BCPayResp *)resp];//支付宝成功后公司后台再验证才算成功
//                    [self showAlertView:resp.resultMsg];
                }
            } else {
                [self finishCheckPay:nil];
                if (tempResp.resultCode < 0) {
                    [self cancelPay];
                    return;
                }
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];

            }
        }
            break;
            
        case BCObjsTypeQueryResp:
        {
            //查询订单或者退款记录响应事件类型
            BCQueryResp *tempResp = (BCQueryResp *)resp;
            
        }
            break;
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

-(void) SeconWebControllerDidBecomeActive
{
    if (isCancelPayFromOtherApp) {//没有支付，返回爱社区app时
        isCancelPayFromOtherApp = NO;
        [self cancelPay];
    }
}

-(void) SeconWebControllerDidEnterBackground
{
    [self finishCheckPay:nil];
}
#pragma 开始检查支付是否成功
-(void)checkPay:(BCPayResp *)resp
{
    [self addPayAlertViewWith:@"提示5" andMessage:@"支付验证中，请稍等..."];

    [payTimer invalidate];
    payTimer = nil;
    payTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkPayIsSucceed:) userInfo:resp repeats:YES];
}

-(void)addPayAlertViewWith:(NSString *)title andMessage:(NSString *)message
{
    [self.payAlertView dismissWithClickedButtonIndex:[self.payAlertView cancelButtonIndex] animated:YES];

    self.payAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
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
    [testJO passPayResFiveTimes];
    BCPayResp * resp = sender.userInfo;
    [self.payAlertView setTitle:[NSString stringWithFormat:@"提示%d",5-timesssss]];
    NSLog(@"timersssss = %d",timesssss);
    if (timesssss==5) {
        [self finishCheckPay:resp.resultMsg];
        [self TimeOutPay];
    }
}

-(void)finishCheckPay:(NSString *)resultMsg
{
    [payTimer invalidate];
    payTimer = [[NSTimer alloc] init];
    payTimer = nil;
    
    [self.payAlertView dismissWithClickedButtonIndex:[self.payAlertView cancelButtonIndex] animated:YES];
    self.payAlertView = nil;
    if (resultMsg != nil) {
        [self showAlertView:resultMsg];
    }
    
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

#pragma 取消支付操作
-(void) cancelPay
{
    [self finishCheckPay:nil];
    JSContext *context=[self getJSContextFromWeb];
    NSString *OCToJs=[NSString stringWithFormat:@"get_native_pay_result('%@')",@"CANCEL"];
    [context evaluateScript:OCToJs];
}

#pragma 支付失败
-(void) FailPay
{
    [self finishCheckPay:@"支付失败，稍后请重试"];
    JSContext *context=[self getJSContextFromWeb];
    NSString *OCToJs=[NSString stringWithFormat:@"get_native_pay_result('%@')",@"FAIL"];
    [context evaluateScript:OCToJs];
}

#pragma 支付超时
-(void) TimeOutPay
{
    [self finishCheckPay:@"支付超时，如有异议请联系管理员"];
    JSContext *context=[self getJSContextFromWeb];
    NSString *OCToJs=[NSString stringWithFormat:@"get_native_pay_result('%@')",@"TIMEOUT"];
    [context evaluateScript:OCToJs];
}

#pragma 支付金额不一致
-(void) ExceptionPay
{
    [self finishCheckPay:@"支付异常，如有异议请联系管理员"];
    JSContext *context=[self getJSContextFromWeb];
    NSString *OCToJs=[NSString stringWithFormat:@"get_native_pay_result('%@')",@"EXCEPTION"];
    [context evaluateScript:OCToJs];
}

#pragma 支付成功
-(void) SuccessPay
{
    [self finishCheckPay:@"支付成功"];
    JSContext *context=[self getJSContextFromWeb];
    NSString *OCToJs=[NSString stringWithFormat:@"get_native_pay_result('%@')",@"SUCCESS"];
    [context evaluateScript:OCToJs];
}

-(JSContext *)getJSContextFromWeb
{
    AppDelegate *locationCityDelegate;
    locationCityDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    JSContext *context=[self.seconWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    return context;
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
