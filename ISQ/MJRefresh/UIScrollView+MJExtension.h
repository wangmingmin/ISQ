//
//  UIScrollView+Extension.h
//  MJRefreshExample
//
//
//  Created by mac on 15-1-21.
//  Copyright (c) 2015年 com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MJExtension)
@property (assign, nonatomic) CGFloat mj_contentInsetTop;
@property (assign, nonatomic) CGFloat mj_contentInsetBottom;
@property (assign, nonatomic) CGFloat mj_contentInsetLeft;
@property (assign, nonatomic) CGFloat mj_contentInsetRight;

@property (assign, nonatomic) CGFloat mj_contentOffsetX;
@property (assign, nonatomic) CGFloat mj_contentOffsetY;

@property (assign, nonatomic) CGFloat mj_contentSizeWidth;
@property (assign, nonatomic) CGFloat mj_contentSizeHeight;
@end
