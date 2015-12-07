/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setLeftBackButton;
- (void)setLeftBarButtonWithImage:(UIImage *)image action:(SEL)selector;
- (void)setRightBarButtonWithImage:(UIImage *)image action:(SEL)selector;

- (void)SetLeftBarButtonVisible:(BOOL)visible;
- (void)SetRightBarButtonVisible:(BOOL)visible;

@property (nonatomic, strong) UIView *titleView;

@end
