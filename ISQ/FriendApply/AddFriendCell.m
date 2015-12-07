/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "AddFriendCell.h"
#import "UIImageView+EMWebCache.h"
#import "ImgURLisFount.h"
@implementation AddFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _addLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 60+10, 0, 50, 30)];
        _addLabel.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0];
        _addLabel.textAlignment = NSTextAlignmentCenter;
        _addLabel.text = NSLocalizedString(@"add", @"Add");
        _addLabel.textColor = [UIColor whiteColor];
        _addLabel.font = [UIFont systemFontOfSize:14.0];
        
        
        [self.contentView addSubview:_addLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
    
    if ([ImgURLisFount TheDataIsImgage:self.imageView.image]==2) {
        
        
    }else{
        
        self.imageView.image=[UIImage imageNamed:@"defuleImg"];
    }
    
    
    self.imageView.frame = CGRectMake(10, 7, 45, 45);
    
    self.imageView.layer.cornerRadius=4.0f;
    self.imageView.layer.masksToBounds=YES;

    
    CGRect rect = self.textLabel.frame;
    rect.size.width -= 70;
    self.textLabel.frame = rect;
    
    rect = _addLabel.frame;
    rect.origin.y = (self.frame.size.height - 30) / 2;
    _addLabel.frame = rect;
}

@end
