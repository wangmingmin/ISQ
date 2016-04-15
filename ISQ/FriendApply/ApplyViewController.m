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

#import "ApplyViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ApplyFriendCell.h"
#import "InvitationManager.h"
#import "CmdDealWith.h"

static ApplyViewController *controller = nil;

@interface ApplyViewController ()<ApplyFriendCellDelegate>{
    
    NSMutableArray *friendsData;
   
}


@end

@implementation ApplyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    friendsData=[[NSMutableArray alloc]init];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"title.apply", @"Application and notification");;
    [label sizeToFit];
    
 
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 23)];
    [backButton setImage:[UIImage imageNamed:@"back_img"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self loadDataSourceFromLocalDB];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [MobClick  beginLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
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
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplyFriendCell";
    ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        if (entity) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                
            cell.titleLabel.text = @"群通知";
                
                NSURL *headImgUrl=[[NSURL alloc]initWithString:entity.applicantAvatar];
                [cell.headerImageView setImageWithURL:headImgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
                
                
                if([entity.reason isEqualToString:CMD_ACTION_NOTICE_GROUP_AGREE]){
                    
                    cell.refuseButton.hidden=YES;
                    cell.addButton.hidden=YES;
                    cell.iknownButton.hidden=NO;
                    [cell.iknownButton addTarget:self action:@selector(removeAceptMessage:) forControlEvents:UIControlEventTouchUpInside];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@同意您加入了群:%@",entity.applicantNick,entity.groupSubject];
                    
                    
                }else if([entity.reason isEqualToString:CMD_ACTION_NOTICE_GROUP_REQUEST]){
                    
                    
                    cell.refuseButton.hidden=NO;
                    cell.addButton.hidden=NO;
                    cell.iknownButton.hidden=YES;
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@请求加入群:%@",entity.applicantNick,entity.groupSubject];
                    
                }else if ([entity.reason isEqualToString:CMD_ACTION_NOTICE_GROUP_REFUSE]){
                    
                    cell.refuseButton.hidden=YES;
                    cell.addButton.hidden=YES;
                    cell.iknownButton.hidden=NO;
                    [cell.iknownButton addTarget:self action:@selector(removeAceptMessage:) forControlEvents:UIControlEventTouchUpInside];
                    cell.contentLabel.text = [NSString stringWithFormat:@"您加入群组:%@的请求被拒绝",entity.groupSubject];
                }
                
                
                
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                cell.titleLabel.text = [NSString stringWithFormat:@"%@已经加入了群组%@",entity.applicantNick,entity.groupSubject];
                cell.contentLabel.text = @"";
                NSURL *headImgUrl=[[NSURL alloc]initWithString:entity.applicantAvatar];
                [cell.headerImageView setImageWithURL:headImgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
                cell.refuseButton.hidden=YES;
                cell.addButton.hidden=YES;
                cell.iknownButton.hidden=NO;
                [cell.iknownButton addTarget:self action:@selector(removeAceptMessage:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if(applyStyle == ApplyStyleFriend){
                

                cell.titleLabel.text=entity.applicantNick;
                NSURL *headImgUrl=[[NSURL alloc]initWithString:entity.applicantAvatar];
                [cell.headerImageView setImageWithURL:headImgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
            
                
                if([entity.reason isEqualToString:CMD_ACTION_NOTICE_ADD]){
                    
                    cell.refuseButton.hidden=NO;
                    cell.addButton.hidden=NO;
                    cell.iknownButton.hidden=YES;
                    
                    
                    cell.contentLabel.text = @"加个好友呗";
                    
                }else if([entity.reason isEqualToString:CMD_ACTION_NOTICE_AGREE]){
                    
                    
                    cell.refuseButton.hidden=YES;
                    cell.addButton.hidden=YES;
                    cell.iknownButton.hidden=NO;
                    [cell.iknownButton addTarget:self action:@selector(removeAceptMessage:) forControlEvents:UIControlEventTouchUpInside];
                    cell.contentLabel.text = @"同意了你的请求";
                    
                }else if ([entity.reason isEqualToString:CMD_ACTION_NOTICE_REFUSE]){
                    
                    cell.refuseButton.hidden=YES;
                    cell.addButton.hidden=YES;
                    cell.iknownButton.hidden=NO;
                    [cell.iknownButton addTarget:self action:@selector(removeAceptMessage:) forControlEvents:UIControlEventTouchUpInside];
                    cell.contentLabel.text = @"拒绝了你的请求";
                }
                
            }
            
           
        }
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    return [ApplyFriendCell heightWithContent:entity.reason];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
//        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        
        /*if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
        }
        else */if (applyStyle == ApplyStyleGroupInvitation)
        {
            
            
            
            
            [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
            
            
            
        
            if(!error){
                
                if (!error) {
                    [self.dataSource removeObject:entity];
                    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
                    [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
                    //通知其申请被同意
                    [CmdDealWith cmdToDealWithGroup:CMD_ACTION_NOTICE_GROUP_AGREE :@{@"groupId":entity.groupId,@"groupName":(entity.groupSubject && entity.groupSubject.length) > 0 ? entity.groupSubject : entity.groupId} :entity.applicantUsername];
                    
                    [self.tableView reloadData];
                
                
                }
                else{
                    [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
                }
                
            }
            
        
        }
        else if(applyStyle == ApplyStyleFriend){
            
            
//            [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
            
            //接受好友请求
            [self joinInHttp:ACCEPTFRIENDS :entity :@{@"user":[user_info objectForKey:userAccount],@"friend":entity.applicantUsername}];
            
            
        }
        
        [self hideHud];
       
    }
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
//        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
//        if (applyStyle == ApplyStyleGroupInvitation) {
//            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
//        }
//        else
            if (applyStyle == ApplyStyleGroupInvitation)
        {
            NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), entity.groupSubject];
            [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:reason];
            
            [self hideHud];
        }
        else if(applyStyle == ApplyStyleFriend){
            
            
            [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
        }
        
        [self hideHud];
        if (!error) {
            
            //拒绝时发送透传消息
            [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_REFUSE :entity.applicantUsername];
            
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            
            
            
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
        }
    }
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    oldEntity.applicantNick = [dictionary objectForKey:@"applicantNick"];
                    oldEntity.applicantAvatar = [dictionary objectForKey:@"applicantAvatar"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
             newEntity.applicantNick = [dictionary objectForKey:@"applicantNick"];
            newEntity.applicantAvatar = [dictionary objectForKey:@"applicantAvatar"];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
           
            
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.tableView reloadData];

        }
    }
}

- (void)loadDataSourceFromLocalDB
{
    
//       [[ApplyViewController shareController] clear];


    [_dataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
       
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataSource addObjectsFromArray:applyArray];
        [self.tableView reloadData];
    }
}


-(void)joinInHttp:(NSString *)httpUrl:(ApplyEntity * )entity:(NSDictionary*)arry{
    
    
//    //接受好友请求
//    NSDictionary *arry=@{@"user":[user_info objectForKey:userAccount],@"friend":entity.applicantUsername};
    
    //提示框
    [self showHudInView:self.view hint:@"正在处理..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:httpUrl parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *addData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
        
        [self hideHud];
        if ([addData[@"code"] intValue]==0) {
            
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            
            //接受后发送透传消息
            [CmdDealWith cmdToDealWith:CMD_ACTION_NOTICE_AGREE :entity.applicantUsername];
            //刷新好友列表
            [[NSNotificationCenter defaultCenter] postNotificationName:AGREEINVITATIONFRIEND object:nil];
            
            
            [self.tableView reloadData];
            
        }else {
            
            [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self hideHud];
        
        [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
        
    }];
    

    
}
//删除接受请求的提示
-(void)removeAceptMessage:(UIButton*)btn{
    
    
    ApplyEntity *entity = [self.dataSource objectAtIndex:btn.tag];
//    ApplyStyle applyStyle = [entity.style intValue];
//    EMError *error;
    
    [self.dataSource removeObject:entity];
    NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
    [self.tableView reloadData];
    
    
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEAPPLYCOUNT object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

@end
