//
//  OrderDetailCell.m
//  ISQ
//
//  Created by mac on 15-10-14.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell
@synthesize detailLabel;
- (void)awakeFromNib {
    
    
    [self addSubview:[UIView lineWidth:UISCREENWIDTH-20 lineHeight:1.0f lineColor:[UIColor hexStringToColor:@"#DBE1E3" alpha:1] lineX:10 lineY:85]];
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
