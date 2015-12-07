//
//  MessageViewController.h
//  ISQ
//
//  Created by mac on 15-3-20.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mTop_bg;

@property (weak, nonatomic) IBOutlet UISegmentedControl *friends_group_ol;
- (IBAction)friends_group_bt:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *groupTableview;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UITableView *messageTableview;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UIView *friendsView;
@property (weak, nonatomic) IBOutlet UITableView *frindsTableview;
@property (weak, nonatomic) IBOutlet UIView *selectView;
//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//群组变化时，更新群组页面
- (void)reloadGroupView;

//好友个数变化时，重新获取数据
//- (void)reloadDataSource;

//添加好友的操作被触发
//- (void)addFriendAction;

//添加好友操作
- (IBAction)addFrends_bt:(id)sender;

- (IBAction)im_message_contec_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *im_message_contec_ol;
@property (weak, nonatomic) IBOutlet UILabel *message_lable;
@property (weak, nonatomic) IBOutlet UILabel *contec_lable;

@end
