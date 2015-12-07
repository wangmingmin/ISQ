//
//  NeighborsTableCell.h
//  ISQ
//
//  Created by mac on 15-5-14.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeighborsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *friendsImg;

@property (weak, nonatomic) IBOutlet UILabel *addFriendsLable;

@property (weak, nonatomic) IBOutlet UILabel *theName;
@property (weak, nonatomic) IBOutlet UIImageView *theImg;
@property (weak, nonatomic) IBOutlet UIButton *add_ol;
- (IBAction)add_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *communityName;

@property(strong ,nonatomic) NSDictionary *dataSource;
@property (strong,nonatomic) NSString *myAcount;
@property (weak, nonatomic) IBOutlet UILabel *neigborsName;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAdd;

@end
