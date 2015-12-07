//
//  ChangenfoConroller.h
//  ISQ
//
//  Created by mac on 15-4-2.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangenfoConroller : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(strong, nonatomic) NSArray *theUserChangeData;

- (IBAction)NikeNameSave_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *NikeNameSave_ol;
@property (weak, nonatomic) IBOutlet UITableView *changeMyInfoTableview;

- (IBAction)Change_back_bt:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *change_back_ol;

//-(instancetype)initWithFromMyCommunity:(NSArray*)myCommunity;

@end
