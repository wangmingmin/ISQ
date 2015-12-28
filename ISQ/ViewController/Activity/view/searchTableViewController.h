//
//  searchTableViewController.h
//  ISQ
//
//  Created by 123 on 15/12/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^searchBarSearched) (NSString * type);

@interface searchTableViewController : UITableViewController
@property (strong, nonatomic) NSString * type;
@property (assign, nonatomic) BOOL isCurrentCity;
@property (assign, nonatomic) int pid;//非当前市时用到
@property (assign, nonatomic) int cid;//非当前市时用到
@property (copy, nonatomic) searchBarSearched searched;
@end
