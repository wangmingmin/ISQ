//
//  CitySelectController.h
//  ISQ
//
//  Created by xindongni on 16/3/23.
//  Copyright © 2016年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *citySelectTableview;
@property (strong,nonatomic) NSString *provinceid;

- (IBAction)backButton:(id)sender;

@end
