//
//  TableViewCell.h
//  cellHeight
//
//  Created by 123 on 16/1/4.
//  Copyright © 2016年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewMeetingCell : UITableViewCell
@property (strong, nonatomic) NSArray <NSString *>* Lables;
@property (strong, nonatomic) NSString * titleMeeting;
@property (strong, nonatomic) UIImage * imageMeeting;
@property (assign, nonatomic) BOOL isInProgress;//必须赋值
@property (strong, nonatomic) NSDate * timeDate;
@property (assign, nonatomic) NSInteger howManyPeople;
@end
