//
//  MyselfViewController.h
//  ISQ
//
//  Created by mac on 15-3-27.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyselfViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theTableview;


@end
