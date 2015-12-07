//
//  SeconWebController.h
//  ISQ
//
//  Created by mac on 15-6-21.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SeconWebController : UIViewController

- (IBAction)back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *back_ol;
@property (weak, nonatomic) IBOutlet UILabel *theTitle;
@property (weak, nonatomic) IBOutlet UIWebView *seconWebView;
@property (nonatomic,copy) NSString*theUrl;

@end
