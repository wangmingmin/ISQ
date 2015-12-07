//
//  ActivityDetailContentCell.h
//  ISQ
//
//  Created by Mac_SSD on 15/10/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailContentCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView*)tableView;
@property(nonatomic ,strong) UILabel *contentLable;
@property (nonatomic ,strong) UIImageView *img1;
@property (nonatomic ,strong) UIImageView *img2;
@property (nonatomic ,strong) UIImageView *img3;
@property (nonatomic,strong) NSArray *arrayList;

@end
