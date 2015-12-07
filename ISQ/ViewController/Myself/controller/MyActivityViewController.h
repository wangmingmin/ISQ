//
//  MyActivityViewController.h
//  ISQ
//
//  Created by mac on 15-10-19.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActivityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectSegment;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UIView *selectView;
- (IBAction)segmentControl:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *joinedActivityView;
@property (weak, nonatomic) IBOutlet UIView *launchActivityView;

@end
