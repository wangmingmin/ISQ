//
//  PersonalDataViewController.h
//  ISQ
//
//  Created by mac on 15-10-6.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalDataViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *userdataTabelView;
- (IBAction)backButton:(id)sender;

@end
