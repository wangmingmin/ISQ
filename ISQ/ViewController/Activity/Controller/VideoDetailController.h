//
//  VideoDetailController.h
//  ISQ
//
//  Created by Jun on 15/10/8.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWLog.h"
#import "DWMoviePlayerController.h"

@interface VideoDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic)NSString *videoId;
@property (strong ,nonatomic) NSString *activeID;
@property (copy, nonatomic)NSString *videoLocalPath;
@property (strong,nonatomic) NSDictionary *httpData;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)addAction:(id)sender;
- (IBAction)praiseAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end
