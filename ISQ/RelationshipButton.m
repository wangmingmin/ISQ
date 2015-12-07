//
//  RelationshipButton.m
//  ISQ
//
//  Created by mac on 15-3-25.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "RelationshipButton.h"


@implementation RelationshipButton




- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake((contentRect.size.width)/2-25,35,contentRect.size.width,18);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width)/2-12,0,27,27);
}
@end
