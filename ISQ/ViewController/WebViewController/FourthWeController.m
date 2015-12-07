//
//  FourthWeController.m
//  ISQ
//
//  Created by mac on 15-6-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "FourthWeController.h"

@interface FourthWeController ()<UIWebViewDelegate>{
    
    NSString *threeUrl;
}

@end

@implementation FourthWeController
@synthesize fourthWebview;

-(instancetype)initWithThreeWebUrl:(NSString *)webUrl{
    
    threeUrl=webUrl;
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fourthWebview.delegate=self;
    //载入webview
    [self loadWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadWeb{
    
    
    NSURL *url=[[NSURL alloc]initWithString:threeUrl];
    
    [self.fourthWebview loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}
- (IBAction)back_bt:(id)sender {
    
    if ([self.fourthWebview canGoBack]) {
        
        [self.fourthWebview goBack];
        
    }else {
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}
@end
