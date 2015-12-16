//
//  searchTableViewController.m
//  ISQ
//
//  Created by 123 on 15/12/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "searchTableViewController.h"
#import "ISQHttpTool.h"

@interface searchTableViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController * searchDisplayController;
@property (strong, nonatomic) NSArray * dataSearch;
@end

@implementation searchTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchBar.delegate = self;
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];

    NSString * stringType = @"";
    if ([self.type isEqualToString:@"city"]) stringType = @"当前市节目搜索";
    if ([self.type isEqualToString:@"special"]) stringType = @"专场节目搜索";
    if ([self.type isEqualToString:@"rank"]) stringType = @"排行榜节目搜索";
    if ([self.type isEqualToString:@"follow"]) stringType = @"我关注节目搜索";
    self.title = stringType;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSearch.count;
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
    
    
    // Configure the cell...
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        [cell.textLabel setText:@"searchDisplayController"];
        
    }
    else{
        [cell.textLabel setText:@"tableView"];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * httpStr = [NSString stringWithFormat:@"%@type=%@",getSpringVideoListServer,self.type];
    
    NSMutableDictionary *parames=[NSMutableDictionary dictionary];
    
    if ([self.type isEqualToString:@"city"]) {
        id cityID = [user_info objectForKey:userCityID];
        parames[@"cityId"]=cityID;
    }
    if ([self.type isEqualToString:@"follow"]) {
        id userAccountNumber = [user_info objectForKey:userAccount];
        parames[@"userAccount"]=userAccountNumber;
    }

    NSInteger rowsCount = 0;
    parames[@"rows"] =[NSString stringWithFormat:@"%ld",(long)rowsCount];

    parames[@"title"] =searchBar.text;//标题(加标题字段为搜索接口)

    [ISQHttpTool getHttp:httpStr contentType:nil params:parames success:^(id res) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:res options:NSJapaneseEUCStringEncoding error:nil];
        NSLog(@"search item dic = %@",dic);
        NSArray * data = dic[@"retData"];
        if (data.count == 0) {
            
        }else {
            self.dataSearch = [[NSArray alloc] initWithArray:data];
            [self.tableView reloadData];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    } failure:^(NSError *erro) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"查询失败" message:@"稍后请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
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
