//
//  AnnouncementCell.m
//  ISQ
//
//  Created by none on 15/7/17.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "AnnouncementCell.h"
#import "AnnouncementModel.h"
#import "UIButton+AFNetworking.h"
#import "SeconWebController.h"


@implementation AnnouncementCell
- (void)setAnnouncements:(NSArray *)announcements{
    if (_announcements != announcements) {
        _announcements = announcements;
    }
    [self setupCell];
}

- (void)setupCell{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.contentSize = CGSizeMake(UISCREENWIDTH * 4, UISCREENWIDTH*0.50133333);
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    for (int i = 0; i<self.announcements.count; i++) {
        NSDictionary *dic = [self.announcements objectAtIndex:i];
        AnnouncementModel *announcement = [[AnnouncementModel alloc] initWithDataDic:dic];
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(UISCREENWIDTH * i, 0, UISCREENWIDTH, UISCREENWIDTH*0.50133333);
        imageButton.tag = i;
        [imageButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:announcement.image] placeholderImage:nil];
        
        [imageButton addTarget:self action:@selector(announcementClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:imageButton];
    }
    
    [self addTimer];
}

- (void)announcementClicked:(UIButton *)button {
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userInfo objectForKey:MyUserID];
    NSDictionary *dic = [self.announcements objectAtIndex:button.tag];
     AnnouncementModel *announcement = [[AnnouncementModel alloc] initWithDataDic:dic];
    if ([[dic objectForKey:@"titleUrl"] isEqualToString:@"SPRING_NIGHT"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SeconWebController *webVC = [storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
        NSString *url = [NSString stringWithFormat:@"%@%@",@"http://webapp.wisq.cn/Spring/index/uid/",userID];
        webVC.theUrl = url;
        [webVC setHidesBottomBarWhenPushed:YES];
        [[self viewController].navigationController pushViewController:webVC animated:YES];
        
    }else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SeconWebController *webVC = [storyboard instantiateViewControllerWithIdentifier:@"SeconWebController"];
        webVC.theUrl = announcement.titleUrl;
        [webVC setHidesBottomBarWhenPushed:YES];
        [[self viewController].navigationController pushViewController:webVC animated:YES];
    }
}


- (UIViewController *)viewController {
    id vc = [self nextResponder];
    while (vc) {
        if ([vc isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)vc;
        }
        vc = [vc nextResponder];
    }
    return nil;
}

- (void)addTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                      target:self
                                                    selector:@selector(handleSchedule)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)handleSchedule {
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    int page = self.scrollView.contentOffset.x / screenWidth;
    if (page == self.announcements.count-1) {
        page = 0;
    }
    else {
        page++;
    }
    
    [UIView animateWithDuration:1 animations:^{
        [self.scrollView setContentOffset:CGPointMake(page * screenWidth, 0) animated:YES];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewWidth =  CGRectGetWidth(scrollView.frame);
    int page = (scrollView.contentOffset.x + scrollViewWidth / 2) /  scrollViewWidth;
    self.pageControl.currentPage = page;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
