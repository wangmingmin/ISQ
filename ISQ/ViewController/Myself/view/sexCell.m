//
//  sexCell.m
//  ISQ
//
//  Created by mac on 15-10-16.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "sexCell.h"

@implementation sexCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)segmentControl:(id)sender {
    NSInteger numIndexSelect = self.segmentControl.selectedSegmentIndex;
    switch (numIndexSelect) {
        case 0:
            self.manLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            self.womanLabel.textColor = [UIColor darkTextColor];
            
            break;
            
        case 1:
            self.manLabel.textColor = [UIColor darkTextColor];
            self.womanLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            
            break;
    }

}


@end
