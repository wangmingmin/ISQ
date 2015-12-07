//
//  GetVcard.h
//  ISQ
//
//  Created by mac on 15-5-22.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
@interface GetVcard : NSObject
#pragma mark 获取Vcard
-(NSMutableDictionary*)getPersonInfo;
//保存排序好的数组index
@property(nonatomic,retain)NSMutableArray*dataArray;
//数组里面保存每个获取Vcard（名片）
@property(nonatomic,retain)NSMutableArray*dataArrayDic;



-(NSString*)upperStr:(NSString*)str;
@end

