//
//  MoneyViewController.m
//  ISQ
//
//  Created by mac on 15-8-8.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MoneyViewController.h"

@interface MoneyViewController ()

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];//初始化图像视图（桃红色）
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.moneyDeatilView.image = [UIImage imageNamed:@"moneydetail"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{

    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];//初始化图像视图（桃红色）
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

}

- (IBAction)moneyDetailBut:(id)sender {
    
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
