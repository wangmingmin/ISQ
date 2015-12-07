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

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)setLeftBackButton {
    UIImage *image = [UIImage imageNamed:@"go_back"];
    UIImage *highlightedImage = [UIImage imageNamed:@"go_back_selected"];
    self.leftButton = [self createButtonWithImage:image highlightedImage:highlightedImage action:@selector(goBack)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    UIBarButtonItem *negativeSpacer = [self createNegativeSpacer];
    UIViewController *viewController = [self nearestNavigationChildViewController];
    [viewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, leftItem]];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLeftBarButtonWithImage:(UIImage *)image action:(SEL)selector {
    self.leftButton = [self createButtonWithImage:image highlightedImage:nil action:selector];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    UIBarButtonItem *negativeSpacer = [self createNegativeSpacer];
    UIViewController *viewController = [self nearestNavigationChildViewController];
    [viewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, leftItem]];
}

- (void)setRightBarButtonWithImage:(UIImage *)image action:(SEL)selector {
    self.rightButton = [self createButtonWithImage:image highlightedImage:nil action:selector];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    UIBarButtonItem *negativeSpacer = [self createNegativeSpacer];;
    UIViewController *viewController = [self nearestNavigationChildViewController];
    [viewController.navigationItem setRightBarButtonItems:@[negativeSpacer, rightItem]];
}

- (void)SetLeftBarButtonVisible:(BOOL)visible {
    self.leftButton.hidden = !visible;
}

- (void)SetRightBarButtonVisible:(BOOL)visible {
    self.rightButton.hidden = !visible;
}

- (void)setTitle:(NSString *)title {
    if (![super.title isEqualToString:title]) {
        super.title = title;
        UIViewController *viewController = [self nearestNavigationChildViewController];
        viewController.title = title;
    }
}

- (void)setTitleView:(UIView *)view {
    UIViewController *viewController = [self nearestNavigationChildViewController];
    viewController.navigationItem.titleView = view;
}

- (UIView *)titleView {
    UIViewController *viewController = [self nearestNavigationChildViewController];
    return viewController.navigationItem.titleView;
}

- (UIButton *)createButtonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage action:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:image forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIBarButtonItem *)createNegativeSpacer {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
    return negativeSpacer;
}

- (UIViewController *)nearestNavigationChildViewController {
    UIViewController *currentViewController = self;
    while (currentViewController.parentViewController) {
        if ([currentViewController.parentViewController isKindOfClass:[UINavigationController class]]) {
            return currentViewController;
        }
        currentViewController = currentViewController.parentViewController;
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
