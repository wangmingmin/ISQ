//
//  hotCell.h
//  ISQ
//
//  Created by mac on 15-11-16.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hotCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *hotimage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end
