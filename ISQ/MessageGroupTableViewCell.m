//
//  MessageGroupTableViewCell.m
//  ISQ
//
//  Created by mac on 15-3-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MessageGroupTableViewCell.h"

@implementation MessageGroupTableViewCell
@synthesize groupImage,groupName;
- (void)awakeFromNib {
    // Initialization code
    //群组头像圆形
    self.groupImage.layer.cornerRadius=self.groupImage.frame.size.width/2.0f;
    self.groupImage.layer.masksToBounds=YES;
    
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
