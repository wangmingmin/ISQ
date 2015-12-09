//
//  VideoDetailController_forSpring.h
//  ISQ
//
//  Created by 123 on 15/12/9.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//  当前类专用与春晚展播节目的展示

#import <UIKit/UIKit.h>
#import "DWLog.h"
#import "DWMoviePlayerController.h"

@interface VideoDetailController_forSpring : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic)NSString *videoId;
@property (strong ,nonatomic) NSString *activeID;
@property (copy, nonatomic)NSString *videoLocalPath;
@property (strong,nonatomic) NSDictionary *httpData;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)collectAction:(id)sender;
- (IBAction)voteAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end
