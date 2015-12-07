//
//  UIBarButtonItem+Extension.m


#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithName:highImageName] forState:UIControlStateHighlighted];
    
   /* // 设置按钮的尺寸为背景图片的尺寸
    button.size = button.currentBackgroundImage.size;*/
    
    button.width=14;
    button.height=23;
    
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+(UIBarButtonItem *)itemName:(NSString *)theName target:(id)target action:(SEL)action{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:theName forState:UIControlStateNormal];
    
    button.width=60;
    button.height=30;
    
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
@end
