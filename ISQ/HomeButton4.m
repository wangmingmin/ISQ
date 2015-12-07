//
//  HomeButton4.m
//  ISQ
//
//  Created by mac on 15-4-20.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "HomeButton4.h"

@implementation HomeButton4

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width)/2-27.0f,52,contentRect.size.width,14);
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width)/2-22.5f,0,45,45);
}


@end
