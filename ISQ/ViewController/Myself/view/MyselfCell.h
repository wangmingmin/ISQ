//
//  MyselfCell.h
//  ISQ
//
//  Created by mac on 15-3-27.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyselfCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myIocn;
@property (weak, nonatomic) IBOutlet UILabel *ContName;
@property (weak, nonatomic) IBOutlet UIImageView *useravatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *moneyCount;
@property (weak, nonatomic) IBOutlet UIButton *signButton;

@end
