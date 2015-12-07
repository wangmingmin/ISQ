//
//  sexCell.h
//  ISQ
//
//  Created by mac on 15-10-16.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UILabel *manLabel;
@property (weak, nonatomic) IBOutlet UILabel *womanLabel;

- (IBAction)segmentControl:(id)sender;

@end
