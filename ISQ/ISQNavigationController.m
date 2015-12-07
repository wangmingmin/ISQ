//
//  Created by Mac_SSD on 15/10/12.
//  Copyright © 2015年 Mac_SSD. All rights reserved.
//

#import "ISQNavigationController.h"

@interface ISQNavigationController ()

@end

@implementation ISQNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

}


/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_img" highImageName:@"back_img" target:self action:@selector(back)];
        
    
    }
    [super pushViewController:viewController animated:animated];

    
    //title颜色，字体样式，字体大小
    [viewController.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"San Francisco" size:18.0],NSFontAttributeName,nil]];
    
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    
    [viewController.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

- (void)back
{
// 这里用的是self, 因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}


@end
