//
//  UIColor+Extension.h
//  testLine
//
//  Created by Mac_SSD on 15/10/12.
//  Copyright © 2015年 Mac_SSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Extension)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert alpha:(CGFloat)alphaValue;


@end
