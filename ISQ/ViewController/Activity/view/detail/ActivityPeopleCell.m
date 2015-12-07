//
//  ActivityPeopleCell.m
//  ISQ
//
//  Created by Mac_SSD on 15/10/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "ActivityPeopleCell.h"


@interface ActivityPeopleCell (){
    
    UILabel *numberLabel;
    UILabel *people;
    UIView *contentV;
}

@end
@implementation ActivityPeopleCell

+(instancetype)cellWithTableView:(UITableView*)tableView{
    
    static NSString *ID=@"ActivityNumberOfPeople";
    ActivityPeopleCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell=[[ActivityPeopleCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)setArrayList:(NSArray *)arrayList{
    
    
    
    
   
    //+2表示会有表情的出现（表情一般比文字高）
    people.height=[arrayList[0] floatValue];
    people.text=arrayList[2];
    numberLabel.text=arrayList[1];
    //view
    contentV.height=people.height+10;
    
    if ((contentV.height+10-2)>18) {
        //分割线
        [self addSubview:[UIView lineWidth:UISCREENWIDTH-16 lineHeight:2 lineColor:[UIColor hexStringToColor:@"#3FB8F9" alpha:1] lineX:8 lineY:contentV.height+10-2]];
        
    }
    
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor=[UIColor hexStringToColor:@"#DBE1E3" alpha:1];
        contentV=[[UIView alloc]init];
        contentV.x=8;
        contentV.y=8;
        contentV.width=UISCREENWIDTH-16;
        contentV.backgroundColor =[UIColor whiteColor];
        
        
        
        UIFont *font=[UIFont fontWithName:@"Helvetica" size:15];
        
        //人数
        numberLabel=[[UILabel alloc]init];
        numberLabel.textColor=[UIColor hexStringToColor:@"#FB4876" alpha:1];
        numberLabel.font=font;
        numberLabel.x=18;
        numberLabel.y=13;
        numberLabel.width=20;
        numberLabel.height=15;
        //人员
        people=[[UILabel alloc]init];
        people.textColor=[UIColor hexStringToColor:@"#9B9B9B" alpha:1];
        people.font=font;
        people.x=40;
        people.y=8;
        people.width=UISCREENWIDTH-40-16;
        people.numberOfLines=0;
        
        [contentV addSubview:numberLabel];
        
        [contentV addSubview:people];
        
        [self.contentView addSubview:contentV];
        
       
        
    }
    
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
