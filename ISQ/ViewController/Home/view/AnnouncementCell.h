//
//  AnnouncementCell.h
//  ISQ
//
//  Created by none on 15/7/17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementCell : UITableViewCell<UIScrollViewDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *announcements;
@property (nonatomic,strong) NSTimer *timer;
@end
