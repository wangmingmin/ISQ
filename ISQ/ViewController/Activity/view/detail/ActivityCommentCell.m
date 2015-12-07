//
//  ActivityCommentCell.m
//  ISQ
//
//  Created by Mac_SSD on 15/10/16.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "ActivityCommentCell.h"
#import "ActivityDetailModel.h"
@interface ActivityCommentCell (){
    
    UIView *commentView;
    
}

@end

@implementation ActivityCommentCell



//+(instancetype)cellWithTableView:(UITableView*)tableView{
//    
//    static NSString *ID=@"ActivityCommentCell";
//    ActivityCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        
//        cell=[[ActivityCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    return cell;
//}


- (void)awakeFromNib {
    // Initialization code
    
    self.contentView.backgroundColor=[UIColor hexStringToColor:@"#DBE1E3" alpha:1];
   
    
    commentView=[[UIView alloc]init];
    commentView.backgroundColor=[UIColor whiteColor];
    commentView.x=8;
    commentView.y=0;
    commentView.width=UISCREENWIDTH-16;
    
    
    //头像
    _headImg=[[UIImageView alloc]init];
    _headImg.x=8+10;
    _headImg.y=12.5;
    _headImg.width=35;
    _headImg.height=35;
    
    //ownName
    _ownName=[[UILabel alloc]init];
    _ownName.x=_headImg.x+_headImg.width+10;
    _ownName.y=12.5;
    _ownName.height=15;
    _ownName.font =[UIFont fontWithName:@"Helvetica" size:15];
    _ownName.textColor=[UIColor hexStringToColor:@"#9B9B9B" alpha:1];
    
    //回复Label
    _replyLabel=[[UILabel alloc]init];
    _replyLabel.y=12.5;
    _replyLabel.width=31;
    _replyLabel.height=15;
    _replyLabel.font =[UIFont fontWithName:@"Helvetica" size:15];
    
    
    //otherName
    _otherName=[[UILabel alloc]init];
    _otherName.y=12.5;
    _otherName.height=15;
    _otherName.font =[UIFont fontWithName:@"Helvetica" size:15];
    _otherName.textColor=[UIColor hexStringToColor:@"#9B9B9B" alpha:1];
    
    //时间
    _timeLabel=[[UILabel alloc]init];
    _timeLabel.font =[UIFont fontWithName:@"Helvetica" size:11];
    _timeLabel.y=13;
    _timeLabel.width=100;
    _timeLabel.height=13;
    _timeLabel.textColor=[UIColor hexStringToColor:@"#9B9B9B" alpha:0.95];
    
    //评论内容
    _contentLabel=[[UILabel alloc]init];
    _contentLabel.numberOfLines=0;
    _contentLabel.x=_headImg.x+_headImg.width+10;
    _contentLabel.y=35;
    _contentLabel.width=UISCREENWIDTH-_contentLabel.x-16;
    _contentLabel.font =[UIFont fontWithName:@"Helvetica" size:15];
   
    
    _sendButton=[[UIButton alloc]init];
    _sendButton.width=28;
    _sendButton.height=14;
    _sendButton.x=UISCREENWIDTH-28-8-8-11;
    _sendButton.y=12.5;
    _sendButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    [_sendButton setTitle:@"回复" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor hexStringToColor:@"#F86A8D" alpha:1] forState:UIControlStateNormal];
    
    [commentView addSubview:_sendButton];
    [commentView addSubview:_timeLabel];
    [commentView addSubview:_headImg];
    [commentView addSubview:_ownName];
    [commentView addSubview:_contentLabel];
    [self addSubview:commentView];
    
}

-(void)setArryList:(NSDictionary *)arryList{
    
    
    ActivityDetailModel *data=[ActivityDetailModel objectWithKeyValues:arryList];
    NSString  *img1=@"http://avatar.app.wisq.cn/group/76561997126173104.png";
    //头像
    NSURL *headImgUrl=[[NSURL alloc]initWithString:(data.userFace?[NSString stringWithFormat:@"http://web.app.wisq.cn:8080/avatar/%@",data.userFace]:img1)];
    [_headImg setImageWithURL:headImgUrl placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    
    //ownName
    _ownName.width=[UILabel getLabelHeight:data.userName
                                theUIlabel:_ownName].width;
    _ownName.text=data.userName;
    
    //回复Label
    _replyLabel.x=8+_ownName.x+_ownName.width;
    
    //otherName
    _otherName.x=_replyLabel.x+26+8;
    _otherName.width=[UILabel getLabelHeight:(data.otherName?data.otherName:@"") theUIlabel:_otherName].width;
    
    if( data.isReply &&[data.isReply isEqualToString:@"YES"] ){
        
        _replyLabel.text=@"回复";
        _otherName.text=data.otherName;
        
        [commentView addSubview:_replyLabel];
        [commentView addSubview:_otherName];
        
    }else {
        _otherName.x=_ownName.x;
        _otherName.width=_ownName.width;
        
        
    }
    
    //评论内容
    _contentLabel.text=data.content;
    _contentLabel.height=[UILabel getLabelHeight:data.content theUIlabel:_contentLabel].height;
   
    
    //总的view
    commentView.height=35+_contentLabel.height+12.5;
    
    
    //时间
    _timeLabel.x=_otherName.x+_otherName.width+8;
    _timeLabel.text=data.time;
    
    
    if(arryList.count>0){
        //线条
        [self addSubview:[UIView lineWidth:commentView.width lineHeight:1 lineColor:[UIColor hexStringToColor:@"#DBE1E3" alpha:1] lineX:8 lineY:commentView.height-1]];
    }
    
   
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
