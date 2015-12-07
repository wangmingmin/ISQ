//
//  AddNewAddress.h
//  ISQ
//
//  Created by mac on 15-4-3.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewAddress : UIViewController

@property(strong,nonatomic) NSArray *theInfo;
@property (weak, nonatomic) IBOutlet UIButton *SaveNewAddress_ol;
- (IBAction)SaveNewAddress_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *MyaddNewTableview;

@property (weak, nonatomic) IBOutlet UITextField *receiveName_ed;
@property (weak, nonatomic) IBOutlet UITextField *choosePlace_ed;

@property (weak, nonatomic) IBOutlet UITextField *receiveNumber_ed;
@property (weak, nonatomic) IBOutlet UITextField *detailAddress_ed;
@property (weak, nonatomic) IBOutlet UITextField *placeCode_ed;

- (IBAction)newadressBack_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *adress_view1;
@property (weak, nonatomic) IBOutlet UIView *adress_view2;
@property (weak, nonatomic) IBOutlet UIView *adress_view4;

@property (weak, nonatomic) IBOutlet UIView *adress_view5;

@property (weak, nonatomic) IBOutlet UIView *adress_view3;

-(instancetype)initWithAddressInfo:(NSArray *)addressInfo;





@end
