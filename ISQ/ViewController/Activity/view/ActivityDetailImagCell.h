//
//  ActivityDetailImagCell.h
//  ISQ
//
//  Created by Mac_SSD on 15/11/22.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailImagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityPlace;
@property (weak, nonatomic) IBOutlet UILabel *numberOfman;


@end
