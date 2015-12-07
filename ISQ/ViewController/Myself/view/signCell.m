//
//  signCell.m
//  ISQ
//
//  Created by mac on 15-11-10.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "signCell.h"

@implementation signCell

- (void)awakeFromNib {

    self.signTextfield.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textbg"]];
    self.signTextfield.adjustsFontSizeToFitWidth = YES;
    self.signTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.signTextfield.tag = 601;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
