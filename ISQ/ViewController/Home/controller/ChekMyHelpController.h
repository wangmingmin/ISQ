//
//  ChekMyHelpController.h
//  ISQ
//
//  Created by mac on 15-6-13.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChekMyHelpController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myHelpTableview;
- (IBAction)back_bt:(id)sender;
@property (strong ,nonatomic) NSArray *chekHelpData;

@end
