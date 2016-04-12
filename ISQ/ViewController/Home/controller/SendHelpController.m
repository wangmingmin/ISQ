//
//  SendHelpController.m
//  ISQ
//
//  Created by mac on 15-5-4.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "SendHelpController.h"
#import "LocalTableViewCell.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ActionSheetStringPicker.h"
@interface SendHelpController ()<UITextFieldDelegate>{
    
    LocalTableViewCell *cell;
    NSUserDefaults *userInfos;
    AppDelegate *sendHelpDelegate;
    MBProgressHUD *HUD;
    NSString *myName;
    NSString *myAdress;
    NSString *myPhone;
    UIButton *sortbutton;
    NSArray *listArray;
    NSMutableArray *juweihuiListArray;
    NSMutableArray *contactNameListArray;
    NSMutableArray *contactPhoneListArray;
}

@property (nonatomic, assign) NSInteger selectedSortType;

@end

@implementation SendHelpController
@synthesize sendHelpTableview,sendHelp_constraint;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedSortType = 0;
    listArray = [[NSArray alloc] init];
    juweihuiListArray = [[NSMutableArray alloc] init];
    contactNameListArray = [[NSMutableArray alloc] init];
    contactPhoneListArray = [[NSMutableArray alloc] init];
    sendHelpDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    userInfos=[NSUserDefaults standardUserDefaults];
    //键盘隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.sendHelpTableview addGestureRecognizer:tapGestureRecognizer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [self loadGetJuweihuiListData];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


//如果是百步亭社区，获取对应居委会数据
- (void)loadGetJuweihuiListData{

    [ISQHttpTool getHttp:getJuweihuiList contentType:nil params:nil success:^(id reponseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:reponseObject options:NSJapaneseEUCStringEncoding error:nil];
        listArray = [NSArray arrayWithArray:dic[@"retData"]];
        for (NSDictionary *dic in listArray) {
            [juweihuiListArray addObject:dic[@"title"]];
            [contactNameListArray addObject:dic[@"contact"]];
            [contactPhoneListArray addObject:dic[@"contact_phone"]];
        }

        [self.sendHelpTableview reloadData];
        
    } failure:^(NSError *erro) {
        
    }];
    
}


//键盘隐藏

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.sendHelpTableview endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 7;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==3) {
        return 10;
    }else if(indexPath.row==6 ){
        
        
        return 230;
    }
    
    return 45;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0||indexPath.row==1||indexPath.row==2||indexPath.row == 5) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"sendHelpCell1" forIndexPath:indexPath];
        cell.sendHelp_ed.tag=indexPath.row;
        if (indexPath.row==0) {
            cell.sendHelplable1.text=@"我的姓名";
            if ([userInfos objectForKey:userNickname]) {
                cell.sendHelp_ed.text=[userInfos objectForKey:userNickname];
            }
            
        }else if(indexPath.row==1){
            cell.sendHelplable1.text=@"联系方式";
            if ([userInfos objectForKey:userAccount]) {
                cell.sendHelp_ed.text=[userInfos objectForKey:userAccount];
                cell.sendHelp_ed.keyboardType=UIKeyboardTypeNumberPad;
            }
            
        }else if(indexPath.row==2){
            cell.sendHelplable1.text=@"详细地址";
            cell.sendHelp_ed.placeholder=@"您的详细地址";
            if (sendHelpDelegate.theAddress) {
                cell.sendHelp_ed.text=sendHelpDelegate.theAddress;
            }
        }else if (indexPath.row == 5){
            cell.sendHelplable1.text=@"受理人";
            

            NSString *str2 = @"百步亭";
            if ([self.communityName hasPrefix:str2]) {
                if (contactNameListArray.count > 0) {
                    
                    cell.sendHelp_ed.text = contactNameListArray[self.selectedSortType];

                }
                
            }else{
                cell.sendHelp_ed.text=@"社区书记";
                cell.sendHelp_ed.userInteractionEnabled=NO;
            }
        }
        cell.sendHelp_ed.delegate=self;
        [cell.sendHelp_ed addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [self textFieldWithText:cell.sendHelp_ed];
        
    }else if(indexPath.row==4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"sendHelpCell4" forIndexPath:indexPath];
        cell.sendHelplable1.text=@"居委会";
        NSString *str2 = @"百步亭";
        sortbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        [sortbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.chooseButton addSubview:sortbutton];
        if ([self.communityName hasPrefix:str2]) {
            if (juweihuiListArray.count >0) {
                [sortbutton setTitle:juweihuiListArray[self.selectedSortType] forState:UIControlStateNormal];
                [sortbutton setBackgroundImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
                [sortbutton addTarget:self action:@selector(sortSelectButton:) forControlEvents:UIControlEventTouchUpInside];
            }
           
        }else{
            cell.sendHelp_ed.placeholder=@"居委会";
            
            [sortbutton setTitle:@"社区居委会" forState:UIControlStateNormal];
        }
    }else if (indexPath.row==3){
        cell=[tableView dequeueReusableCellWithIdentifier:@"sendHelpCell2" forIndexPath:indexPath];
        
        
    }else if(indexPath.row==6){
        cell=[tableView dequeueReusableCellWithIdentifier:@"sendHelpCell3" forIndexPath:indexPath];
        
        
    }
    if (indexPath.row==0||indexPath.row==2||indexPath.row==4) {
        cell.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
        cell.layer.borderWidth=0.5f;
    }
    
    return cell;
}

