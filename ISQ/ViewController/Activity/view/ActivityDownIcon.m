//
//  UIButton+ActivityDownIcon.m
//  ISQ
//
//  Created by Jun on 15/10/8.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "ActivityDownIcon.h"

@implementation ActivityDownIcon


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    
    return CGRectMake(8,contentRect.size.height/2-8,contentRect.size.width-8-8,12);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(contentRect.size.width-24,contentRect.size.height/2-8,13,15);
}

@end
