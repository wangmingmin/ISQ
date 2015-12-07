//
//  AnnouncementModel.m
//  ISQ
//
//  Created by none on 15/7/17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "AnnouncementModel.h"

@implementation AnnouncementModel

-(id)initWithDataDic:(NSDictionary*)data{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}

-(NSDictionary*)attributeMapDictionary{
    return nil;
}

-(void)setAttributes:(NSDictionary*)dataDic{
   
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    
    if (attrMapDic == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
        
        
        for (NSString *key in dataDic) {
            
            
            
            [dic setValue:key forKey:key];
            attrMapDic = dic;
        }
    }
   
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    
    
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        
       
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
            id attributeValue = [dataDic objectForKey:dataDicKey];
            
            [self performSelectorOnMainThread:sel
                                   withObject:attributeValue
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}

-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    
   
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    
    
    return NSSelectorFromString(setterSelStr);
}


@end