//百步亭社区居委会选择
- (void)sortSelectButton:(UIButton *)button{
    [ActionSheetStringPicker showPickerWithTitle:@"请选择居委会"
                                            rows:juweihuiListArray
                                initialSelection:self.selectedSortType
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [sortbutton setTitle:selectedValue forState:UIControlStateNormal];
                                           self.selectedSortType = selectedIndex;
                                           [self.sendHelpTableview reloadData];
                                           
                                       } cancelBlock:nil
                                          origin:self.view];
    
}

//键盘挡住输入框的优化
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    if (notification.name == UIKeyboardWillShowNotification) {
        self.sendHelp_constraint.constant = keyboardEndFrame.size.height+2;
    }else{
        self.sendHelp_constraint.constant = 0;
    }
}



- (IBAction)back_bt:(id)sender {
    
    [self.sendHelpTableview endEditing:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            myName=textField.text;
            break;
        case 1:
            myPhone=textField.text;
            break;
        case 2:
            myAdress=textField.text;
            break;
    }
}


#pragma mark - postdata

-(void)sendHelpDetail{
    
    NSDictionary *arry=@{@"phone":[NSString stringWithFormat:@"%@",myPhone],
                         @"cid":[userInfos objectForKey:userCommunityID],
                         @"title":@"",
                         @"content":cell.sendHelplableDetail_tv.text,
                         @"address":[NSString stringWithFormat:@"%@",myAdress],
                         @"name":[NSString stringWithFormat:@"%@",myName],
                         @"secretaryPhone":contactPhoneListArray[self.selectedSortType],
                         
                         };
    
        [ISQHttpTool getHttp:MESSAGEURL contentType:nil params:arry success:^(id responseObject) {
        
        NSString *codeNumber =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([codeNumber isEqualToString:@"1"]) {
            
            [self showHint:@"信件已发送成功"];
            
        }else {
            
            [self showHint:@"信件发送失败，请重发"];
        }

    } failure:^(NSError *erro) {
        
        [self warning2:@"信件发送失败，请检查网络"];
    }];
}


- (IBAction)sendHelp_bt:(id)sender {
    
    
    if (myName.length<=0) {
        
        [self warning2:@"姓名不能为空！"];
        
    }else if (myPhone.length!=11){
        
        [self warning2:@"手机号码格式错误！"];
    }else if (myAdress.length<=0){
        
        [self warning2:@"地址不能为空！"];
    }else if (cell.sendHelplableDetail_tv.text.length<=0){
        
        [self warning2:@"内容不能为空！"];
    }else{
        [self sendHelpDetail];
        
    }
}

-(void)warning2:(NSString *)warString2{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode=MBProgressHUDModeText;
    
    HUD.labelText =[NSString stringWithFormat:@"%@",warString2];
    HUD.margin = 8.f;
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:5.0f];
}

@end
