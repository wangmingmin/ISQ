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

#define cellHeight 120
@interface meetingTableViewController ()<UISearchBarDelegate,UISearchResultsUpdating>
@property (strong, nonatomic) UISearchController * searchController;
@property (strong, nonatomic) NSArray * tableArrayData;
@property (strong, nonatomic) NSArray * searchArrayData;
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
    [self initSearchController];
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
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.provinceName CONTAINS[cd] %@",filterString];
    
    self.searchArrayData = [NSMutableArray arrayWithArray:[self.tableArrayData filteredArrayUsingPredicate:resultPredicate]];
    
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellmy" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.titleMeeting = [NSString stringWithFormat:@"全国政协十二届四次会议首场新闻发布会.%ld - %ld",(long)indexPath.section,(long)indexPath.row];
    cell.Lables = @[@"十二大",@"新闻发布",@"人大",@"热议"];
    cell.timeDate = [NSDate date];
    cell.howManyPeople = 2000;
    cell.isInProgress = YES;
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
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    meetingDetailsTableViewController * Details = [[meetingDetailsTableViewController alloc] init];
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
