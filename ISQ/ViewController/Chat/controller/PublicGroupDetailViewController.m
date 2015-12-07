/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "PublicGroupDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CmdDealWith.h"
#import "ImgURLisFount.h"
@interface PublicGroupDetailViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) EMGroup *group;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *footerButton;
@property (strong ,nonatomic) NSString *owanName;
@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation PublicGroupDetailViewController

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _groupId = groupId;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 23)];
    [backButton setImage:[UIImage imageNamed:@"back_img"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self fetchGroupInfo];
    
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - getter

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 130)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        
        
        
//        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, _headerView.frame.size.width - 80 - 20, 30)];
//        _nameLabel.backgroundColor = [UIColor whiteColor];
//        _nameLabel.text = (_group.groupSubject && _group.groupSubject.length) > 0 ? _group.groupSubject : _group.groupId;
//        [_headerView addSubview:_nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height - 0.5, _headerView.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headerView addSubview:line];
        
        
    }
    
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 80)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
        
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, _footerView.frame.size.width - 80, 40)];
        [_footerButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
        _footerButton.enabled = NO;
        [_footerView addSubview:_footerButton];
    }
    
    

    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"group.owner", @"Owner");
        
        
        _owanName=_group.owner;
        
        
        
        
        NSDictionary *arry=@{@"friend":[NSString stringWithFormat:@"%@",_group.owner]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:SEARCHFRIENDSURL parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *Frindsdata=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
            
            if ([Frindsdata[@"code"] intValue]==0) {
                
                _owanName = Frindsdata[@"data"][@"nick"];
                
                //                    [self.tableView reloadData];
                
                
                cell.detailTextLabel.text = _owanName;
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            
        }];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(UISCREENWIDTH/2-45, 20, 90, 90)];
        imageView.layer.cornerRadius=45;
        imageView.layer.masksToBounds=YES;
        imageView.layer.borderWidth=0.3f;
        imageView.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
        
        NSString *imageName = [NSString stringWithFormat:@"%@%@.png",IMGROUPIMG,_group.groupId];
    
        NSURL *imgUrl=[[NSURL alloc]initWithString:imageName];
        [imageView  setImageWithURL:imgUrl];
        
        if ([ImgURLisFount TheDataIsImgage:imageView.image]==2) {
            
            
        }else{
            
            imageView.image=[UIImage imageNamed:@"defuleImg"];
            
        }
        
        [_headerView addSubview:imageView];
        cell.detailTextLabel.text = _owanName;
        
    }
    else{
        cell.textLabel.text = NSLocalizedString(@"group.describe", @"Describe");
        cell.detailTextLabel.text = _group.groupDescription;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }
    else{
        CGSize size = [_group.groupDescription sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(220, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        
        return size.height > 30 ? (20 + size.height) : 50;
    }
}

//#pragma mark - alertView delegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([alertView cancelButtonIndex] != buttonIndex) {
//        UITextField *messageTextField = [alertView textFieldAtIndex:0];
//        
//        NSString *messageStr = @"";
//        if (messageTextField.text.length > 0) {
//            messageStr = messageTextField.text;
//        }
//        [self applyJoinGroup:_groupId withGroupname:_group.groupSubject message:messageStr];
//    }
//}

#pragma mark - action

- (BOOL)isJoined:(EMGroup *)group
{
    if (group) {
        NSArray *groupList = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *tmpGroup in groupList) {
            if (tmpGroup.isPublic == group.isPublic && [group.groupId isEqualToString:tmpGroup.groupId]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)fetchGroupInfo
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_groupId completion:^(EMGroup *group, EMError *error) {
        weakSelf.group = group;
        [weakSelf reloadSubviewsInfo];
        [weakSelf hideHud];
    } onQueue:nil];
}

- (void)reloadSubviewsInfo
{
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.nameLabel.text = (weakSelf.group.groupSubject && weakSelf.group.groupSubject.length) > 0 ? weakSelf.group.groupSubject : weakSelf.group.groupId;
        if ([weakSelf isJoined:weakSelf.group]) {
            weakSelf.footerButton.enabled = NO;
            [weakSelf.footerButton setTitle:NSLocalizedString(@"group.joined", @"joined") forState:UIControlStateNormal | UIControlStateDisabled];
        }
        else{
            weakSelf.footerButton.enabled = YES;
            [weakSelf.footerButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        }
        [weakSelf.tableView reloadData];
    });
}

//- (void)showMessageAlertView
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"saySomething", @"say somthing") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
//    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    [alert show];
//}

- (void)joinAction
{
    if (self.group.groupSetting.groupStyle == eGroupStyle_PublicJoinNeedApproval) {
        
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你好，已经成功发送加群请求！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alre show];
        
        //申请加入群组
       [CmdDealWith cmdToDealWithGroup:CMD_ACTION_NOTICE_GROUP_REQUEST :@{@"groupId":self.groupId,@"groupName":(_group.groupSubject && _group.groupSubject.length) > 0 ? _group.groupSubject : _group.groupId} :_group.owner];
        
        
        
        
        
//        [self showMessageAlertView];
    }
    else if (self.group.groupSetting.groupStyle == eGroupStyle_PublicOpenJoin)
    {
        
        
        
        [self joinGroup:_groupId];
    
    }
}

- (void)joinGroup:(NSString *)groupId
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.join.ongoing", @"join the group...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncJoinPublicGroup:groupId completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if(!error)
        {
            
            [CmdDealWith cmdToDealWithGroup:CMD_ACTION_NOTICE_GROUP_JOIN :@{@"groupId":self.groupId,@"groupName":(_group.groupSubject && _group.groupSubject.length) > 0 ? _group.groupSubject : _group.groupId} :_group.owner];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [weakSelf showHint:NSLocalizedString(@"group.join.fail", @"again failed to join the group, please")];
        }
    } onQueue:nil];
}

- (void)applyJoinGroup:(NSString *)groupId withGroupname:(NSString *)groupName message:(NSString *)message
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.sendingApply", @"send group of application...")];
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:groupId withGroupname:groupName message:message completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            [weakSelf showHint:NSLocalizedString(@"group.sendApplyRepeat", @"application has been sent")];
        }
        else{
            [weakSelf showHint:error.description];
        }
    } onQueue:nil];
}

@end
