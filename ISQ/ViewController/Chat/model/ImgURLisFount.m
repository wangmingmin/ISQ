//
//  ImgURLisFount.m
//  ISQ
//
//  Created by mac on 15-7-16.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ImgURLisFount.h"

@implementation ImgURLisFount


//简单的通过判断url里面是否包含png\jpg
+(BOOL)theUrlisFountImg:(id)urlStr{
    
    
    if ([[[NSString stringWithFormat:@"%@",urlStr] substringFromIndex:[[NSString stringWithFormat:@"%@",urlStr] length]-4] isEqualToString:@".jpg"]||[[[NSString stringWithFormat:@"%@",urlStr] substringFromIndex:[[NSString stringWithFormat:@"%@",urlStr] length]-4] isEqualToString:@".png"]) {
        
        
        return YES;
        
        
    }
    
    return NO;
}
//0既不是jpg也不是png  1 - png   2-jpg
+(int)TheDataIsImgage:(UIImage*)image{
    
    
    
    NSData *dataObj = UIImageJPEGRepresentation(image, 1.0);
    if (dataObj) {
        Byte pngHead[] = {0x89, 0x50, 0x4e, 0x47};
        Byte jpgHead[] = {0xff, 0xd8, 0xff, 0xe0};
       
        
        int cmpResultJpg = memcmp(dataObj.bytes, jpgHead, 4);//判断是否为jpg格式
        
        if (cmpResultJpg==0) {
            
            return 2;
        }else{
            
            int cmpResultPng = memcmp(dataObj.bytes, pngHead, 8);//判断是否为png格式
            if (cmpResultPng==0) {
                
                return 1;
            }
            return 0;
        }
        
    }
    
    
    return 0;
}

@end
