//
//  FriendsTableViewCell.h
//  ISQ
//
//  Created by mac on 15-3-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

@interface FriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myFriendName_lable;
@property (weak, nonatomic) IBOutlet ClickImage *myFriendsImg;
@property (weak, nonatomic) IBOutlet UIButton *callBt_ol;
@property (weak, nonatomic) IBOutlet UIButton *toChat_ol;



@end
