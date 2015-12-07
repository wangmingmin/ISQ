//
//  addMakeController.h
//  ISQ
//
//  Created by mac on 15-5-3.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addMakeController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *addTableview;


@end
