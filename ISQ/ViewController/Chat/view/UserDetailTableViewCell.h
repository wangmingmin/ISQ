//
//  UserDetailTableViewCell.h
//  ISQ
//
//  Created by none on 15/7/7.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabe;

- (IBAction)addButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addButton_ol;

@end
