//
//  MySettingView.h
//  ISQ
//
//  Created by mac on 15-4-8.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
- (IBAction)SettingBack_bt:(id)sender;

@end
