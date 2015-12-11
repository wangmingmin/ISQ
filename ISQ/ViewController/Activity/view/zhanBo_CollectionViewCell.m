//
//  zhanBo_CollectionViewCell.m
//  chuanwanList
//
//  Created by 123 on 15/12/4.
//  Copyright © 2015年 wang. All rights reserved.
//

#import "zhanBo_CollectionViewCell.h"
@interface zhanBo_CollectionViewCell()
@property (strong, nonatomic) UILabel * voteString;
@end

@implementation zhanBo_CollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.title = [[UILabel alloc] init];
        self.title.frame = CGRectMake(3, 2, frame.size.width-6, 30);
        self.title.textColor = [UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1];
        [self addSubview:self.title];

        self.address = [[UILabel alloc] init];
        self.address.frame = CGRectMake(3,2+self.title.frame.size.height, frame.size.width-6, 15);
        self.address.textColor = [UIColor colorWithRed:132.0/255 green:132.0/255 blue:132.0/255 alpha:1];
        self.address.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.address];
        
        self.voteString = [[UILabel alloc] init];
        self.voteString.frame = CGRectMake(3, frame.size.height-50, 30, 50);
        self.voteString.textColor = [UIColor colorWithRed:132.0/255 green:132.0/255 blue:132.0/255 alpha:1];
        self.voteString.font = [UIFont systemFontOfSize:12];
        self.voteString.text = @"得票:";
        [self addSubview:self.voteString];

        self.voteNum = [[UILabel alloc] init];
        self.voteNum.frame = CGRectMake(3+self.voteString.frame.size.width, frame.size.height-50, 90, 50);
        self.voteNum.textColor = [UIColor colorWithRed:116.0/255 green:0.0/255 blue:0.0/255 alpha:1];
        self.voteNum.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.voteNum];

        CGFloat imageOriginY = self.address.frame.origin.y + self.address.frame.size.height + 8;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageOriginY, frame.size.width, frame.size.height-imageOriginY-self.voteNum.frame.size.height)];//120:90
        [self addSubview:self.imageView];

        self.shareBtn = [[UIButton alloc] init];
        self.shareBtn.frame = CGRectMake(frame.size.width-70, frame.size.height-50, 70, 50);
        [self.shareBtn setTitleColor:[UIColor colorWithRed:132.0/255 green:132.0/255 blue:132.0/255 alpha:1] forState:UIControlStateNormal];
        [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        UIImage * image = [UIImage imageNamed:@"share"];
        [self.shareBtn setImage:image forState:UIControlStateNormal];
        self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.shareBtn];

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
