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
@protocol VideoDetailController_forSpringDelegate <NSObject>

-(void)VideoDetailController_forSpringIsFinshedRefresh;//投票刷新
-(void)VideoDetailController_forSpringIsFinshedFollow;//关注刷新
-(void)VideoDetailController_forSpringRefreshViewNum;//专场浏览数刷新
@end

@interface VideoDetailController_forSpring : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic)NSString *videoId;
@property (strong ,nonatomic) NSString *activeID;
@property (copy, nonatomic)NSString *videoLocalPath;
@property (strong,nonatomic) NSDictionary *httpData;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (assign, nonatomic) BOOL isSpecial;
@property (weak, nonatomic) id <VideoDetailController_forSpringDelegate>delegate;
- (IBAction)collectAction:(id)sender;
- (IBAction)voteAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end
