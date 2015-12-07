//
//  CommunityViewController.m
//  ISQ
//
//  Created by mac on 15-10-9.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityCell.h"

@interface CommunityViewController (){


}

@property (weak, nonatomic) IBOutlet UITableView *communityTableView;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改社区";
    [[ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleDefault ];
    self.tabBarController.tabBar.hidden=YES;
    self.communityTableView.tableFooterView = [[UIView alloc] init];
    self.communityTableView.separatorColor = [UIColor whiteColor];
    if ([self.communityTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.communityTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.communityTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.communityTableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"communitycell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)communityBack:(id)sender {
    //状态栏字体颜色
    [[ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleLightContent ];
    self.tabBarController.tabBar.hidden=NO;
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES ];
}


@end
