//
//  FriendsTableViewCell.m
//  ISQ
//
//  Created by mac on 15-3-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell
@synthesize myFriendsImg;
- (void)awakeFromNib {
    
    
    self.myFriendsImg.layer.borderWidth=0.5f;
    self.myFriendsImg.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
    self.myFriendsImg.layer.masksToBounds=YES;
    self.myFriendsImg.layer.cornerRadius=4.0f;
    self.myFriendsImg.canClick=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toChat_bt:(id)sender {
}


@end
