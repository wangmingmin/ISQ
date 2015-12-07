//
//  LaunchActivityController.h
//  ISQ
//
//  Created by Mac_SSD on 15/12/4.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchActivityController : UIViewController<UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
