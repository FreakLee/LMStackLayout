//
//  LMPhotoCollectionViewCell.h
//  LMStackLayout
//
//  Created by Lyman on 16/8/27.
//  Copyright © 2016年 Lyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMPhotoCollectionViewCell;
typedef NS_ENUM(NSUInteger, LMPhotoAttitude) {
    LMPhotoAttitudeNormal,
    LMPhotoAttitudeLike,
    LMPhotoAttitudeUnlike,
};

@protocol PhotoCollectionViewCellDelegate <NSObject>

- (void)photoCollectionViewCell:(LMPhotoCollectionViewCell *)photoCell didShowAttitude:(LMPhotoAttitude)photoAttitude;
@end

@interface LMPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, weak) id <PhotoCollectionViewCellDelegate> delegate;
@end
