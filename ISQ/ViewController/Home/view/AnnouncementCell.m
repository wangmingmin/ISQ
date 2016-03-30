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
#import "zhanBoViewController.h"
#import "ISQHttpTool.h"

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
    self.scrollView.contentSize = CGSizeMake(UISCREENWIDTH * self.announcements.count, UISCREENWIDTH*0.50133333);
    self.pageControl.numberOfPages = self.announcements.count;
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
//    NSString *userID = [userInfo objectForKey:MyUserID];
    NSDictionary *dic = [self.announcements objectAtIndex:button.tag];
     AnnouncementModel *announcement = [[AnnouncementModel alloc] initWithDataDic:dic];
    if ([[dic objectForKey:@"titleUrl"] isEqualToString:@"springVideoShow"]) {

        zhanBoViewController * zhanBoView = [storyboard instantiateViewControllerWithIdentifier:@"zhanBoViewController"];
        [[self viewController].navigationController pushViewController:zhanBoView animated:YES];
        
    }else if([[dic objectForKey:@"titleUrl"] isEqualToString:@"SpringPositiveVideo"]){
        NSString * httpUrl = getPositiveSpringVideo;
        [ISQHttpTool getHttp:httpUrl contentType:nil params:nil success:^(id res) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
            [self.delegate showSpringPositiveVideoWithDic:dic];
        } failure:^(NSError *erro) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"访问有误，稍后请重试哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];

    }else{
        
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
        self.timer = [NSTimer scheduledTimerWithTimeInterval:7
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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
