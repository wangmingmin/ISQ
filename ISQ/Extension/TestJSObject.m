//
//  TestJSObject.m
//  TestJSOC
//
//  Created by Mac_SSD on 15/11/17.
//  Copyright © 2015年 Mac_SSD. All rights reserved.
//

#import "TestJSObject.h"
#import "MainViewController.h"
@implementation TestJSObject

-(void)passShareParams:(NSString*)str {
    
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic=[[NSDictionary alloc] init];
    dic =[NSJSONSerialization JSONObjectWithData:data options:NSJapaneseEUCStringEncoding error:nil];
   
    if (dic[@"url"]) {
        
        [MainViewController  theShareSDK:dic];
    }
}


@end
