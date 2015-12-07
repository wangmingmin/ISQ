//
//  UserInfoCell.h
//  ISQ
//
//  Created by mac on 15-4-2.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ClickImage *userInfoImg;
@property (weak, nonatomic) IBOutlet UILabel *myPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *userIsqCodelable;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhoto;



@end
