//
//  LocalTableViewCell.h
//  ISQ
//
//  Created by mac on 15-3-20.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

@interface LocalTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sendHelplable1;
@property (weak, nonatomic) IBOutlet UITextField *sendHelp_ed;
@property (weak, nonatomic) IBOutlet UILabel *chekLable;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (weak, nonatomic) IBOutlet UITextView *sendHelplableDetail_tv;
//商铺
@property (weak, nonatomic) IBOutlet ClickImage *businessImg;
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UILabel *businessDistance;
@property (weak, nonatomic) IBOutlet UILabel *distanceCallnum;
@property (weak, nonatomic) IBOutlet UIButton *TellToShop_ol;
@property (weak, nonatomic) IBOutlet UIImageView *LevelImg;

@property (weak, nonatomic) IBOutlet UILabel *companyCallNumsLable;
@property (weak, nonatomic) IBOutlet UIImageView *companyIsOnCall;
@property (weak, nonatomic) IBOutlet UIImageView *companyChecked;
@property (weak, nonatomic) IBOutlet UILabel *toDistance;


@end
