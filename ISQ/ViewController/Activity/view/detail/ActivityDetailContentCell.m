//
//  ActivityDetailContentCell.m
//  ISQ
//
//  Created by Mac_SSD on 15/10/15.
//  Copyright © 2015年 cn.ai-shequ. All rights reserved.
//

#import "ActivityDetailContentCell.h"
#import "DWCustomPlayerViewController.h"

@interface ActivityDetailContentCell (){
    
    UIView *detailContentView;
    CGFloat lableHeight;
    NSString *videoID;
    DWCustomPlayerViewController *playVC;
    
}

@end
@implementation ActivityDetailContentCell


+(instancetype)cellWithTableView:(UITableView*)tableView{
    
    static NSString *ID=@"ActivityDetailContent";
    ActivityDetailContentCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell=[[ActivityDetailContentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
   
    
    return cell;
}

-(void)setArrayList:(NSArray *)arrayList{
    

    //label高度
    _contentLable.x=UISCREENWIDTH*0.16;
    _contentLable.text=arrayList[0];
    _contentLable.y=0;
    _contentLable.width=UISCREENWIDTH-_contentLable.x-16;
    //+2表示会有表情的出现（表情一般比文字高）
    _contentLable.height=[arrayList[0] floatValue];
    _contentLable.text=arrayList[2];
    //view
    detailContentView.height=[arrayList[1] floatValue];
    
    //图片
    
    _img1.width=UISCREENWIDTH*0.2;
    _img1.height=UISCREENWIDTH*0.2;
    _img1.x=_contentLable.x;
    _img1.y=_contentLable.y+_contentLable.height+12;
    
    
    if(arrayList[6]&&![self isNullString:arrayList[6]]){
        _img1.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMovies:)];
        [_img1 addGestureRecognizer:singleTap1];
        
    UIImageView *videoImg2=[[UIImageView alloc]init];
    videoImg2.width=30;
    videoImg2.height=30;
    videoImg2.x=_img1.width/2-15;
    videoImg2.y=_img1.height/2-15;
    videoImg2.image=[UIImage imageNamed:@"mideoImg"];
    videoID=arrayList[6];
    
        
    [_img1 addSubview:videoImg2];
    
    
    }
    
    _img2.width=UISCREENWIDTH*0.2;
    _img2.height=UISCREENWIDTH*0.2;
    _img2.x=_img1.x+_img1.width+15;
    _img2.y=_contentLable.y+_contentLable.height+12;
    
    
    _img3.width=UISCREENWIDTH*0.2;
    _img3.height=UISCREENWIDTH*0.2;
    _img3.x=_img2.x+_img2.width+15;
    _img3.y=_contentLable.y+_contentLable.height+12;
    
    //头像
    NSURL *headImgUrl1=[[NSURL alloc]initWithString:arrayList[3]];
    [_img1 setImageWithURL:headImgUrl1 placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    NSURL *headImgUrl2=[[NSURL alloc]initWithString:arrayList[4]];
    [_img2 setImageWithURL:headImgUrl2 placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    NSURL *headImgUrl3=[[NSURL alloc]initWithString:arrayList[5]];
    [_img3 setImageWithURL:headImgUrl3 placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        detailContentView=[[UIView alloc]init];
        detailContentView.x=8;
        detailContentView.width=UISCREENWIDTH-16;
        detailContentView.backgroundColor=[UIColor whiteColor];
        
        self.contentView.backgroundColor=[UIColor hexStringToColor:@"#DBE1E3" alpha:1];
        _contentLable=[[UILabel alloc]init];
        _contentLable.numberOfLines=0;
        [detailContentView addSubview:_contentLable];
        [self.contentView addSubview:detailContentView];
        
        _img1=[[UIImageView alloc]init];
        _img2=[[UIImageView alloc]init];
        _img3=[[UIImageView alloc]init];
        
        [detailContentView addSubview:_img1];
        [detailContentView addSubview:_img2];
        [detailContentView addSubview:_img3];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    
    
}
- (BOOL) isNullString:(NSString *)string {
    
    string=[NSString stringWithFormat:@"%@",string];
    
    if (string.length<=6) {
        
        return YES;
        
    }
    
    return NO;
    
}

//观看视频
-(void)toMovies:(UIButton*)btn{
    
    playVC=[[DWCustomPlayerViewController alloc]init];
    playVC.videoId=videoID;
    [playVC setHidesBottomBarWhenPushed:YES];
    
     [[self viewController].navigationController pushViewController:playVC animated:YES];
    
}

- (UIViewController *)viewController {
    id vc = [self nextResponder];
    while (vc) {
        if ([vc isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)vc;
        }
        vc = [vc nextResponder];
    }
    return nil;
}
@end
