//
//  LocationSettingCell.h
//  ISQ
//
//  Created by mac on 15-4-8.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocationSettingCell : UITableViewCell

- (IBAction)message_notify_switch:(id)sender;
- (IBAction)theSound_switch:(id)sender;
- (IBAction)theShating_switch:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *message_notify_switch_ol;
@property (weak, nonatomic) IBOutlet UISwitch *theSound_switch_ol;
@property (weak, nonatomic) IBOutlet UISwitch *theShating_switch_ol;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
