//
//  MessageViewController.m
//  ISQ
//
//  Created by mac on 15-3-20.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageGroupTableViewCell.h"
#import "ADLivelyTableView.h"
#import "MessageMessageTableViewCell.h"
#import "FriendsTableViewCell.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "ApplyViewController.h"
#import "AddFriendViewController.h"
#import "ChineseToPinyin.h"
#import "addMakeController.h"
#import "RelationCollectionCell.h"
#import "pinyin.h"
#import "MJNIndexView.h"
#import "GetVcard.h"
#import "UIImageView+AFNetworking.h"
#import "UserDetailViewController.h"
#import "ImgURLisFount.h"
#import "MyFriendsModle.h"
#import "MainViewController.h"
#import "LoginViewController.h"

@interface MessageViewController ()<MJNIndexViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate,IChatManagerDelegate,UIAlertViewDelegate>{
    NSMutableArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
    NSMutableDictionary*index;
    UIView *friends_line;
    NSArray*arraylist; //好友字母检索的排序
    UITableView *findTableview;
    EGOCache *theCache;
    GetVcard *strUpreturn;
    
    
}
@property (nonatomic, strong) MJNIndexView *indexView;
@property (strong, nonatomic) NSMutableArray        *dataSource;//消息
@property (nonatomic, strong) EMSearchBar           *searchBar;// 消息
@property (nonatomic, strong) SRRefreshView         *slimeView;//消息
@property (nonatomic, strong) SRRefreshView         *slimeView2;//好友
@property (nonatomic, strong) SRRefreshView         *slimeView3;//群组
@property (strong, nonatomic) EMSearchDisplayController *searchController;//消息
@property (strong, nonatomic) UILabel *unapplyCountLabel;
//好友
@property (strong, nonatomic) NSMutableDictionary *friendsDataSource;
@property (strong, nonatomic) NSMutableArray *contactsSource;

//群组
@property (strong, nonatomic) NSMutableArray *groupDataSource;

@end
// MJNIndexView


@implementation MessageViewController
@synthesize mTop_bg,im_message_contec_ol,message_lable,contec_lable;
@synthesize contactView,groupTableview,messageTableview,frindsTableview;
@synthesize friendsView,groupView;
@synthesize selectView,friends_group_ol;
bool mtop_bt_st=true;
bool Friends_Group=true;
NSInteger applyCount; //通知的条数
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    theCache=[[EGOCache alloc]init];
    strUpreturn=[[GetVcard alloc]init];
   
    
    //获取好友缓存
    [self myFriendsList];
    
    _dataSource = [NSMutableArray array];//消息数据源
    [self searchController];
    [self removeEmptyConversationsFromDB];
    [self.messageTableview addSubview:self.slimeView];
    [self.frindsTableview addSubview:self.slimeView2];
    [self.groupTableview addSubview:self.slimeView3];
    [self.messageView  addSubview:self.searchBar];
    
    
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];//初始化图像视图
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //刷新未读消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:UPDATEAPPLYCOUNT object:nil];
    //同意成为好友刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFriendsData) name:AGREEINVITATIONFRIEND object:nil];
    
    [self setupUntreatedApplyCount];
    
    //选择群组也好友时的蓝色底线
    friends_line=[[UIView alloc]initWithFrame:CGRectMake(0, 38, UISCREENWIDTH/2-0.5f, 3)];
    friends_line.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
    [self.selectView addSubview:friends_line];
    
    //好友搜索的view
    [self friendsSeach];
    findTableview=[[UITableView alloc]init];
}



//获取好友缓存
-(void)myFriendsList{
    
    _friendsDataSource = [[NSMutableDictionary alloc] init];//好友数据源
    _contactsSource = [NSMutableArray array];//用于好友搜索的数据源
    
    if([theCache plistForKey:IMCACHEDATA]){
        
        _friendsDataSource=[NSJSONSerialization JSONObjectWithData:[theCache plistForKey:IMCACHEDATA] options:NSJapaneseEUCStringEncoding error:nil];
        //对好友数据进行数据分组a~z#
        [self formattingFriendsData];
    }
    
    
    
    
    [self.frindsTableview reloadData];
    
    [self theIndexForFriends];
    
}

