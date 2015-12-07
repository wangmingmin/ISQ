//
//  Cell2ViewController.h
//  ISQ
//
//  Created by mac on 15-3-18.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell2ViewController : UIViewController
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSString *theData;
@end
