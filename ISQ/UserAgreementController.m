//
//  UserAgreementController.m
//  ISQ
//
//  Created by mac on 15-5-11.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "UserAgreementController.h"
@interface UserAgreementController ()<UIWebViewDelegate>

@end

@implementation UserAgreementController
@synthesize agreementWebview,ageemenTitle_label;

-(void)setUseAgreeData:(NSArray *)oldUseAgreeData{
    
    
    if (_useAgreeData!=oldUseAgreeData) {
        _useAgreeData=oldUseAgreeData;
    }
    
    
}
-(instancetype)initWithAgreeData:(NSArray *)agreeData{
    
    
    _useAgreeData=agreeData;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * htmlStr = @"http://webapp.wisq.cn/User/agreement.html";
    NSURL * url = [NSURL URLWithString:htmlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    self.navigationController.navigationBar.hidden=YES;
    [self.agreementWebview loadRequest:request];
    self.agreementWebview.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.ageemenTitle_label.text=_useAgreeData[0];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",_useAgreeData[0]] ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.agreementWebview loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.mainDocumentURL.relativeString rangeOfString:@"isq_back_native"].location !=NSNotFound){
        self.navigationController.navigationBar.hidden=NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
