//
//  MessageMessageTableViewCell.h
//  ISQ
//
//  Created by mac on 15-3-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *Message_userName;

@end
