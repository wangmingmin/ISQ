//
//  LocalTableViewCell.m
//  ISQ
//
//  Created by mac on 15-3-20.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "LocalTableViewCell.h"

@implementation LocalTableViewCell
@synthesize sendHelplableDetail_tv,businessImg;
- (void)awakeFromNib {
    
    self.sendHelplableDetail_tv.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
    self.sendHelplableDetail_tv.layer.borderWidth=0.5f;
    self.sendHelplableDetail_tv.layer.cornerRadius=4.f;
    self.sendHelplableDetail_tv.layer.masksToBounds=YES;
    self.sendHelplableDetail_tv.delegate = self;
    
    self.businessImg.layer.cornerRadius=4.f;
    self.businessImg.layer.masksToBounds=YES;
    self.businessImg.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
    self.businessImg.layer.borderWidth=0.5f;
    
    self.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.4f].CGColor;
    self.layer.borderWidth=0.4f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
