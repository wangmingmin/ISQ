//
//  ActivityDetailImagCell.m
//  ISQ
//
//  Created by Mac_SSD on 15/11/22.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "ActivityDetailImagCell.h"

@implementation ActivityDetailImagCell
@synthesize userHeadImg;


- (void)awakeFromNib {
    
    self.userHeadImg.layer.cornerRadius=22.5f;
    self.userHeadImg.layer.masksToBounds=YES;
    self.userHeadImg.layer.borderWidth=0.3f;
    self.userHeadImg.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.4f].CGColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
