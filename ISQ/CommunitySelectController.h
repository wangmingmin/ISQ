//
//  CommunitySelectController.h
//  ISQ
//
//  Created by mac on 15-4-25.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunitySelectController :UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *communityTableview;

- (IBAction)communitySelect_bt:(id)sender;

@end
