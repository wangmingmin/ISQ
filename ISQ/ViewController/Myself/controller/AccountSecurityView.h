//
//  AccountSecurityView.h
//  ISQ
//
//  Created by mac on 15-4-8.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSecurityView : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)accountSecurity_back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *securityTableview;

@end
