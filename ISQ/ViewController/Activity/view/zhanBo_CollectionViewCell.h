//
//  zhanBo_CollectionViewCell.h
//  chuanwanList
//
//  Created by 123 on 15/12/4.
//  Copyright © 2015年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhanBo_CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * voteNum;//得票
@property (strong, nonatomic) UIButton * shareBtn;
@end
