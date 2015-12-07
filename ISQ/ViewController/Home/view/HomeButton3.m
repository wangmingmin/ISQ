//
//  HomeButton3.m
//  ISQ
//
//  Created by mac on 15-4-20.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "HomeButton3.h"

@implementation HomeButton3
/**
 *  按钮文字的位置
 *
 *  @param contentRect 原按钮的Rect
 *
 *  @return 返回一个按钮文字的位置、大小
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width)/2-22.5f,53,contentRect.size.width,15);
}

/**
 *  按钮图片的位置、大小
 *
 *  @param contentRect 原按钮的Rect
 *
 *  @return 返回一个按钮图片的位置、大小
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width)/2-25.0f,0,50,50);
}


@end
