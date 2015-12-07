//
//  ActivityViewController.h
//  ISQ
//
//  Created by mac on 15-9-17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"
#import "BaseViewController.h"
@interface ActivityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DropDownChooseDataSource,DropDownChooseDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
- (IBAction)segmentController:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *hotContantView;
@property (weak, nonatomic) IBOutlet UIView *nearContantView;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topbgView;
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;
@property (weak, nonatomic) IBOutlet UITableView *nearTableView;


@end
