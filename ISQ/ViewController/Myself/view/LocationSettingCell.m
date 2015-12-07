//
//  LocationSettingCell.m
//  ISQ
//
//  Created by mac on 15-4-8.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "LocationSettingCell.h"

@implementation LocationSettingCell

NSUserDefaults *saveSetting;

- (void)awakeFromNib {

    //设置页中的switch开关状态
    [self switchBtStatic];
    //轻量数据存储(排名)
    saveSetting=[NSUserDefaults standardUserDefaults];
    self.exitButton.layer.masksToBounds = YES;
    self.exitButton.layer.cornerRadius = 10;
    self.exitButton.highlighted = YES;
}


-(void)switchBtStatic{
    
    //判断开关的状态并显示应有的状态
    if ([[saveSetting objectForKey:notify_switch] isEqualToString:@"NO"]) {
        
        self.message_notify_switch_ol.on=NO;
        
    }else{
        
        self.message_notify_switch_ol.on=YES;
        
    }
    if ([[saveSetting objectForKey:Sound_switch] isEqualToString:@"NO"]) {
        self.theSound_switch_ol.on=NO;
        
    }else{
        
        self.theSound_switch_ol.on=YES;
        
    }
    if ([[saveSetting objectForKey:Shating_switch] isEqualToString:@"NO"]) {
        self.theShating_switch_ol.on=NO;
        
    }else{
        
        self.theShating_switch_ol.on=YES;
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)message_notify_switch:(id)sender {
    
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    if (self.message_notify_switch_ol.on) {
        
       [saveSetting setValue:@"YES" forKey:notify_switch];
        options.displayStyle=0;
        
    }
    else{
        options.displayStyle=1;
        [saveSetting setValue:@"NO" forKey:notify_switch];
    }

}


- (IBAction)theSound_switch:(id)sender {
   
    if (self.theSound_switch_ol.on) {
        
        [saveSetting setValue:@"YES" forKey:Sound_switch];
    }
    else{
        
        [saveSetting setValue:@"NO" forKey:Sound_switch];
    }
    
}

- (IBAction)theShating_switch:(id)sender {
    
    if (self.theShating_switch_ol.on) {
        
        [saveSetting setValue:@"YES" forKey:Shating_switch];
    }
    else{
        
        [saveSetting setValue:@"NO" forKey:Shating_switch];
    }
    
}

@end
