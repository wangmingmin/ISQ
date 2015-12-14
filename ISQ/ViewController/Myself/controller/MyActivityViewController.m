//
//  MyActivityViewController.m
//  ISQ
//
//  Created by mac on 15-10-19.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MyActivityViewController.h"
#import "videoCell.h"
#import "ImageCell.h"
#import "HotVideoModel.h"
#import "imageCellModel.h"
#import "ISQCommonFunc.h"
#import "videoCell.h"
#import "ImageCell.h"
#import "HotVideoModel.h"
#import "imageCellModel.h"
#import "SRRefreshView.h"
#import "ActivityDetailImgController.h"
#import "VideoDetailController.h"
#import "MainViewController.h"

@interface MyActivityViewController (){

    UIView *chooseLine;
    BOOL isjoinActicity;

}

@end

@implementation MyActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"参加的活动";
    chooseLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40, UISCREENWIDTH/2-0.5f, 3)];
    chooseLine.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
    [self.selectView addSubview:chooseLine];
    
}



- (IBAction)segmentControl:(id)sender {
    NSInteger numIndexSelect = self.selectSegment.selectedSegmentIndex;
    
    
    switch (numIndexSelect) {
        case 0:
            self.joinLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            self.startLabel.textColor = [UIColor darkTextColor];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            chooseLine.transform = CGAffineTransformMakeTranslation(0, 0);
            [UIView commitAnimations];
            isjoinActicity = !isjoinActicity;
            
            self.joinedActivityView.hidden=NO;
            self.launchActivityView.hidden=YES;
            self.title=@"参加的活动";
            break;
            
        case 1:
            self.joinLabel.textColor = [UIColor darkTextColor];
            self.startLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            chooseLine.transform=CGAffineTransformMakeTranslation(UISCREENWIDTH/2-0.5f, 0);
            [UIView commitAnimations];
            isjoinActicity = !isjoinActicity;
            self.joinedActivityView.hidden=YES;
            self.launchActivityView.hidden=NO;
            self.title=@"发起的活动";
            break;
    }
}


@end


