//
//  StartActivityViewController.h
//  ISQ
//
//  Created by mac on 15-9-24.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"
#import "DoImagePickerController.h"
@interface StartActivityViewController : UIViewController<DoImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)UILabel *progressLabel;
@property (strong, nonatomic)NSArray *aIVs;
@property (strong, nonatomic)UIProgressView *progressView;

@end
