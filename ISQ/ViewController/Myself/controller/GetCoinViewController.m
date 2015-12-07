//
//  GetCoinViewController.m
//  ISQ
//
//  Created by mac on 15-10-10.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "GetCoinViewController.h"

@interface GetCoinViewController ()

@end

@implementation GetCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"领取社区币";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"" size:23.0],NSFontAttributeName,nil]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getCoinBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES ];
}

@end
