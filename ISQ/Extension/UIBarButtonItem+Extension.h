//
//  UIBarButtonItem+Extension.h


#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemName:(NSString *)theName target:(id)target action:(SEL)action;
@end
