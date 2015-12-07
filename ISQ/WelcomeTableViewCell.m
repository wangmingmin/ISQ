//
//  WelcomeTableViewCell.m
//  ISQ
//
//  Created by mac on 15-4-28.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "WelcomeTableViewCell.h"

@implementation WelcomeTableViewCell

- (void)awakeFromNib {

    [self.welcomeImg setImage:[UIImage imageNamed:@"splash_image"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
