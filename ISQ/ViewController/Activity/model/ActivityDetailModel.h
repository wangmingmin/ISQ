//
//  ActivityDetailModel.h
//  ISQ
//
//  Created by Mac_SSD on 15/10/16.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetailModel : NSObject
/**
 *  头像
 */
@property (nonatomic ,copy) NSString *userFace;
/**
 * ownName
 */
@property (nonatomic ,copy) NSString *ownName;
/**
 *  otherName
 */
@property (nonatomic ,copy) NSString *otherName;

/**
 *  评论内容
 */
@property (nonatomic ,copy) NSString *CommentContent;

/**
 *  类型，是否是回复
 */
@property (nonatomic ,copy) NSString *isReply;



/**
 *  活动ID
 */
@property (nonatomic ,copy) NSString *activeID;
/**
 *
 */
@property (nonatomic ,copy) NSString *commentID;
/**
 *   评论内容
 */
@property (nonatomic ,copy) NSString *content;
/**
 *   时间
 */
@property (nonatomic ,copy) NSString *time;
/**
 *
 */
@property (nonatomic ,copy) NSString *userName;




@end
