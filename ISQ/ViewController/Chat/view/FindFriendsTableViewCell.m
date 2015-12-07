//
//  FindFriendsTableViewCell.m
//  ISQ
//
//  Created by mac on 15-7-23.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "FindFriendsTableViewCell.h"
#import "FindFriendsModel.h"
#import "UIImageView+AFNetworking.h"
#import "ImgURLisFount.h"
@implementation FindFriendsTableViewCell

@synthesize friendsImg,theName,alreadyAdd;


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
    
    FindFriendsModel *dataModle=[[FindFriendsModel alloc]initWithDataDic:_dataSource];
    
    if ([dataModle.status intValue]==0||[_myAcount isEqualToString:dataModle.user]) {
        
        
        self.alreadyAdd.hidden=NO;
        self.add_ol.hidden=YES;
        
        
        
    }else if([dataModle.status intValue]==1){
        self.alreadyAdd.hidden=YES;
        self.add_ol.hidden=NO;
        [self.add_ol setBackgroundImage:[UIImage imageNamed:@"Neighbors4"] forState:UIControlStateNormal];
        [self.add_ol setTitle:@"添加" forState:UIControlStateNormal];
        [self.add_ol setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
       
        
    }else if([dataModle.status intValue]==2){
        self.alreadyAdd.hidden=YES;
        self.add_ol.hidden=NO;
        
        [self.add_ol setBackgroundImage:[UIImage imageNamed:@"Neighbors5"] forState:UIControlStateNormal];
        [self.add_ol setTitle:@"邀请" forState:UIControlStateNormal];
       
        [self.add_ol setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
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
