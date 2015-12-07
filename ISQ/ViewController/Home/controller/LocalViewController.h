//
//  LocalViewController.h
//  ISQ
//
//  Created by mac on 15-3-19.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *locationTopLable;
@property(strong,nonatomic) NSArray *formHomeData;
@property (weak, nonatomic) IBOutlet UITableView *shTableView;

@property (weak, nonatomic) IBOutlet UILabel *showAdress;
- (IBAction)LocalBack_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *LocalBack_ol;

- (IBAction)refreshLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refresh_sta;
@property (weak, nonatomic) IBOutlet UIButton *refresh_ol;
- (IBAction)jionInUs_bt:(id)sender;
-(instancetype)initWithMaintenance:(NSArray *)aDecoder;

@end
