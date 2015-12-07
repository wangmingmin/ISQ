//
//  AnnouncementModel.h
//  ISQ
//
//  Created by none on 15/7/17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementModel : NSDictionary

@property (nonatomic ,copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *titleUrl;
@property (nonatomic, copy) NSString *content;


-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;

@end