//
//  UIView+Extension.h
//


#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
+(UIView*)lineWidth:(CGFloat)width lineHeight:(CGFloat)height lineColor:(UIColor*)color lineX:(CGFloat)x lineY:(CGFloat)y;

@end
