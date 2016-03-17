//
//  meetingDetailsTableViewController.m
//  chuanwanList
//
//  Created by 123 on 16/3/10.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "meetingDetailsTableViewController.h"
#import "TableViewCellDetails.h"
#import "ISQHttpTool.h"

@interface meetingDetailsTableViewController ()
@property (strong, nonatomic) NSDictionary * detailsDictionary;
@property (strong, nonatomic) NSArray * optionArray;
@end

@implementation meetingDetailsTableViewController{
    NSInteger ID_Details;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCellDetails" bundle:nil] forCellReuseIdentifier:@"cellDetails"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    [self refresh];
}

-(instancetype)initWithID:(NSInteger)ID
{
    self = [super init];
    if (self) {
        ID_Details = ID;
    }
    return self;
}

-(void)refresh
{
    NSString * httpStr = [NSString stringWithFormat:@"%@?id=%ld&userId=%d",getYSTDetail,ID_Details,[[user_info objectForKey:MyUserID] intValue]];
    [ISQHttpTool getHttp:httpStr contentType:nil params:nil success:^(id resData) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJapaneseEUCStringEncoding error:nil];
//        NSLog(@"detail Dic = %@",dataDic);
        self.detailsDictionary = dataDic[@"retData"];
        self.optionArray = dataDic[@"optionDate"];
        [self.tableView reloadData];
    } failure:^(NSError *erro) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"暂无议事详情,稍后请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.optionArray.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        TableViewCellDetails * cellD = [tableView dequeueReusableCellWithIdentifier:@"cellDetails" forIndexPath:indexPath];
        cellD.detailsMessage = self.detailsDictionary[@"content"];
        return cellD;
    }

    NSDictionary * oneDicOption = self.optionArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else {
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    UILabel * plan = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, cell.contentView.frame.size.height)];
    plan.text = oneDicOption[@"title"];
    plan.textColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:plan];
    
    UILabel * optionCount = [[UILabel alloc] initWithFrame:CGRectMake(plan.frame.origin.x+plan.frame.size.width, 0, 70, plan.frame.size.height)];
    optionCount.text = [NSString stringWithFormat:@"%d人",[oneDicOption[@"count"] intValue]];
    optionCount.textAlignment = NSTextAlignmentRight;
    optionCount.textColor = [UIColor colorWithRed:60.0/255.0 green:183.0/255.0 blue:250.0/255.0 alpha:1];
    [cell.contentView addSubview:optionCount];
    
    NSArray * arrayColor = @[
                            [UIColor colorWithRed:240.0/255.0 green:51.0/255.0 blue:36.0/255 alpha:1],
                            [UIColor colorWithRed:146.0/255.0 green:55.0/255.0 blue:253.0/255.0 alpha:1],
                            [UIColor colorWithRed:238.0/255.0 green:177.0/255.0 blue:0 alpha:1],
                            [UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:255.0/255.0 alpha:1]
    ];
    CGFloat total = [self.detailsDictionary[@"count"] floatValue];
    CGFloat percentage = total==0?0:[oneDicOption[@"count"] floatValue]/total;
    UILabel * labelLineProgress = [[UILabel alloc] initWithFrame:CGRectMake(optionCount.frame.origin.x+optionCount.frame.size.width+8, cell.contentView.frame.size.height/2.0-5, self.view.frame.size.width-(optionCount.frame.origin.x+optionCount.frame.size.width+8)-55, 10)];
    CGRect rectLine = labelLineProgress.frame;
    labelLineProgress.backgroundColor = arrayColor[indexPath.row%arrayColor.count];
    rectLine.size.width = percentage*rectLine.size.width;
    labelLineProgress.frame = rectLine;
    [cell.contentView addSubview:labelLineProgress];
    
    UILabel * percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 0, 35, cell.frame.size.height)];
    percentageLabel.text = [NSString stringWithFormat:@"%.0f%%",percentage*100];
    percentageLabel.font = [UIFont systemFontOfSize:15];
    percentageLabel.textAlignment = NSTextAlignmentRight;
    percentageLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:percentageLabel];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, cell.frame.size.height-16, cell.frame.size.height-16)];
    button.tag = [oneDicOption[@"id"] integerValue];
    [button setImage:[UIImage imageNamed:@"discuss_details_gouN"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"discuss_details_gouS"] forState:UIControlStateSelected];
    button.selected = [oneDicOption[@"isChecked"] boolValue];
    int status = [self.detailsDictionary[@"status"] intValue];
    if (status==1) {
        [button addTarget:self action:@selector(onChooseOption:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.contentView addSubview:button];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 120;
    }else if (section == 1){
        return 50;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 12;
    }else if (section == 1){
        return 0;
    }
    return 0;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return 40;
//    }else if (indexPath.section == 1){
//        return 40;
//    }
//    return 40;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, section==0?120:50)];
    headerView.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UILabel * labelState = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 50, 20)];
        int status = [self.detailsDictionary[@"status"] intValue];
        labelState.text = status==1?@"进行中":(status==0?@"未开始":@"已结束");
        labelState.textColor = [UIColor whiteColor];
        labelState.textAlignment = NSTextAlignmentCenter;
        labelState.font = [UIFont systemFontOfSize:12];
        labelState.layer.cornerRadius = labelState.frame.size.height/2.0;
        labelState.layer.masksToBounds = YES;
        labelState.backgroundColor = status==1?[UIColor orangeColor]:[UIColor lightGrayColor];
        [headerView addSubview:labelState];
        
        UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(labelState.frame.origin.x + labelState.frame.size.width + 10, labelState.center.y-15, self.view.frame.size.width-(labelState.frame.origin.x + labelState.frame.size.width + 10), 30)];
        labelTitle.text = self.detailsDictionary[@"title"];
        labelTitle.font = [UIFont systemFontOfSize:17];
        [headerView addSubview:labelTitle];

        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        UILabel * timeStart = [[UILabel alloc] initWithFrame:CGRectMake(labelState.frame.origin.x, headerView.frame.size.height/2.0-10, 200, 20)];
        NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:[self.detailsDictionary[@"start_time"] longLongValue]];
        NSString * start = [formatter stringFromDate:startDate];
        timeStart.text = [NSString stringWithFormat:@"发起时间：%@",start];
        timeStart.textColor = [UIColor lightGrayColor];
        timeStart.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:timeStart];
        
        UILabel * timeEnd = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width-180, headerView.frame.size.height/2.0-10, 180, 20)];
        NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:[self.detailsDictionary[@"end_time"] longLongValue]];
        NSString * end = [formatter stringFromDate:endDate];
        timeEnd.text = [NSString stringWithFormat:@"结束时间：%@",end];
        timeEnd.textColor = [UIColor lightGrayColor];
        timeEnd.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:timeEnd];

        int width = 60;
        NSArray * colors = @[
                             [UIColor colorWithRed:107.0/255.0 green:108.0/255.0 blue:109.0/255 alpha:1],
                             [UIColor colorWithRed:246.0/255.0 green:97.0/255.0 blue:134.0/255.0 alpha:1],
                             [UIColor colorWithRed:93.0/255.0 green:190.0/255.0 blue:247.0/255.0 alpha:1],
                             [UIColor colorWithRed:125.0/255.0 green:175.0/255.0 blue:134.0/255.0 alpha:1]
                             ];
        NSArray * Lables = [self.detailsDictionary[@"tag"] componentsSeparatedByString:@","];
        [Lables enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(labelState.frame.origin.x + idx * (width+15), headerView.frame.size.height-38, width, 25)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            label.layer.borderWidth = 0.7;
            label.layer.cornerRadius = 4;
            label.layer.masksToBounds = YES;
            label.text = (NSString *)obj;
            label.textColor = colors[idx%colors.count];
            [headerView addSubview:label];
        }];

        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.8, headerView.frame.size.width, 0.8)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [headerView addSubview:line];
    }else if(section==1){
        UIImageView * imageviewCount = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50/2.0-30/2.0, 110, 30)];
        imageviewCount.image = [self drawImageCoustem:imageviewCount.frame withColor:[UIColor colorWithRed:60.0/255.0 green:183.0/255.0 blue:250.0/255.0 alpha:1]];
        [headerView addSubview:imageviewCount];
        
        UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, imageviewCount.frame.size.width-20-6, imageviewCount.frame.size.height)];
        NSInteger count = [self.detailsDictionary[@"count"] integerValue];
        countLabel.text = count==0?@"暂无人参与":[NSString stringWithFormat:@"%ld人参与",count];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont systemFontOfSize:12];
        [imageviewCount addSubview:countLabel];
    }
    return headerView;
}

-(UIImage*)drawImageCoustem:(CGRect)rect withColor:(UIColor *)color
{
    int sides = 6;
    //准备画板
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 0.0);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width-sides, 0);
    CGContextAddLineToPoint(context, rect.size.width-sides, rect.size.height/2.0-sides);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2.0);
    CGContextAddLineToPoint(context, rect.size.width-sides, rect.size.height/2.0+sides);
    CGContextAddLineToPoint(context, rect.size.width-sides, rect.size.height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextFillPath(context);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)onChooseOption:(UIButton *)button
{
    int ID = (int)button.tag;
    NSString * httpStr = [NSString stringWithFormat:@"%@?id=%d&userId=%d",YSTChooseOption,ID,[[user_info objectForKey:MyUserID] intValue]];
    [ISQHttpTool getHttp:httpStr contentType:nil params:nil success:^(id res) {
        button.selected = !button.selected;
    } failure:^(NSError *erro) {
        NSString *title = @"";
        NSString *message = @"选择失败，稍后请重试";
        NSString *cancelButtonTitle = @"确定";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
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
