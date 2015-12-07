//
//  UserInfoController.h
//  ISQ
//
//  Created by mac on 15-4-2.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
- (IBAction)myInfoBack_bt:(id)sender;
@property (nonatomic, retain) UIViewController *superVC;
@property (weak, nonatomic) IBOutlet UITableView *InfoDetailTableview;
@property (strong,nonatomic) NSArray *myPalce;

- (void) snapImage;//拍照
- (void) pickImage;//从相册里找
- (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

@end
