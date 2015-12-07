//
//  UserDetailViewController.h
//  ISQ
//
//  Created by none on 15/7/7.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) UITableView *tableView;

-(instancetype)initWithFriendsData:(NSDictionary *)aDecoder;

@end
