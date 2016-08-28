//
//  LMPhotoCollectionViewCell.m
//  LMStackLayout
//
//  Created by Lyman on 16/8/27.
//  Copyright © 2016年 Lyman. All rights reserved.
//

#define ACTION_MARGIN 80
#define SCALE_STRENGTH 4
#define SCALE_MAX 0.93
#define ROTATION_MAX 1
#define ROTATION_STRENGTH 320
#define ROTATION_ANGLE M_PI/8

#import "LMPhotoCollectionViewCell.h"

@interface LMPhotoCollectionViewCell () {
    CGFloat _xFromCenter;
    CGFloat _yFromCenter;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign)CGPoint originalPoint;
@property (nonatomic, assign)LMPhotoAttitude photoAttitude;
@end

@implementation LMPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.photoAttitude = LMPhotoAttitudeNormal;
    
    if (_panGestureRecognizer == nil) {
      _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startDragging:)];
    }
    [self addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - setter
- (void)setImageName:(NSString *)imageName {
    
    if (_imageName != imageName) {
        _imageName = [imageName copy];
    }
    self.imageView.image = [UIImage imageNamed:_imageName];
    self.infoLabel.text = [NSString stringWithFormat:@"%@  Normal",_imageName];
}

#pragma mark - private
- (void)updateInfoLableWithAttitude:(LMPhotoAttitude)attitude {
    
    NSString *attitudeString;
    switch (attitude) {
        case LMPhotoAttitudeNormal: {
            attitudeString = @"Normal";
            break;
        }
        case LMPhotoAttitudeLike: {
            attitudeString = @"Like";
            break;
        }
        case LMPhotoAttitudeUnlike: {
            attitudeString = @"Unlike";
            break;
        }
    }
    self.infoLabel.text = [NSString stringWithFormat:@"%@   %@",_imageName,attitudeString];
}

#pragma mark - UIPanGestureRecognizer
-(void)startDragging:(UIPanGestureRecognizer *)gestureRecognizer {
    
    _xFromCenter = [gestureRecognizer translationInView:self].x; // 负左，正右
    _yFromCenter = [gestureRecognizer translationInView:self].y; // 负上，正下
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible: {
            break;
        }
        case UIGestureRecognizerStateBegan: {
            self.originalPoint = self.center;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat rotationStrength = MIN(_xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);

            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);

            CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);

            self.center = CGPointMake(self.originalPoint.x + _xFromCenter, self.originalPoint.y + _yFromCenter);
            
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            [self updateInfoLabel:_xFromCenter];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        case UIGestureRecognizerStateFailed: {
            
            break;
        }
    }
}

-(void)updateInfoLabel:(CGFloat)distance
{
    if (distance >= ACTION_MARGIN) {
        self.infoLabel.text = [NSString stringWithFormat:@"%@   Like",_imageName];
    } else if (distance <= -ACTION_MARGIN) {
        self.infoLabel.text = [NSString stringWithFormat:@"%@   Unlike",_imageName];
    } else {
        self.infoLabel.text = [NSString stringWithFormat:@"%@   Normal",_imageName];
    }
}

- (void)afterSwipeAction
{
    LMPhotoAttitude attitude;
    if (_xFromCenter > ACTION_MARGIN) {
        attitude = LMPhotoAttitudeLike;
    } else if (_xFromCenter < -ACTION_MARGIN) {
        attitude = LMPhotoAttitudeUnlike;
    } else {
        attitude = LMPhotoAttitudeNormal;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                         }];
    }
    [self showPhotoAttitude:attitude];
}

- (void)showPhotoAttitude:(LMPhotoAttitude)attitude {
    
    if ([self.delegate respondsToSelector:@selector(photoCollectionViewCell:didShowAttitude:)]) {
        [self.delegate photoCollectionViewCell:self didShowAttitude:attitude];
    }
    
    NSString *attitudeString;
    switch (attitude) {
        case LMPhotoAttitudeNormal: {
            attitudeString = @"Normal";
            break;
        }
        case LMPhotoAttitudeLike: {
            attitudeString = @"Like";
            break;
        }
        case LMPhotoAttitudeUnlike: {
            attitudeString = @"Unlike";
            break;
        }
    }
    self.infoLabel.text = [NSString stringWithFormat:@"%@   %@",_imageName,attitudeString];
}

@end
