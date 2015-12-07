//
//  AnnouncementModel.h
//  ISQ
//
//  Created by none on 15/7/17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeighborsModel : NSDictionary

@property (nonatomic ,copy) NSString *nick;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *isFriend;
@property (nonatomic, copy) NSString *avatar;

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;

@end