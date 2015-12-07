//
//  ActivityDetailImgController.h
//  ISQ
//
//  Created by Mac_SSD on 15/11/22.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailImgController : UIViewController<UITableViewDataSource ,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *activityDetailImgTableView;
@property (strong,nonatomic) NSDictionary *httpData;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)addAction:(id)sender;
- (IBAction)praiseAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end
