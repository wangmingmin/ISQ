//
//  HotVideoModel.h
//  ISQ
//
//  Created by mac on 15-10-25.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotVideoModel : NSObject

@property (nonatomic,copy) NSString *videoID;
@property (nonatomic ,copy) NSString *activeID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *uploadTime;
@property (nonatomic,copy) NSString *tagID;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *hqImage;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,retain) NSNumber *duration;
@property (nonatomic,copy) NSString *realPath;
@property (nonatomic,copy) NSString *isCollect;
@property (nonatomic,copy) NSString *userFace;
@property (nonatomic,copy) NSString *userNickName;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,retain) NSNumber *likeNum;
@property (nonatomic,retain) NSNumber *joinNum;
@property (nonatomic,copy) NSString *join;
@property (nonatomic,copy) NSString *like;



@end
