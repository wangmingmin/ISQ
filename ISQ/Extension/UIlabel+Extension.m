//
//  UIlabel+Extension.m
//  ISQ
//
//  Created by Mac_SSD on 15/10/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "UIlabel+Extension.h"

@implementation UILabel(Extension)


/**
 *  计算Label的高度
 *
 *  @param str   字符串
 *  @param lable 当前label
 *  @param 的label 计算高度要记得带宽度
 *  @return CGSize
 */
+(CGSize)getLabelHeight:(NSString*)str theUIlabel:(UILabel*)lable{
    
    //-boundingRectWithSize:options:attributes:context:
    CGSize maxSize = CGSizeMake(lable.width, MAXFLOAT);
    CGSize labelSize = [str sizeWithFont:lable.font constrainedToSize:maxSize];
//    CGSize labelSize = [str boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
   
    return labelSize;
}

@end
