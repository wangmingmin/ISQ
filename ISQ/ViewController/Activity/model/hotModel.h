//
//  hotModel.h
//  ISQ
//
//  Created by mac on 15-11-17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotModel : NSObject

@property (nonatomic,retain) NSNumber *specialId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,copy) NSString *thumbImage;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,copy) NSString *titleUrl;
@property (nonatomic,copy) NSString *addTime;
@property (nonatomic,copy) NSString *isTop;
@property (nonatomic,copy) NSString *checked;
@property (nonatomic,retain) NSNumber *communityId;


@end
