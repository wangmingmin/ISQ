//
//  HotImageCell.h
//  ISQ
//
//  Created by mac on 15-10-13.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageCellModel.h"


@interface ImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageTow;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageThree;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *clickzButton;
@property (weak, nonatomic) IBOutlet UIImageView *userFace;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (strong,nonatomic) imageCellModel *imageModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end
