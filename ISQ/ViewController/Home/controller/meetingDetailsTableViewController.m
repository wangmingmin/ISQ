//
//  meetingDetailsTableViewController.m
//  chuanwanList
//
//  Created by 123 on 16/3/10.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "meetingDetailsTableViewController.h"
#import "TableViewCellDetails.h"
@interface meetingDetailsTableViewController ()

@end

@implementation meetingDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCellDetails" bundle:nil] forCellReuseIdentifier:@"cellDetails"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;

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
        return 4;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        TableViewCellDetails * cellD = [tableView dequeueReusableCellWithIdentifier:@"cellDetails" forIndexPath:indexPath];
        cellD.detailsMessage = @"【青海团代表向总书记献上哈达，共话民族大团结】10日上午，习近平来到青海代表团参加审议。当总书记走进会场时，藏族、蒙古族、土族3位代表分别向总书记献上洁白的哈达，表达对党中央和总书记的敬意。习近平请他们转达对各族人民的祝福。审议中，几位少数民族代表就民族团结进步、促进城乡教育公平、实施精准扶贫等发言。习近平不时询问具体情况，强调多民族是我国一大特色，是我国发展的一大有利因素。要着力增强民族地区自我发展能力和可持续发展能力，尊重民族差异、包容文化多样，让各民族在中华民族大家庭中手足相亲、守望相助、团结和睦、共同发展。（人民日报全媒体平台记者倪光辉）新华社记者黄敬文摄";
        return cellD;
    }

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
    plan.text = @"备选方案一";
    plan.textColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:plan];
    
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
        labelState.text = @"进行中";
        labelState.textColor = [UIColor whiteColor];
        labelState.textAlignment = NSTextAlignmentCenter;
        labelState.font = [UIFont systemFontOfSize:12];
        labelState.layer.cornerRadius = labelState.frame.size.height/2.0;
        labelState.layer.masksToBounds = YES;
        labelState.backgroundColor = [UIColor orangeColor];
        [headerView addSubview:labelState];
        
        UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(labelState.frame.origin.x + labelState.frame.size.width + 10, labelState.center.y-15, self.view.frame.size.width-(labelState.frame.origin.x + labelState.frame.size.width + 10), 30)];
        labelTitle.text = @"全国政协十二届四次会议首场新闻发布会";
        labelTitle.font = [UIFont systemFontOfSize:17];
        [headerView addSubview:labelTitle];

        UILabel * timeStart = [[UILabel alloc] initWithFrame:CGRectMake(labelState.frame.origin.x, headerView.frame.size.height/2.0-10, 200, 20)];
        timeStart.text = @"发起时间：2016-05-12";
        timeStart.textColor = [UIColor lightGrayColor];
        timeStart.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:timeStart];
        
        UILabel * timeEnd = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width-180, headerView.frame.size.height/2.0-10, 180, 20)];
        timeEnd.text = @"结束时间：2016-05-12";
        timeEnd.textColor = [UIColor lightGrayColor];
        timeEnd.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:timeEnd];

        int width = 60;
        NSArray * colors = @[[UIColor blackColor],[UIColor redColor],[UIColor blueColor],[UIColor greenColor]];
        NSArray * Lables = @[@"十二大",@"新闻发布",@"人大",@"热议"];
        [Lables enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(labelState.frame.origin.x + idx * (width+15), headerView.frame.size.height-38, width, 25)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:13];
                label.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
                label.layer.borderWidth = 0.7;
                label.layer.cornerRadius = 4;
                label.layer.masksToBounds = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    label.text = (NSString *)obj;
                    label.textColor = colors[idx];
                    [headerView addSubview:label];
                });
            });
        }];

        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.8, headerView.frame.size.width, 0.8)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [headerView addSubview:line];
    }else if(section==1){
        UIImageView * imageviewCount = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50/2.0-30/2.0, 110, 30)];
        imageviewCount.image = [self drawImageCoustem:imageviewCount.frame withColor:[UIColor colorWithRed:60.0/255.0 green:183.0/255.0 blue:250.0/255.0 alpha:1]];
        [headerView addSubview:imageviewCount];
        
        UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, imageviewCount.frame.size.width-20-6, imageviewCount.frame.size.height)];
        countLabel.text = @"3252人参与";
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
