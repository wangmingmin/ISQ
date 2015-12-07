//
//  OrderDetailimageCell.m
//  ISQ
//
//  Created by mac on 15-11-1.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "OrderDetailimageCell.h"

@implementation OrderDetailimageCell

- (void)awakeFromNib {
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.detailLabel.textColor = [UIColor darkGrayColor];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:[UIView lineWidth:UISCREENWIDTH-20 lineHeight:1.0f lineColor:[UIColor hexStringToColor:@"#DBE1E3" alpha:1] lineX:10 lineY:88]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
