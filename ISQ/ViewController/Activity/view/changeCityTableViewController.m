//
//  changeCityTableViewController.m
//  ISQ
//
//  Created by 123 on 15/12/24.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "changeCityTableViewController.h"
#import "ISQHttpTool.h"
@interface changeCityTableViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController * searchDisplayController;
@property (strong, nonatomic) NSArray * tableArrayData;
@property (strong, nonatomic) NSArray * searchArrayData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarProvince;
@end

@implementation changeCityTableViewController
{
    BOOL isCityList;//是否进入到市区级别的选择
    int pid;
    int cid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    self.tableView.tableHeaderView = self.searchBar;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    isCityList = NO;
    
    self.tableArrayData = [[NSArray alloc] init];
    self.searchArrayData = [[NSArray alloc] init];
    
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchBar.delegate = self;
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onChooseProvince:(UIBarButtonItem *)sender {
    isCityList = NO;
    [self refresh];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==self.tableView) {//加上当前市
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchArrayData.count;
    }
    if (section==0 && tableView==self.tableView){
        return 1;//当前市
    }
    return self.tableArrayData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    cell.backgroundColor = [UIColor whiteColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];

    // Configure the cell...
    if (isCityList) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (tableView==self.searchDisplayController.searchResultsTableView) {
            NSDictionary * tableDic = self.searchArrayData[indexPath.row];
            [cell.textLabel setText:tableDic[@"cityName"]];
            cell.tag = [tableDic[@"cityId"] integerValue];
        }
        else{
            if (indexPath.section==0) {//当前市
                [cell.textLabel setText:@"选择当前所在市区"];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.tag=0;
                return cell;
            }
            NSDictionary * tableDic = self.tableArrayData[indexPath.row];
            [cell.textLabel setText:tableDic[@"cityName"]];
            cell.tag = [tableDic[@"cityId"] integerValue];
        }

    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        if (tableView==self.searchDisplayController.searchResultsTableView) {
            NSDictionary * tableDic = self.searchArrayData[indexPath.row];
            [cell.textLabel setText:tableDic[@"provinceName"]];
            cell.tag = [tableDic[@"provinceId"] integerValue];
        }
        else{
            if (indexPath.section==0) {//当前市
                [cell.textLabel setText:@"选择当前所在市区"];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.tag=0;
                return cell;
            }
            NSDictionary * tableDic = self.tableArrayData[indexPath.row];
            [cell.textLabel setText:tableDic[@"provinceName"]];
            cell.tag = [tableDic[@"provinceId"] integerValue];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag==0) {
        [self.delegate changeCityOkWithProvinceID:0 andCityID:0];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSDictionary * choosedDic;
    if (tableView == self.tableView) {
        choosedDic = self.tableArrayData[indexPath.row];
    }else{
        choosedDic = self.searchArrayData[indexPath.row];
    }
    
    if (isCityList) {
        cid = (int)cell.tag;
        [self.delegate changeCityOkWithProvinceID:pid andCityID:cid];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        pid = (int)cell.tag;
        isCityList = YES;
        [self.searchDisplayController setActive:NO animated:YES];
        [self refresh];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (isCityList) {
        isCityList = NO;
        [self refresh];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)refresh
{
    NSString * provinceUrl = @"http://121.41.18.126:8080/isqbms/getAllProvince.from";
    if (isCityList) {
      provinceUrl = [NSString stringWithFormat:@"http://121.41.18.126:8080/isqbms/getCityByPid.from?pid=%d",pid];
        self.searchBarProvince.title = @"选择省";
        self.searchBarProvince.enabled = YES;

    }else{
        self.searchBarProvince.title = @"";
        self.searchBarProvince.enabled = NO;

    }
    [ISQHttpTool getHttp:provinceUrl contentType:nil params:nil success:^(id res) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
        self.tableArrayData = dic[@"retData"];
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"城市列表延迟，稍后请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.provinceName CONTAINS[cd] %@",searchText];
    if (isCityList) {
        resultPredicate = [NSPredicate predicateWithFormat:@"SELF.cityName CONTAINS[cd] %@",searchText];
    }
    self.searchArrayData = [self.tableArrayData filteredArrayUsingPredicate:resultPredicate];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

//当文本内容发生改变时候，向表视图数据源发出重新加载消息
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
    
    return YES;
}

// 当Scope Bar选择发送变化时候，向表视图数据源发出重新加载消息
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:searchOption]];
    
    return YES;
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
