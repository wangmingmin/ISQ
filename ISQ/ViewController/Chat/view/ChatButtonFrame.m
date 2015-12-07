//
//  ChatButtonFrame.m
//  ISQ
//
//  Created by Mac_SSD on 10/25/15.
//  Copyright © 2015 cn.ai-shequ. All rights reserved.
//

#import "ChatButtonFrame.h"

@implementation ChatButtonFrame

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    
    
    
    
    return CGRectMake(contentRect.size.width/2-11, 55, 22, 11);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    
    
    return CGRectMake(0, 0, 50, 50);
}


@end
