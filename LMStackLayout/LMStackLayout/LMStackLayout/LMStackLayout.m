//
//  LMStackLayout.m
//  LMStackLayout
//
//  Created by Lyman on 16/8/27.
//  Copyright © 2016年 Lyman. All rights reserved.
//

#import "LMStackLayout.h"
static const CGFloat kMargin = 10;

@implementation LMStackLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat dealt = indexPath.item * 3;
    
    CGFloat width = (self.collectionView.frame.size.width - 2*kMargin) - 2 * dealt;
    CGFloat height = width*0.666 + 40;
    attrs.size = CGSizeMake(width, height);
    attrs.center = CGPointMake(self.collectionView.frame.size.width * 0.5, self.collectionView.frame.size.height * 0.5 + 2 * dealt);

    if (indexPath.item >= 3) {
        attrs.hidden = YES;
    } else {
        attrs.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;
    }
    return attrs;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    return array;
}

@end
