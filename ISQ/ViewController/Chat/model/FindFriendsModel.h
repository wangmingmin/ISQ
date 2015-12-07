//
//  AnnouncementModel.h
//  ISQ
//
//  Created by none on 15/7/17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindFriendsModel : NSDictionary

@property (nonatomic ,copy) NSString *first;
@property (nonatomic, copy) NSString *last;
@property (nonatomic, copy) NSString *telphone;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *user;

-(id)initWithDataDic:(NSDictionary*)data;

- (NSDictionary*)attributeMapDictionary;

@end
