//
//  FindFriendsController.h
//  ISQ
//
//  Created by mac on 15-5-15.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindFriendsController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *findFriendsTableview;

@end
