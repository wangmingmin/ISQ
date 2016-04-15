//
//  UserDetailViewController.m
//  ISQ
//
//  Created by none on 15/7/7.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserDetailTableViewCell.h"
#import "UserTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ChatViewController.h"
#import "MyFriendsModle.h"

@interface UserDetailViewController (){
    
    NSDictionary *myFrindsdata;
    UIView  *clickView;
    MyFriendsModle *modle;
    NSString *remarkStr;
}

@end

@implementation UserDetailViewController


-(instancetype)initWithFriendsData:(NSDictionary *)aDecoder{
        
    myFrindsdata=aDecoder;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户详情";
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 22)];
    [btn setBackgroundImage:[UIImage imageNamed:@"back_img"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 44, 44);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = item;

    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    [MobClick  beginLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - initView

- (void)initView{
    
    clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    clickView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [clickView addGestureRecognizer:tapGesture];
    [self.view addSubview:clickView];
    clickView.hidden = YES;

    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(UISCREENWIDTH/2-60, 37, 120, 120)];
    view.backgroundColor = [UIColor grayColor];
    [view.layer setCornerRadius:CGRectGetHeight([view bounds]) / 2];
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f].CGColor;
    
    
    modle=[MyFriendsModle objectWithKeyValues:myFrindsdata];
    
    remarkStr=[NSString stringWithFormat:@"%@",modle.remark.length>0 ?modle.remark:modle.nick];
    NSURL *imgUrl=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",modle.avatar]];
    
    [view setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    
    [self.view addSubview:view];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 210, UISCREENWIDTH-20, 100)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4f];
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backAction:(UIButton *)button{
     
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"userDetail";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:nil options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        
        cell.nickName.textColor = [UIColor darkTextColor];
        cell.nickName.text = @"备注名";
        cell.remarkTextField.delegate = self;
        [cell.remarkTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        cell.remarkTextField.text = [NSString stringWithFormat:@"%@",modle.remark.length>0 ?modle.remark:modle.nick];
        
    }else{
        static NSString *identify = @"detailCell";
        UserDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserDetailTableViewCell" owner:nil options:nil] lastObject];
            if (modle.remark) {
                
                cell.textLabel.text=@"你们已经是好友了";
                [cell.addButton_ol setTitle:@"发送消息" forState:UIControlStateNormal];
                [cell.addButton_ol addTarget:self action:@selector(toSendMessage:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                
                cell.textLabel.text=@"你们还不是好友";
                [cell.addButton_ol setTitle:@"加为好友" forState:UIControlStateNormal];
                
            }
            
        }
        
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

#pragma mark - taleViewCell分割线左对齐

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(5,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(5,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//聊天或发送邀请
-(void)toSendMessage:(UIButton*)btn{
    
    ChatViewController *chatController;
    
    chatController = [[ChatViewController alloc] initWithChatter:modle.hxid isGroup:NO];
    chatController.title =[NSString stringWithFormat:@"%@",modle.remark.length>0 ?modle.remark:modle.nick];
    
    [self.navigationController pushViewController:chatController animated:YES];
}

//保存备注
- (void)saveAction:(id)sender{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存本次编辑?" message:nil delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存",nil];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
    
       
        [self saveRemark];
        
    }
}


#pragma mark - 键盘通知

- (void)showKeyboard:(NSNotification *)notification{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    clickView.hidden = NO;
    if (width < 375) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        self.view.frame = CGRectMake(0, -30, UISCREENWIDTH, UISCREENHEIGHT);
        [UIView commitAnimations];
    }
}


- (void)hideKeyboard:(NSNotification *)notificaiton{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    clickView.hidden = YES;
    if (width < 375) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        self.view.frame = CGRectMake(0, 40, UISCREENWIDTH, UISCREENHEIGHT);
        [UIView commitAnimations];
    }
    
}

#pragma mark 保存备注
-(void)saveRemark{
    
    
    //判断是否有更改
    if ([remarkStr isEqualToString:[NSString stringWithFormat:@"%@",modle.remark]]) {
        
        return ;
        
    }else {
        
        [self showHudInView:self.view hint:@"正在处理..."];
        
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"ua"]=[NSString stringWithFormat:@"%@",[user_info objectForKey:userAccount]];
        dic[@"fa"]=[NSString stringWithFormat:@"%@",modle.hxid];
        dic[@"fc"]=[NSString stringWithFormat:@"%@",remarkStr];
        
        [ISQHttpTool getHttp:alertcomment contentType:@"text/plain" params:dic success:^(id rec) {
            
            NSDictionary *recDic=[NSJSONSerialization JSONObjectWithData:rec options:NSJapaneseEUCStringEncoding error:nil];
            
            if (recDic) {
                [self hideHud];
                [self showHint:@"修改成功"];
            }
            
        } failure:^(NSError *erro) {
            
            [self hideHud];
            [self showHint:@"修改失败,请等会儿..."];
            
        }];
        
    }
}

- (void)resignKeyboard:(UIGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
}


-(void)textFieldWithText:(UITextField *)textField {
    
    remarkStr =textField.text;
    
}

@end