//对好友数据进行数据分组a~z#
-(void)formattingFriendsData{
    
    
    [index removeAllObjects];
    
    
    //建立一个字典，字典保存key是A-Z  值是数组
    index=[NSMutableDictionary dictionaryWithCapacity:0];
    
    if(_friendsDataSource[@"friends"]){
    
    for (NSDictionary *searchData in _friendsDataSource[@"friends"]) {
        
        if([searchData[@"remark"] length]>0){
            
            //用于好友搜索
            [_contactsSource addObject:searchData[@"remark"]];
            
        }else {
            
            //用于好友搜索
            [_contactsSource addObject:searchData[@"nick"]];
        }
        
        
        NSString *strFirLetter=[strUpreturn upperStr:[NSString stringWithFormat:@"%c",pinyinFirstLetter([[searchData[@"remark"] length]>0? searchData[@"remark"]:searchData[@"nick"] characterAtIndex:0])]];
        
        if ( strFirLetter!=nil && [[index allKeys]containsObject:strFirLetter]) {
            //判断index字典中，是否有这个key如果有，取出值进行追加操作
            [[index objectForKey:strFirLetter] addObject:searchData];
            
            
        }else if(strFirLetter!=nil){
            
            NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
            [tempArray addObject:searchData];
            
            
            
            [index setObject:tempArray forKey:strFirLetter];
            
        }
                
    }

    }
}

//好友的索引的view
-(void)theIndexForFriends{
    
    //分组索引排序
    arraylist = [[index allKeys] sortedArrayUsingSelector:@selector(compare:)];

    if (arraylist.count>0) {
        
    if ([arraylist[0] isEqualToString:@"#"]) {
        
        NSMutableArray *arry=[[NSMutableArray alloc]init];
        
        [arry addObjectsFromArray:arraylist];
        [arry removeObjectAtIndex:0];
        [arry addObject:@"#"];
        arraylist=arry;
    }
        
    [self.indexView removeFromSuperview];
    self.indexView.dataSource=nil;
    //分组索引
    self.indexView = [[MJNIndexView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH-2, UISCREENHEIGHT-200)];
    self.indexView.dataSource = self;
    self.indexView.fontColor = [UIColor blackColor];
    [self.friendsView addSubview:self.indexView];
    
    }
}

//好友搜索
-(void)friendsSeach{
    
    self.selectView.layer.borderWidth=0.4f;
    self.selectView.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
    
    UISearchBar *friends_seachview = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44)];
    
    friends_seachview.backgroundImage=[UIImage imageNamed:@"searchBg"];
    friends_seachview.placeholder = @"搜索";
    
    
    // 添加 searchbar 到 headerview
    self.frindsTableview.tableHeaderView = friends_seachview;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:friends_seachview contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    
    return _slimeView;
}

#pragma mark - getter

- (SRRefreshView *)slimeView2
{
    if (!_slimeView2) {
        _slimeView2 = [[SRRefreshView alloc] init];
        _slimeView2.delegate = self;
        _slimeView2.upInset = 0;
        _slimeView2.slimeMissWhenGoingBack = YES;
        _slimeView2.slime.bodyColor = [UIColor grayColor];
        _slimeView2.slime.skinColor = [UIColor grayColor];
        _slimeView2.slime.lineWith = 1;
        _slimeView2.slime.shadowBlur = 4;
        _slimeView2.slime.shadowColor = [UIColor grayColor];
        _slimeView2.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    
    return _slimeView2;
}
#pragma mark - getter

- (SRRefreshView *)slimeView3
{
    if (!_slimeView3) {
        _slimeView3 = [[SRRefreshView alloc] init];
        _slimeView3.delegate = self;
        _slimeView3.upInset = 0;
        _slimeView3.slimeMissWhenGoingBack = YES;
        _slimeView3.slime.bodyColor = [UIColor grayColor];
        _slimeView3.slime.skinColor = [UIColor grayColor];
        _slimeView3.slime.lineWith = 1;
        _slimeView3.slime.shadowBlur = 4;
        _slimeView3.slime.shadowColor = [UIColor grayColor];
        _slimeView3.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    return _slimeView3;
}



- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0,UISCREENWIDTH, 44)];
        _searchBar.backgroundImage=[UIImage imageNamed:@"searchBg"];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    
    
    NSMutableArray *theNikname=[[NSMutableArray alloc]init];
    
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak MessageViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ChatListCell";
            ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
            for (NSDictionary *friendsName in weakSelf.friendsDataSource[@"friends"]) {
               MyFriendsModle *modle=[MyFriendsModle objectWithKeyValues:friendsName];
                
                if ([modle.hxid isEqualToString:conversation.chatter]) {
                    
                    [theNikname addObject:[NSString stringWithFormat:@"%@",modle.remark.length>0 ?modle.remark:modle.nick]];
                    
                    cell.name = [NSString stringWithFormat:@"%@",modle.remark.length>0 ?modle.remark:modle.nick];
                    NSURL *imgUrl=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",friendsName[@"avatar"]]];
                    cell.imageURL=imgUrl;
                    
                }
            }
            
            if (conversation.conversationType) {
                
                NSString *imageName = @"groupPublicHeader";
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.name = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        break;
                    }
                }
                cell.placeholderImage = [UIImage imageNamed:imageName];
                
            }
            
            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
            if (indexPath.row % 2 == 1) {
                cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
            }else{
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter isGroup:conversation.conversationType];
            chatVC.title = [theNikname objectAtIndex:indexPath.row];
            
