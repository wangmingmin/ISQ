//
//  SecondWebViewController.m
//  ISQ
//
//  Created by mac on 15-6-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ThreeWebController.h"
#import "SeconWebController.h"

@interface ThreeWebController ()<UIWebViewDelegate>{
    
    NSString *secondUrl;
    NSString *theWebUrl;

}

@end

@implementation ThreeWebController
@synthesize secondWebView,titleLable;


-(instancetype)initWithSecondWebUrl:(NSString *)webUrl{
    
    
    secondUrl = webUrl;
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.secondWebView.delegate=self;

    [self loadWeb];
    
    
}


-(void)loadWeb{
    
    
    NSURL *url=[[NSURL alloc]initWithString:secondUrl];
    
    [self.secondWebView loadRequest:[NSURLRequest requestWithURL:url]];

    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    theWebUrl=request.mainDocumentURL.relativeString;
    NSLog(@"获取到URL--%@",request.mainDocumentURL.relativeString);
    if([request.mainDocumentURL.relativeString rangeOfString:@"isq_back_native"].location != NSNotFound){
        
        return NO;
    }
    
    return NO;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)back_bt:(id)sender {
    
    if ([theWebUrl rangeOfString:@"Home/Repair/"].location !=NSNotFound||[theWebUrl rangeOfString:@"Home/Property"].location !=NSNotFound||[theWebUrl rangeOfString:@"Home/Pay/"].location !=NSNotFound) {
        
        
        if([theWebUrl rangeOfString:@"Home/Repair/account"].location !=NSNotFound){
            
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ThreeWebController *seconWebVC=[[board instantiateViewControllerWithIdentifier:@"ThreeWebController"] initWithSecondWebUrl:@"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Property/property.html"];
            
            [seconWebVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:seconWebVC animated:NO];
        }
        else if([theWebUrl rangeOfString:@"Home/Property/news"].location !=NSNotFound){
            
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ThreeWebController *seconWebVC=[[board instantiateViewControllerWithIdentifier:@"ThreeWebController"] initWithSecondWebUrl:@"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Property/property.html"];
            
            [seconWebVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:seconWebVC animated:NO];
            
        }
        
        else if([theWebUrl rangeOfString:@"Home/Pay/account"].location !=NSNotFound){
            
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ThreeWebController *seconWebVC=[[board instantiateViewControllerWithIdentifier:@"ThreeWebController"] initWithSecondWebUrl:@"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Property/property.html"];
            
            [seconWebVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:seconWebVC animated:NO];
            
            
            
        }
        
        else if([theWebUrl rangeOfString:@"Home/Property/property"].location !=NSNotFound){
            
            
            
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SeconWebController *seconWebVC=[storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
            seconWebVC.theUrl=[NSString stringWithFormat:@"%@bid/%@/uid/%d/type/%@",shDetailURL,[user_info objectForKey:@"companyId"],[[user_info objectForKey:MyUserID] intValue],@"2"];
           
            
            [self.navigationController pushViewController:seconWebVC animated:NO];
            
            
        }
        
         else if([theWebUrl rangeOfString:@"Pay/detail"].location !=NSNotFound){
            
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ThreeWebController *seconWebVC=[[board instantiateViewControllerWithIdentifier:@"ThreeWebController"] initWithSecondWebUrl:@"http://dt.app.ai-shequ.cn:81/index.php?s=/Home/Pay/account.html"];
            
            [seconWebVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:seconWebVC animated:NO];
            
            
        }else{
            if ([self.secondWebView canGoBack]) {
                
                [self.secondWebView goBack];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
            
        }

        
    }else{
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (IBAction)myRoom_bt:(id)sender {
    
    
    //初始化物业的数据
//    [self SheetMenu];
}
@end
