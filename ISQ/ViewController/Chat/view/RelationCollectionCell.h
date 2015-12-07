//
//  RelationCollectionCell.h
//  ISQ
//
//  Created by mac on 15-4-14.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelationCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *neatManImg;
@property (weak, nonatomic) IBOutlet UIImageView *activityUserImg;
@property (weak, nonatomic) IBOutlet UIImageView *hopPostImg;

//找邻居
@property (weak, nonatomic) IBOutlet UIImageView *nearImg;


@end
