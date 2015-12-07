//
//  MyFavoriteViewController.m
//  ISQ
//
//  Created by mac on 15-10-19.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "videoCell.h"
#import "ImageCell.h"

@interface MyFavoriteViewController ()

@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - tableView delegate

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return 5;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0 || indexPath.row == 2) {
//        videoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
//        
//        return cell;
//    }
//    
//    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 254;
//}


@end
