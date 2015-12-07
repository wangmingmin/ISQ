//
//  ChangeInfoCell.h
//  ISQ
//
//  Created by mac on 15-4-3.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *NikeNameEd;
@property (weak, nonatomic) IBOutlet UILabel *SexLable;
@property (weak, nonatomic) IBOutlet UIImageView *SexChosebg;
@property (weak, nonatomic) IBOutlet UILabel *CounNunber;
@property (weak, nonatomic) IBOutlet UITextField *SigatureEd;
@property (weak, nonatomic) IBOutlet UILabel *CommunityLable;

@property (weak, nonatomic) IBOutlet UILabel *CommunityFromNet;
@property (weak, nonatomic) IBOutlet UILabel *adressName;
@property (weak, nonatomic) IBOutlet UILabel *add_Address;

@property (weak, nonatomic) IBOutlet UILabel *myPlace_lable;



@end
