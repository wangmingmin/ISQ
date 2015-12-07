//
//  NeighborsTableCell.m
//  ISQ
//
//  Created by mac on 15-5-14.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "NeighborsTableCell.h"
#import "NeighborsModel.h"
#import "UIImageView+AFNetworking.h"
#import "ImgURLisFount.h"
@implementation NeighborsTableCell
@synthesize friendsImg,neigborsName,alreadyAdd;


-(void)setDataSource:(NSDictionary *)dataSource{
    
    if (_dataSource!=dataSource) {
        
        _dataSource=dataSource;
        
        [self loadData];
    }
    
    
    
}

-(void)setMyAcount:(NSString *)myAcount{
    
    if (_myAcount!=myAcount) {
        
        _myAcount=myAcount;
    }
    
}

-(void)loadData{
    
        NeighborsModel *dataModle=[[NeighborsModel alloc] initWithDataDic:_dataSource];
        
        NSURL *imgUrl=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",dataModle.avatar]];
        
        [self.friendsImg  setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    
        if ([ImgURLisFount TheDataIsImgage:self.friendsImg.image]==2) {
        
        }else{
        self.friendsImg.image=[UIImage imageNamed:@"defuleImg"];
        
        
        }
        self.neigborsName.text=dataModle.nick;
    
    if ([dataModle.isFriend intValue]==0&&![dataModle.account isEqualToString:_myAcount]) {
        
        self.alreadyAdd.hidden=YES;
        self.add_ol.hidden=NO;
 
    }else{
        self.alreadyAdd.hidden=NO;
        self.add_ol.hidden=YES;
        
        
        
    }
    
    
}


- (void)awakeFromNib {
   

    self.friendsImg.layer.cornerRadius=3.0f;
    self.friendsImg.layer.masksToBounds=YES;
    self.friendsImg.layer.borderWidth=0.3f;
    self.friendsImg.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.3f].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)add_bt:(id)sender {
    
    
    
}
- (IBAction)frindFriend_bt:(id)sender {
}
@end
