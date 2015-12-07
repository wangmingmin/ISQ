//
//  HomeButton.m
//  ISQ
//
//  Created by mac on 15-4-20.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "HomeButton.h"

@implementation HomeButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width)/2-15.0f,53,contentRect.size.width,15);
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width)/2-25.0f,0,50,50);
}

@end