//            [weakSelf setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }
    
    return _searchController;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.vidio1", @"[vidio]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}
// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}
// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    
    return  ret;
}

//统计未读消息数(包括申请等)
- (void)setupUntreatedApplyCount
{
    
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger m_unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        m_unreadCount += conversation.unreadMessagesCount;
    }
    
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    NSString *badgeValue = [NSString stringWithFormat:@"%li",(long)unreadCount+m_unreadCount];
    int indexICareAbout = 2;
    if (unreadCount+m_unreadCount>0) {
        [[[[[self tabBarController] viewControllers] objectAtIndex: indexICareAbout] tabBarItem] setBadgeValue:badgeValue];
    }else{
        
        [[[[[self tabBarController] viewControllers] objectAtIndex: indexICareAbout] tabBarItem] setBadgeValue:nil];
    }
    
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:m_unreadCount+unreadCount];
    
    
    
    //从服务器获取并刷新好友数据
        [ self updateFriendsData];
    
    [self.messageTableview reloadData];
}



#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

/**
 用于搜索消息
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self.searchController.resultsSource removeAllObjects];
    for( NSDictionary *theSearch in  _friendsDataSource[@"friends"]){
        
        
        
        if([[NSString stringWithFormat:@"%@",[theSearch[@"remark"] length]>0? theSearch[@"remark"]:theSearch[@"nick"]] rangeOfString:searchText].location !=NSNotFound){
            
            for (EMConversation *conversation in self.dataSource) {
                
                
                if ([theSearch[@"hxid"] isEqualToString:conversation.chatter]) {
                    
                    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:theSearch[@"hxid"] collationStringSelector:@selector(chatter) resultBlock:^(NSArray *results) {
                        if (results) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self.searchController.resultsSource addObjectsFromArray:results];
                                
                                [self.searchController.searchResultsTableView reloadData];
                            });
                        }
                    }];
                    
                }
                
            }
            
        }
        
    }
    
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    [_slimeView2 scrollViewDidScroll];
    [_slimeView3 scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
    [_slimeView2 scrollViewDidEndDraging];
    [_slimeView3 scrollViewDidEndDraging];
    
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (_slimeView==refreshView) {
        
        [self refreshDataSource];
        [_slimeView endRefresh];
    }else if(_slimeView2==refreshView){
        
        
        
        //从服务器刷新好友数据
        [self updateFriendsData];
        
        
                [self myFriendsList];
        
        [_slimeView2 endRefresh];
        
        
    }else if(_slimeView3==refreshView){
        
        [_slimeView3 endRefresh];
        
        [_groupDataSource removeAllObjects];
        [self.groupTableview reloadData];
        
        //群组
        _groupDataSource=[NSMutableArray array];
        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
            if (!error) {
                
                [self.groupDataSource addObjectsFromArray:groups];
                [self.groupTableview reloadData];
                
            }
        } onQueue:nil];
        
        
    }
    
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (tableView==self.frindsTableview) {
        //属于好友的tableview
        
        return arraylist.count;
        
        
    }else if(tableView==self.messageTableview){
        //属于消息的tableview
        return 2;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==messageTableview&&section==0) {
        //tableView=self.messageTableview;
        if(applyCount>0){
            return 1;
        }
        return 0;
        
    }else if (tableView==messageTableview&&section==1){
        
        return self.dataSource.count;
        
        
    }
    else if (tableView==groupTableview) {
        
        
        return self.groupDataSource.count;
        
        
        
    } else if (tableView==frindsTableview) {
        
        
        return [index[arraylist[section]] count];
    }
    
    else{
        // 谓词搜索
        
        //相当于创建一个过滤条件
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        //过滤出符合条件的对象
        filterData =  [[NSArray alloc] initWithArray:[_contactsSource filteredArrayUsingPredicate:predicate]];
        
        return filterData.count;
    }
    
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.messageTableview) {
        return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if (tableView==self.groupTableview){
        
        return 52;
    }else if(tableView==self.frindsTableview){
        return UISCREENWIDTH*0.1626666;
        
    }
    
    else if (searchDisplayController) {
        
        return  UISCREENWIDTH*0.1626666;
    }
    return  0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *mCell;
    //好友列表单cell
    MessageGroupTableViewCell *gCell;
    //群组列表cell
    FriendsTableViewCell *fCell;
    
    //消息
    if (tableView==messageTableview&&indexPath.section==1) {
        
        static NSString *identify = @"chatListCell";
        ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
        
        //获取别人发来的昵称和头像
        EMMessage *message = [conversation latestMessageFromOthers];
        
        
        if (!conversation.conversationType) {
            for (NSDictionary *myFriends in _friendsDataSource[@"friends"]) {
                
                MyFriendsModle *modle=[MyFriendsModle objectWithKeyValues:myFriends];
                if ([conversation.chatter isEqualToString:[NSString stringWithFormat:@"%@",modle.hxid]]) {
                    
                    cell.name = [NSString stringWithFormat:@"%@",modle.remark.length>0 ?modle.remark:modle.nick];
                    
                    NSURL *theUrlM=[NSURL URLWithString:[@"http://" stringByAppendingString:modle.avatar]];
                    
                    
                    cell.imageURL=theUrlM;
                    
                    break;
                }else if (message.ext!=nil){
                    
                    
                    cell.name=message.ext[@"my_nick"];
                    NSURL *theUrlM=[NSURL URLWithString:message.ext[@"my_avatar"]];
                    cell.imageURL=theUrlM;
                    
                }
                
            }
            
        }else{
            cell.name = conversation.chatter;
            NSString *imageName = @"groupPublicHeader";            
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    cell.name = group.groupSubject;
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    
                    NSURL *theUrlM=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",IMGROUPIMG,group.groupId]];
                    cell.imageURL=theUrlM;
                    
                    break;
                }
            }
            
        }
        cell.detailMsg = [self subTitleMessageByConversation:conversation];
        cell.time = [self lastMessageTimeByConversation:conversation];
        cell.unreadCount = [self unreadMessageCountByConversation:conversation];
        
        if (indexPath.row % 2 == 1) {
            cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        
        return cell;
        
        
    }
    //申请通知
    else if (tableView==self.messageTableview&&indexPath.section==0){
        
        BaseTableViewCell *cell;
        cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
        if (cell == nil) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"newFriends"];
        cell.textLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
        [cell addSubview:self.unapplyCountLabel];
        
        return cell;
        
    }
    else if (tableView==frindsTableview) {
        
        
        static NSString *GroupedTableIdentifier = @"FriendsCell";
        fCell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier forIndexPath:indexPath];
        
        MyFriendsModle *modle=[MyFriendsModle objectWithKeyValues:index[arraylist[indexPath.section]][indexPath.row]];
        
        NSURL *theUrl=[NSURL URLWithString:[@"http://" stringByAppendingString:modle.avatar]];
        
        [fCell.myFriendsImg setImageWithURL:theUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        if ([ImgURLisFount TheDataIsImgage:fCell.myFriendsImg.image]==2) {
            
            
        }else{
            
            fCell.myFriendsImg.image=[UIImage imageNamed:@"defuleImg"];
            
        }

        fCell.myFriendName_lable.text=[NSString stringWithFormat:@"%@",( modle.remark.length>0? modle.remark :modle.nick)];
        
        //语音通话按钮
        fCell.callBt_ol.tag=indexPath.row;
        [fCell.callBt_ol addTarget:self action:@selector(callMyFriends:) forControlEvents:UIControlEventTouchUpInside];
        
        //聊天按钮
        fCell.toChat_ol.tag=indexPath.row;
        [fCell.toChat_ol addTarget:self action:@selector(chatWithFriends:) forControlEvents:UIControlEventTouchUpInside];
        
        
        fCell.layer.borderWidth=0.3f;
        fCell.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
        
        return fCell;
        
        
    }else if (tableView==groupTableview){
        
        
        gCell=[tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
        
        EMGroup *group = [self.groupDataSource objectAtIndex:indexPath.row];
        NSString *imageName = [NSString stringWithFormat:@"%@%@.png",IMGROUPIMG,group.groupId];
        
        NSURL *imgUrl=[[NSURL alloc]initWithString:imageName];
        
        [gCell.groupImage setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
        
        if ([ImgURLisFount TheDataIsImgage:gCell.groupImage.image]==2) {
            
            
        }else{
            
            gCell.groupImage.image=[UIImage imageNamed:@"defuleImg"];
            
        }
  
        if (group.groupSubject && group.groupSubject.length > 0) {
            gCell.groupName.text = group.groupSubject;
        }
        else {
            gCell.groupName.text = group.groupId;
        }
        
        gCell.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
        gCell.layer.borderWidth=0.3f;
        return gCell;
    }
    else if(searchDisplayController){
        
        if (Friends_Group==true) {
            
            findTableview=tableView;
            
            mCell=[[UITableViewCell alloc]init];
            tableView.separatorStyle=NO;
            UIView  *findView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENWIDTH*0.1626666)];
            findView.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
            findView.layer.borderWidth=0.3f;
            
            UIImageView *findImg=[[UIImageView alloc]initWithFrame:CGRectMake(13, 6, UISCREENWIDTH*0.133333, UISCREENWIDTH*0.133333)];
            
            UILabel *findLable=[[UILabel alloc]initWithFrame:CGRectMake(13+UISCREENWIDTH*0.13333+3, 0, UISCREENWIDTH-(13+UISCREENWIDTH*0.13333+3)-(UISCREENWIDTH*0.133333+17), UISCREENWIDTH*0.1626666)];
            findLable.textAlignment=NSTextAlignmentCenter;
            findLable.textAlignment=NSTextAlignmentLeft;
            
            //进入通话
            UIButton *findButton=[[UIButton alloc]initWithFrame:CGRectMake(UISCREENWIDTH-UISCREENWIDTH*0.133333-17, 6, UISCREENWIDTH*0.133333, UISCREENWIDTH*0.133333)];
            [findButton setImage:[UIImage imageNamed:@"Fill 179"] forState:UIControlStateNormal];
            findButton.tag=indexPath.row+2000;
            [findButton addTarget:self action:@selector(callMyFriends:) forControlEvents:UIControlEventTouchUpInside];
            
            //进入聊天
            UIButton *chatButton=[[UIButton alloc]initWithFrame:CGRectMake(UISCREENWIDTH-UISCREENWIDTH*0.133333-17-UISCREENWIDTH*0.133333, 6, UISCREENWIDTH*0.133333, UISCREENWIDTH*0.133333)];
            [chatButton setImage:[UIImage imageNamed:@"Fill 192"] forState:UIControlStateNormal];
            chatButton.tag=indexPath.row+2000;
            [chatButton addTarget:self action:@selector(chatWithFriends:) forControlEvents:UIControlEventTouchUpInside];
            
            if (_friendsDataSource) {
                
                for (NSDictionary *searchDada in _friendsDataSource[@"friends"]) {
                    
                MyFriendsModle *modle=[MyFriendsModle objectWithKeyValues:searchDada];
                    
                    if ([filterData[indexPath.row] isEqualToString:modle.nick]||(modle.remark.length>0&&[filterData[indexPath.row] isEqualToString:modle.remark])) {
                        
                        NSURL *imgUrl=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",modle.avatar]];
                        
                        [findImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
                        
                    }
                    
                }
            }
       
            findLable.text=filterData[indexPath.row];
            
            [findView addSubview:findImg];
            [findView addSubview:findLable];
            [findView addSubview:findButton];
            [findView addSubview:chatButton];
            [mCell addSubview:findView];
        }
    }
    
    return mCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.messageTableview==tableView&&indexPath.section==1) {
        
        EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
        
        ChatViewController *chatController;
        
        NSString *chatter = conversation.chatter;
        chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:conversation.conversationType];
//        if (conversation.conversationType) {
//            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//            for (EMGroup *group in groupArray) {
//                if ([group.groupId isEqualToString:conversation.chatter]) {
//                    chatController.title=group.groupSubject;
//                    break;
//                }
//            }
//        }
        
        if (_friendsDataSource) {
            
            for (NSDictionary *myFriends in _friendsDataSource[@"friends"]) {
                
              MyFriendsModle *modle=[MyFriendsModle objectWithKeyValues:myFriends];
                if ([conversation.chatter isEqualToString:[NSString stringWithFormat:@"%@",modle.hxid]]) {
                    
                    chatController.title =[NSString stringWithFormat:@"%@",modle.remark.length>0 ?modle.remark:modle.nick];
                    
                    break;
                }
                
            }
        }

        [chatController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatController animated:YES];
        
    }
    
    else if(self.messageTableview==tableView&&indexPath.section==0){
        
        [[ApplyViewController shareController] setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
    }
    
    else if(self.frindsTableview==tableView){
        //查看好友信息
        
        UserDetailViewController *detailVC=[[UserDetailViewController alloc] initWithFriendsData:index[arraylist[indexPath.section]][indexPath.row]];
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        
        
        
    }else if (tableView==self.groupTableview){
        
        EMGroup *group = [self.groupDataSource objectAtIndex:indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
        chatController.title = group.groupSubject;
        [chatController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatController animated:YES];
        
    }//与搜索的好友聊天
    else if (searchDisplayController){
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:filterData[indexPath.row]]) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:filterData[indexPath.row] isGroup:NO];
        
        chatVC.title = filterData[indexPath.row];
        [chatVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    [self.view endEditing:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete&& tableView== self.messageTableview) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.messageTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete&& tableView== self.frindsTableview){
        
        [self deleteFriend:index[arraylist[indexPath.section]][indexPath.row][@"hxid"]];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView==self.frindsTableview) {
        
        
        return 16;
    }
    
    return 0;
}


//分组名
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(tableView==self.frindsTableview&&arraylist.count>0){
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 16)];
        headerView.backgroundColor=[UIColor colorWithRed:238.0f/255 green:237.0f/255 blue:243.0f/255 alpha:0.9f];
        UILabel *headerLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 20, 16)];
        
        headerLable.text=arraylist[section];
        [headerView addSubview:headerLable];
        
        return headerView;
        
    }
    
    return nil;
}
//分组索引
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    
    if (arraylist.count>0) {
        
        return arraylist;
    }
    return nil;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    
    [self.frindsTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
}

//进入聊天
-(void)chatWithFriends:(UIButton*)btn{
    
    UIView *v;
    
    if (SYSTEMVERSION<8.0) {
        
        v= [btn superview].superview;//获取父类view
    }else{
        
        v= [btn superview];
    }
    
    if (btn.tag>=2000) {
        
//        UITableViewCell *cell = (UITableViewCell *)[v superview];//获取cell
//        NSIndexPath *indexPath = [findTableview indexPathForCell:cell];//获取cell对应的section
//        
//        
//        for (NSDictionary *theData in _friendsDataSource[@"friends"]) {
//            
//            if ([filterData[indexPath.row] isEqualToString:theData[@"nick"]]) {
//                
//                
//                ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:theData[@"hxid"] isGroup:NO];
//                chatVC.title = theData[@"nick"];
//                [chatVC setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:chatVC animated:YES];
//           
//            }
//            
//        }
    
    }else {
 
        UIView *v1 = [v superview];
        UITableViewCell *cell = (UITableViewCell *)[v1 superview];//获取cell
        NSIndexPath *indexPath = [self.frindsTableview indexPathForCell:cell];//获取cell对应的section
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:index[arraylist[indexPath.section]][indexPath.row][@"hxid"] isGroup:NO];
        chatVC.title = [NSString stringWithFormat:@"%@", [index[arraylist[indexPath.section]][indexPath.row][@"remark"] length ]>0? index[arraylist[indexPath.section]][indexPath.row][@"remark"]:index[arraylist[indexPath.section]][indexPath.row][@"nick"]];
        [chatVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}


//从服务器获取并刷新用户自身数据及好友数据
-(void)updateFriendsData{
    
    if ([user_info objectForKey:userAccount] && [user_info objectForKey:userPassword]) {
        
        NSDictionary *arry=@{@"user":[user_info objectForKey:userAccount],@"pwd":[user_info objectForKey:userPassword]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        [manager GET:IMFRIENDSDATA parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [theCache setPlist:responseObject forKey:IMCACHEDATA];
            //将responseObject通过NSJSONSerialization转化为字典
            _friendsDataSource = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //对好友数据进行数据分组a~z#
            [self formattingFriendsData];
            [self theIndexForFriends];
            [self.frindsTableview reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if([theCache plistForKey:IMCACHEDATA]){
                
                _friendsDataSource=[NSJSONSerialization JSONObjectWithData:[theCache plistForKey:IMCACHEDATA] options:NSJapaneseEUCStringEncoding error:nil];
                //对好友数据进行数据分组a~z#
                [self formattingFriendsData];
            }
            
            //对好友数据进行数据分组a~z#
            [self formattingFriendsData];
            [self theIndexForFriends];
            [self.frindsTableview reloadData];
            
        }];
        

        
    }
    
//    NSDictionary *arry=@{@"user":[user_info objectForKey:userAccount],@"pwd":[user_info objectForKey:userPassword]};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    
//    [manager GET:IMFRIENDSDATA parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//            [theCache setPlist:responseObject forKey:IMCACHEDATA];
//            //将responseObject通过NSJSONSerialization转化为字典
//             _friendsDataSource = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            //对好友数据进行数据分组a~z#
//            [self formattingFriendsData];
//            [self theIndexForFriends];
//            [self.frindsTableview reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if([theCache plistForKey:IMCACHEDATA]){
//            
//            _friendsDataSource=[NSJSONSerialization JSONObjectWithData:[theCache plistForKey:IMCACHEDATA] options:NSJapaneseEUCStringEncoding error:nil];
//            //对好友数据进行数据分组a~z#
//            [self formattingFriendsData];
//        }
//        
//        //对好友数据进行数据分组a~z#
//        [self formattingFriendsData];        
//        [self theIndexForFriends];
//        [self.frindsTableview reloadData];
//        
//    }];
//    
}

//删除好友
-(void)deleteFriend:(NSString *)fa{
    
//    user_info=[NSUserDefaults standardUserDefaults];
    NSDictionary *arry=@{@"ua":[user_info objectForKey:userAccount],@"fa":fa};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:DELETEFRIEND parameters:arry success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJapaneseEUCStringEncoding error:nil];
        
        
        
        if (dic) {
            
            if ([dic[@"code"] intValue]==0) {
                
                [self updateFriendsData];
            }
            
        }
 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
 
}

//语音通话
-(void)callMyFriends:(UIButton*)btn{
    
    UIView *v;
    
    if (SYSTEMVERSION<8.0) {//当系统版本8.0以下
        
        v= [btn superview].superview;//获取父类view
    }else{
        
        v= [btn superview];
    }
    
    if (btn.tag>=2000) {
        
        
        UITableViewCell *cell = (UITableViewCell *)[v superview];//获取cell
        NSIndexPath *indexPath = [findTableview indexPathForCell:cell];//获取cell对应的section
        
        
        for (NSDictionary *theData in _friendsDataSource[@"friends"]) {
            
            MyFriendsModle *modle=[MyFriendsModle objectWithKeyValues:theData];
            
            if ([filterData[indexPath.row] isEqualToString:modle.nick]||(modle.remark.length>0&&[filterData[indexPath.row] isEqualToString:modle.remark])) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":theData[@"hxid"], @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
                
            }
            
        }
        
        
        
    }else {
        
        
        UIView *v1 = [v superview];
        UITableViewCell *cell = (UITableViewCell *)[v1 superview];//获取cell
        NSIndexPath *indexPath = [self.frindsTableview indexPathForCell:cell];//获取cell对应的section
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":index[arraylist[indexPath.section]][indexPath.row][@"hxid"], @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
        
        
    }
}

//未处理的申请条数的lable
- (UILabel *)unapplyCountLabel
{
    if (_unapplyCountLabel == nil) {
        _unapplyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 5, 20, 20)];
        _unapplyCountLabel.textAlignment = NSTextAlignmentCenter;
        _unapplyCountLabel.font = [UIFont systemFontOfSize:11];
        _unapplyCountLabel.backgroundColor = [UIColor redColor];
        _unapplyCountLabel.textColor = [UIColor whiteColor];
        _unapplyCountLabel.layer.cornerRadius = _unapplyCountLabel.frame.size.height / 2;
        _unapplyCountLabel.hidden = YES;
        _unapplyCountLabel.clipsToBounds = YES;
    }
    
    return _unapplyCountLabel;
}


#pragma mark - action

- (void)reloadApplyView
{

    applyCount = [[[ApplyViewController shareController] dataSource] count];

    if (applyCount <= 0) {
        self.unapplyCountLabel.hidden = YES;
    }
    else
    {
        NSString *tmpStr = [NSString stringWithFormat:@"%i", (int)applyCount];
        CGSize size = [tmpStr sizeWithFont:self.unapplyCountLabel.font constrainedToSize:CGSizeMake(50, 20) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = self.unapplyCountLabel.frame;
        rect.size.width = size.width > 20 ? size.width : 20;
        self.unapplyCountLabel.text = tmpStr;
        self.unapplyCountLabel.frame = rect;
        self.unapplyCountLabel.hidden = NO;
    }
    
    [self setupUntreatedApplyCount];
    
}

- (IBAction)friends_group_bt:(id)sender {
    NSInteger numIndexSelect=self.friends_group_ol.selectedSegmentIndex;
    
    switch (numIndexSelect) {
        case 0:
            
            //一定要在这个位置做刷新
            //[self.frindsTableview reloadData];
            
            self.friendsView.hidden=NO;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            friends_line.transform=CGAffineTransformMakeTranslation(0, 0);
            [UIView commitAnimations];
            self.groupView.hidden=YES;
            
            Friends_Group=!Friends_Group;
            
            
            break;
            
        case 1:
            
            self.groupView.hidden=NO;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            friends_line.transform=CGAffineTransformMakeTranslation(UISCREENWIDTH/2-0.5f, 0);
            [UIView commitAnimations];
            
            self.friendsView.hidden=YES;
            Friends_Group=!Friends_Group;
            
            [_groupDataSource removeAllObjects];
            [self.groupTableview reloadData];
            
            //群组
            _groupDataSource=[NSMutableArray array];
            [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
                if (!error) {
                    
                    [self.groupDataSource addObjectsFromArray:groups];
                    [self.groupTableview reloadData];
                    
                }
            } onQueue:nil];
            
            
            
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //判断登陆后获取数据
    if ([user_info objectForKey:userPassword]&&[user_info objectForKey:userAccount]){
    
        if (self.messageTableview) {
            [self refreshDataSource];
        }
        
        [self registerNotifications];
    }else{
        
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此功能需要登陆才能使用" message:@"立刻登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show]; 
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{ 
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
        UIStoryboard *mainStory=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *mainVC=[mainStory instantiateViewControllerWithIdentifier:@"MainViewStory"];
        self.navigationController.navigationBar.hidden=YES;
        [self.navigationController pushViewController:mainVC animated:YES];
        
    }else if (buttonIndex == 1){
    
        UIStoryboard *board=[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil];
        LoginViewController *loginVC=[board instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
        [self.navigationController pushViewController:loginVC animated:YES];

    }
}


#pragma mark - public

-(void)refreshDataSource
{
    [self reloadApplyView];
    self.dataSource = [self loadDataSource];

    
    [self.messageTableview reloadData];

    [self hideHud];
}


- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
    [self refreshDataSource];
}


#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}


-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - private

- (NSMutableArray *)loadDataSource

{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          
                          
                          
                          if(message1.timestamp > message2.timestamp) {
                              
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    
    
    
    
    return ret;
}

- (UITableView *)TheMessageTableview
{
    if (self.messageTableview == nil) {
        
        self.messageTableview.backgroundColor = [UIColor whiteColor];
        
        
        self.messageTableview.tableFooterView = [[UIView alloc] init];
        self.messageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.messageTableview registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return self.messageTableview;
}


/*!
 @method
 @brief 好友请求被接受时的回调
 @discussion
 @param username 之前发出的好友请求被用户username接受了
 */
