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

@interface SeconWebController ()<UIWebViewDelegate>{
    
    UIView *errorView;
    BDMLocationController *bdmapVC;
    BOOL isFristLoad;
}
@property (strong, nonatomic)NSTimer *timer;

@property (strong, nonatomic)NSTimer *timerLocation;

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

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
     if ([request.mainDocumentURL.relativeString rangeOfString:@"isq_back_native"].location !=NSNotFound){
        
         isFristLoad=true;
         self.navigationController.navigationBar.hidden=NO;
         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//       [self.navigationController popToRootViewControllerAnimated:YES];
         [self.navigationController popViewControllerAnimated:YES];
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
    
    [self removeTimer];
    [self hideHud];
    
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
