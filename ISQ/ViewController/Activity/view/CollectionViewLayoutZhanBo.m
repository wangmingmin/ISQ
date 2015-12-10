//
//  CollectionViewLayoutZhanBo.m
//  chuanwanList
//
//  Created by 123 on 15/12/4.
//  Copyright © 2015年 wang. All rights reserved.
//

#import "CollectionViewLayoutZhanBo.h"
#define adjustment 43//微调一下高度
@implementation CollectionViewLayoutZhanBo
-(CGSize)collectionViewContentSize
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    float width = self.collectionView.bounds.size.width;
    float height= (8+(width-24)/2.0+adjustment)*(count/2+count%2)+8;
    CGSize  size = CGSizeMake(width, height);
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
#pragma mark - UICollectionViewLayout
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = (screenWidth-24)/2.0;
    float height = width+adjustment;
    attributes.center = CGPointMake(8+width/2.0+(indexPath.row%2)*(width+8),8+height/2.0+(indexPath.row/2)*(height+8));
    attributes.size = CGSizeMake(width, height);
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    if ([arr count] >0) {
        return arr;
    }
    
    NSMutableArray* attributes = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int j = 0; j<count; j++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }

    return attributes;
}

@end
