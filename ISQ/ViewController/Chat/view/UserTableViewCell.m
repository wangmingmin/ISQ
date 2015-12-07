//
//  UserTableViewCell.m
//  ISQ
//
//  Created by none on 15/7/7.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    
    self.remarkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.remarkTextField.keyboardType = UIReturnKeyDone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
