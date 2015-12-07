//
//  SecondWebViewController.h
//  ISQ
//
//  Created by mac on 15-6-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownSheet.h"
@interface ThreeWebController : UIViewController<DownSheetDelegate>{
    
    NSArray *MenuList;
}
- (IBAction)back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *back_ol;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIWebView *secondWebView;
-(instancetype)initWithSecondWebUrl:(NSString *)webUrl;

- (IBAction)myRoom_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *myRoom_ol;

@end
