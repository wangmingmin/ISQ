//
//  AddNeighborsController.h
//  ISQ
//
//  Created by mac on 15-5-14.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNeighborsController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *AddNeighborsTableview;
@property (strong, nonatomic) IBOutlet UIView *dfdf;

@end