- (void)didAcceptedByBuddy:(NSString *)username{
    
    //从服务器刷新好友数据
    [self updateFriendsData];
    
}

#pragma mark - IChatMangerDelegate
//监听未读消息变化
-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
    [self setupUntreatedApplyCount];
    [self reloadApplyView];
    
}

//从服务器获取群组
- (void)didUpdateGroupList:(NSArray *)groupList
                     error:(EMError *)error
{
    
    [self refreshDataSource];
}
//添加操作
- (IBAction)addFrends_bt:(id)sender {
    
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    addMakeController *addMakeVC=[board instantiateViewControllerWithIdentifier:@"addMakeController"];
    
    [addMakeVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addMakeVC animated:YES];
    
}

- (IBAction)im_message_contec_bt:(id)sender {
    
    NSInteger numIndexSelect = self.im_message_contec_ol.selectedSegmentIndex;
    switch (numIndexSelect) {
        case 0:
            [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(refreshDataSource) userInfo:nil repeats:NO];
            
            self.contactView.hidden=YES;
            self.messageView.hidden=NO;
            [self.mTop_bg setImage:[UIImage imageNamed:@"Rectangle 512.png"]];
            mtop_bt_st=!mtop_bt_st;
            
            self.message_lable.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            self.contec_lable.textColor = [UIColor whiteColor];
            
            
            break;
            
        case 1:
            
            
            
            if (!mtop_bt_st&&Friends_Group) {
                {
                    
                    [self.groupTableview reloadData];
                    
                }
            }
            
            self.contactView.hidden=NO;
            self.messageView.hidden=YES;
            
            
            [self.mTop_bg setImage:[UIImage imageNamed:@"Rectangle 512 + Rectangle 513.png"]];
            mtop_bt_st=false;
            
            self.contec_lable.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
            self.message_lable.textColor=[UIColor whiteColor];
            
            //一定要在这个位置做刷新
            
            if (!mtop_bt_st&&Friends_Group) {
                
                [self.frindsTableview reloadData];
            }
            
            break;
    }
    
    
}

@end
