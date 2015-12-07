//
//  FourthWeController.h
//  ISQ
//
//  Created by mac on 15-6-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourthWeController : UIViewController
- (IBAction)back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *theTile;
@property (weak, nonatomic) IBOutlet UIWebView *fourthWebview;
-(instancetype)initWithThreeWebUrl:(NSString *)webUrl;
@end
