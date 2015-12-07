//
//  SendHelpController.h
//  ISQ
//
//  Created by mac on 15-5-4.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendHelpController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)back_bt:(id)sender;
- (IBAction)sendHelp_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *sendHelpTableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendHelp_constraint;
@property (copy,nonatomic) NSString *communityName;

@end
