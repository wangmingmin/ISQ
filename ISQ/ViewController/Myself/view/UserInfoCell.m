//
//  UserInfoCell.m
//  ISQ
//
//  Created by mac on 15-4-2.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell
@synthesize userInfoImg;

- (void)awakeFromNib {
    
    [self borderLine];
}

-(void)borderLine{
    
    self.userInfoImg.layer.masksToBounds = YES;
    self.userInfoImg.layer.cornerRadius = 65/2;
    self.userInfoImg.layer.borderWidth = 1.0;
    self.userInfoImg.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:1].CGColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)uploadPhoto:(id)sender {
    
}

@end
