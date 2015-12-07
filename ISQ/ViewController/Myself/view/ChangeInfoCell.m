//
//  ChangeInfoCell.m
//  ISQ
//
//  Created by mac on 15-4-3.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ChangeInfoCell.h"

@implementation ChangeInfoCell
@synthesize NikeNameEd,SigatureEd;
- (void)awakeFromNib {
    // Initialization code
    
    [self.NikeNameEd becomeFirstResponder];
    [self.SigatureEd becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
