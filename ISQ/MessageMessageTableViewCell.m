//
//  MessageMessageTableViewCell.m
//  ISQ
//
//  Created by mac on 15-3-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MessageMessageTableViewCell.h"

@implementation MessageMessageTableViewCell
@synthesize userImage;
- (void)awakeFromNib {
    // Initialization code
    self.userImage.layer.cornerRadius=
    3.0f;
    self.userImage.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
