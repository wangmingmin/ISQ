//
//  RelationCollectionCell.m
//  ISQ
//
//  Created by mac on 15-4-14.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "RelationCollectionCell.h"

@implementation RelationCollectionCell


@synthesize neatManImg,activityUserImg,nearImg;

- (void)awakeFromNib {
    
    
    self.neatManImg.layer.cornerRadius=4.0f;
    self.neatManImg.layer.masksToBounds=YES;
    self.neatManImg.layer.borderWidth=0.5f;
    self.neatManImg.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.9f].CGColor;
    
    self.nearImg.layer.cornerRadius=4.0f;
    self.nearImg.layer.masksToBounds=YES;
    self.nearImg.layer.borderWidth=0.5f;
    self.nearImg.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.9f].CGColor;
}

@end
