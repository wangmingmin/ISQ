//
//  AddNewAddress.m
//  ISQ
//
//  Created by mac on 15-4-3.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "AddNewAddress.h"

@interface AddNewAddress ()

@end

@implementation AddNewAddress

@synthesize theInfo;
@synthesize SaveNewAddress_ol;
@synthesize receiveName_ed,receiveNumber_ed,choosePlace_ed,detailAddress_ed,placeCode_ed;
@synthesize adress_view1,adress_view2,adress_view3,adress_view4,adress_view5;

@synthesize MyaddNewTableview;

-(instancetype)initWithAddressInfo:(NSArray *)addressInfo{
    
    self.theInfo=addressInfo;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
    
    if ([[theInfo objectAtIndex:0] isEqualToString:@"编辑收货地址"]) {
        
      
        self.title=@"编辑";
        self.receiveName_ed.text=@"一叶帆影";
        self.choosePlace_ed.text=@"武汉 江岸区";
        self.receiveNumber_ed.text=@"800800";
        self.detailAddress_ed.text=@"百步亭花园路58号";
        self.placeCode_ed.text=@"3000";

       
    }
    else {
        self.title=@"添加";
       
        
    }
    
    //键盘隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.MyaddNewTableview addGestureRecognizer:tapGestureRecognizer];

    
    //给view话边框
    [self viewLine];
    
       }

-(void)viewLine{
    
    self.adress_view1.layer.borderWidth=0.5f;
    self.adress_view1.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    self.adress_view2.layer.borderWidth=0.5f;
    self.adress_view2.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    self.adress_view3.layer.borderWidth=0.5f;
    self.adress_view3.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    self.adress_view4.layer.borderWidth=0.5f;
    self.adress_view4.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    self.adress_view5.layer.borderWidth=0.5f;
    self.adress_view5.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;

}


//键盘隐藏

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.MyaddNewTableview endEditing:YES];
}

- (IBAction)SaveNewAddress_bt:(id)sender {
    
    
    if ([[theInfo objectAtIndex:0] isEqualToString:@"编辑收货地址"]) {
       
        
        
    }
    else {
        
        
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newadressBack_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
