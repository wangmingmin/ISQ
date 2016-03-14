//
//  meetingTableViewController.m
//  chuanwanList
//
//  Created by 123 on 16/3/10.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "meetingTableViewController.h"
#import "TableViewMeetingCell.h"
#import "meetingDetailsTableViewController.h"
#import "ISQHttpTool.h"
#import "SRRefreshView.h"
#define cellHeight 120
@interface meetingTableViewController ()<UISearchBarDelegate,UISearchResultsUpdating,SRRefreshDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UISearchController * searchController;
@property (strong, nonatomic) NSMutableArray * discussArray;
@property (strong, nonatomic) NSArray * staticArrayForSearch;
@property (nonatomic, strong) SRRefreshView *slimeViewPositive;
@end

@implementation meetingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"议事厅";
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewMeetingCell" bundle:nil] forCellReuseIdentifier:@"cellmy"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = cellHeight;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.discussArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.staticArrayForSearch = [[NSArray alloc] init];
    rowInt = 0;
    [self initSearchController];
    [self refresh];
    [self.tableView addSubview:self.slimeViewPositive];
    [self addFooter];
    self.edgesForExtendedLayout = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - 刷新
- (SRRefreshView *)slimeViewPositive
{
    if (!_slimeViewPositive) {
        _slimeViewPositive = [[SRRefreshView alloc] init];
        _slimeViewPositive.delegate = self;
        _slimeViewPositive.upInset = 0;
        _slimeViewPositive.slimeMissWhenGoingBack = YES;
        _slimeViewPositive.slime.bodyColor = [UIColor grayColor];
        _slimeViewPositive.slime.skinColor = [UIColor grayColor];
        _slimeViewPositive.slime.lineWith = 1;
        _slimeViewPositive.slime.shadowBlur = 4;
        _slimeViewPositive.slime.shadowColor = [UIColor grayColor];
        _slimeViewPositive.backgroundColor = self.view.backgroundColor;
        
    }
    return _slimeViewPositive;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offY = scrollView.contentOffset.y;
    if (offY<0) {
        [_slimeViewPositive scrollViewDidScroll];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offY = scrollView.contentOffset.y;
    if (offY > self.tableView.contentSize.height-self.tableView.frame.size.height+50) {
        [self refresh];
    }
    if (offY<0) {
        [_slimeViewPositive scrollViewDidEndDraging];
    }
}


#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self.slimeViewPositive endRefresh];
}

static int rowInt;
-(void)slimeRefreshEndRefresh:(SRRefreshView *)refreshView
{
    [self.searchDisplayController.searchBar resignFirstResponder];
    if (!self.searchController.searchBar.isFirstResponder) {
        self.staticArrayForSearch = @[];
        [self refresh];
    }
}

#pragma mark 上拉加载更多
- (void)addFooter
{
    __block UITableView * vc = self.tableView;
    
    // 添加上拉刷新尾部控件
    [self.tableView addFooterWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新
            [vc footerEndRefreshing];
        });
    }];
}

-(void)refresh
{
    self.searchController.searchBar.text = @"";
    rowInt = ((int)self.staticArrayForSearch.count/10)*10;
    NSString * httpStr = [NSString stringWithFormat:@"%@?communityId=%d&row=%d",getYSTList,[[user_info objectForKey:userCityID] intValue],rowInt];
    [ISQHttpTool getHttp:httpStr contentType:nil params:nil success:^(id resData) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJapaneseEUCStringEncoding error:nil];
//        NSLog(@"meeting Dic = %@",dataDic);
        NSArray * dataArr = dataDic[@"retData"];
        self.discussArray = (NSMutableArray *)self.staticArrayForSearch;
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (rowInt==self.staticArrayForSearch.count) {
                [self.discussArray addObject:obj];
            }else{
                int index = rowInt+(int)idx+1;
                [self.discussArray replaceObjectAtIndex:index withObject:obj];
            }
        }];
        self.staticArrayForSearch = self.discussArray;
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"暂无议事信息,稍后请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

-(void)initSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *filterString = searchController.searchBar.text;
    if (filterString.length==0) {
        return;
    }

    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[cd] %@",filterString];
    
    self.discussArray = [NSMutableArray arrayWithArray:[self.staticArrayForSearch filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * httpStr = [NSString stringWithFormat:@"%@?communityId=%d&title=%@",getYSTList,[[user_info objectForKey:userCityID] intValue],searchBar.text];
    [ISQHttpTool getHttp:httpStr contentType:nil params:nil success:^(id resData) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJapaneseEUCStringEncoding error:nil];
        self.discussArray = dataDic[@"retData"];
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"暂无结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.discussArray = (NSMutableArray *)self.staticArrayForSearch;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.discussArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * oneDataDic = self.discussArray[indexPath.section];
    
    TableViewMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellmy" forIndexPath:indexPath];
    cell.tag = [oneDataDic[@"id"] integerValue];
    // Configure the cell...
    cell.titleMeeting = oneDataDic[@"title"];
    cell.Lables = [oneDataDic[@"tag"] componentsSeparatedByString:@","];
    cell.timeDate = [NSDate dateWithTimeIntervalSince1970:[oneDataDic[@"start_time"] longLongValue]];
    cell.howManyPeople = [oneDataDic[@"count"] integerValue];
    cell.isInProgress = [oneDataDic[@"status"] boolValue];
    
    if ([oneDataDic[@"image"] isKindOfClass:[NSNull class]]) {
        cell.imageMeeting = nil;
    }else{
        NSURL *url = [NSURL URLWithString:oneDataDic[@"image"]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage * image = [UIImage imageWithData:data];
            cell.imageMeeting = image;
        }];
        [task resume];
    }
    cell.imageMeeting = [[UIImage alloc] init];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12)];
    footerview.backgroundColor = self.tableView.backgroundColor;
    return footerview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewMeetingCell * cell = (TableViewMeetingCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSInteger tagId = cell.tag;
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    
    meetingDetailsTableViewController * Details = [[meetingDetailsTableViewController alloc] initWithID:tagId];
    [self.navigationController pushViewController:Details animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
