//
//  UserAgreementController.m
//  ISQ
//
//  Created by mac on 15-5-11.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "UserAgreementController.h"

@interface UserAgreementController ()

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
    
    
   
    
    self.ageemenTitle_label.text=_useAgreeData[0];
    
    
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",_useAgreeData[0]] ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.agreementWebview loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
