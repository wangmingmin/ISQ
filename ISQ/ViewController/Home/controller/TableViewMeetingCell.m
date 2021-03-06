//
//  TableViewCell.m
//  cellHeight
//
//  Created by 123 on 16/1/4.
//  Copyright © 2016年 star. All rights reserved.
//

#import "TableViewMeetingCell.h"
//@import GameplayKit;

@interface TableViewMeetingCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewShow;//会议展示图片
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UITextView *titleCell;
@property (weak, nonatomic) IBOutlet UILabel *countPeople;
@property (weak, nonatomic) IBOutlet UIView *labelsView;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWithConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleleadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeleadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lablesViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *blueIcon;//绘制标签

@end

@implementation TableViewMeetingCell

- (void)awakeFromNib {
    // Initialization code
    [self layoutSubviews];
    self.state.layer.cornerRadius = self.state.frame.size.height/2.0;
    self.state.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitleMeeting:(NSString *)titleMeeting
{
    if (titleMeeting == nil) {
        self.titleCell.text = @"";
    }else{
        self.titleCell.text = [NSString stringWithFormat:@"           %@",titleMeeting];
    }
}

-(void)setImageMeeting:(UIImage *)imageMeeting
{
    if (imageMeeting == nil) {
        self.imageWithConstraint.constant = self.stateLeadingConstraint.constant=self.titleleadingConstraint.constant=self.timeleadingConstraint.constant=self.lablesViewLeadingConstraint.constant=0;
    }else if(imageMeeting != nil){
        self.imageWithConstraint.constant =90;
        self.stateLeadingConstraint.constant=17;
        self.titleleadingConstraint.constant=11;
        self.timeleadingConstraint.constant=self.lablesViewLeadingConstraint.constant=15;
        self.imageViewShow.image = imageMeeting;
    }
}

-(void)setIsInProgress:(int)isInProgress
{
    if (isInProgress==2 || isInProgress==0) {
        self.state.backgroundColor = [UIColor lightGrayColor];
        self.state.text = isInProgress==2?@"已结束":@"未开始";
        UIImage * image = [self drawImageCoustem:self.blueIcon.frame withColor:[UIColor lightGrayColor]];
        self.blueIcon.image = image;

    }else if(isInProgress==1){
        self.state.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:136.0/255.0 blue:68.0/255.0 alpha:1];
        self.state.text = @"进行中";
        UIImage * image = [self drawImageCoustem:self.blueIcon.frame withColor:[UIColor colorWithRed:60.0/255.0 green:183.0/255.0 blue:250.0/255.0 alpha:1]];
        self.blueIcon.image = image;
    }
}

-(void)setHowManyPeople:(NSInteger)howManyPeople
{
    self.countPeople.text = howManyPeople==0?@"暂时未公布":[NSString stringWithFormat:@"%ld人参与",howManyPeople];
}

-(void)setTimeDate:(NSDate *)timeDate
{
    if (timeDate == nil) {
        self.time.text = @"时间未定";
    }else {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * dateString = [dateFormatter stringFromDate:timeDate];
        self.time.text = [NSString stringWithFormat:@"发起时间：%@",dateString];
    }
}

-(void)setLables:(NSArray *)Lables
{
    [self.labelsView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (Lables.count == 0 || Lables== nil) {
        self.labelsView.backgroundColor = self.backgroundColor;
    }else {
        int width = 60;
        NSArray * colors = @[
                             [UIColor colorWithRed:107.0/255.0 green:108.0/255.0 blue:109.0/255 alpha:1],
                             [UIColor colorWithRed:246.0/255.0 green:97.0/255.0 blue:134.0/255.0 alpha:1],
                             [UIColor colorWithRed:93.0/255.0 green:190.0/255.0 blue:247.0/255.0 alpha:1],
                             [UIColor colorWithRed:125.0/255.0 green:175.0/255.0 blue:134.0/255.0 alpha:1]
                             ];
//        colors = [[GKRandomSource sharedRandom] arrayByShufflingObjectsInArray:colors];
        
        [Lables enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(idx * (width+15), 0, width, self.labelsView.frame.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            label.layer.borderWidth = 0.7;
            label.layer.cornerRadius = 4;
            label.layer.masksToBounds = YES;
            label.text = (NSString *)obj;
            label.textColor = colors[idx%colors.count];
            [self.labelsView addSubview:label];
        }];
    }
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
    CGContextMoveToPoint(context, sides, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(context, sides, rect.size.height);
    CGContextAddLineToPoint(context, sides, rect.size.height/2.0+sides);
    CGContextAddLineToPoint(context, 0, rect.size.height/2.0);
    CGContextAddLineToPoint(context, sides, rect.size.height/2.0-sides);
    CGContextAddLineToPoint(context, sides, 0);
    CGContextFillPath(context);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
