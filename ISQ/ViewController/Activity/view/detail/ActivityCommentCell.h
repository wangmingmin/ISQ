//
//  ActivityCommentCell.h
//  ISQ
//
//  Created by Mac_SSD on 15/10/16.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCommentCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *headImg;
@property (nonatomic ,strong) UILabel *ownName;
@property (nonatomic ,strong) UILabel *otherName;
@property (nonatomic ,strong) UILabel *replyLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic , strong)UIButton *sendButton;

@property (nonatomic ,strong) NSDictionary *arryList;
+(instancetype)cellWithTableView:(UITableView*)tableView;
@end
