//
//  UserDetailTableViewCell.m
//  ISQ
//
//  Created by none on 15/7/7.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "UserDetailTableViewCell.h"

@implementation UserDetailTableViewCell
@synthesize addButton_ol;
- (void)awakeFromNib {
    
    
    self.addButton_ol.layer.cornerRadius=18.f;
    self.addButton_ol.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButton:(id)sender {
    
    
    
    
}
@end
