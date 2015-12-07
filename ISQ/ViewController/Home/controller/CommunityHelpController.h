//
//  CommunityHelpController.h
//  ISQ
//
//  Created by mac on 15-3-28.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityHelpController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *ComHelpView;
@property (weak, nonatomic) IBOutlet UIView *ComMyView;

@property (weak, nonatomic) IBOutlet UIView *selectView;

- (IBAction)CommunityBack_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *helpCommunity_ed;
@property (weak, nonatomic) IBOutlet UILabel *helpAdressEd;
@property (weak, nonatomic) IBOutlet UITableView *myMessageTableview;

- (IBAction)selectMy_Help_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectMy_Help_ol;
@property (copy,nonatomic) NSString *communityName;


@end
