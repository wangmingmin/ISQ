//
//  HomeViewController.h
//  ISQ
//
//  Created by mac on 15-3-12.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem+CustomItem.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *topCenterView;
- (IBAction)HomeSelectCity_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *HomeSelectCity_ol;
@property (weak, nonatomic) IBOutlet UITableView *tabelview;
@property (strong,nonatomic)  NSArray *homeADdata;
@property (strong ,nonatomic) NSArray *sdf;
@property (strong,nonatomic) CLLocation *cllocation;
@property (nonatomic,assign) float la;

- (void)setupUntreatedApplyCount;

@end
