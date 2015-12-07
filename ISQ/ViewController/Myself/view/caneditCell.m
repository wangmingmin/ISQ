//
//  caneditCell.m
//  ISQ
//
//  Created by mac on 15-10-16.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "caneditCell.h"

@implementation caneditCell

- (void)awakeFromNib {
    self.changeTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textbg"]];
    self.changeTextField.adjustsFontSizeToFitWidth = YES;
    self.changeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.changeTextField.tag = 600;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
