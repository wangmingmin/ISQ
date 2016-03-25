//
//  CitySelectController.h
//  ISQ
//
//  Created by mac on 15-4-25.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceSelectController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *cityTableview;

@property (nonatomic, strong) NSMutableArray *cities;
- (IBAction)citySelect_bt:(id)sender;

@end
