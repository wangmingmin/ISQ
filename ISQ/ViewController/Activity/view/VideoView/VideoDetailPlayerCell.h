//
//  VideoDetailPlayerCell.h
//  ISQ
//
//  Created by Jun on 15/10/8.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDetailPlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityPlace;
@property (weak, nonatomic) IBOutlet UILabel *numberOfman;
@end
