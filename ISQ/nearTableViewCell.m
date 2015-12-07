//
//  nearTableViewCell.m
//  ISQ
//
//  Created by mac on 15-3-27.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "nearTableViewCell.h"

@implementation nearTableViewCell
@synthesize nearUserImg;
- (void)awakeFromNib {
    // Initialization code
    
    
    self.nearUserImg.layer.cornerRadius=2.0f;
    self.nearUserImg.layer.masksToBounds=YES;
    self.nearUserImg.layer.borderWidth=0.6f;
    self.nearUserImg.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
