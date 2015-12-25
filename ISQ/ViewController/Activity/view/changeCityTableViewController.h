//
//  changeCityTableViewController.h
//  ISQ
//
//  Created by 123 on 15/12/24.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeCityTableViewControllerDelegate <NSObject>

-(void) changeCityOkWithProvinceID:(int)pid andCityID:(int)cid;

@end

@interface changeCityTableViewController : UITableViewController
@property (weak, nonatomic) id<changeCityTableViewControllerDelegate> delegate;
@end
