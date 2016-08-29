//
//  ViewController.m
//  LMStackLayout
//
//  Created by Lyman on 16/8/27.
//  Copyright © 2016年 Lyman. All rights reserved.
//

#import "ViewController.h"
#import "LMPhotoCollectionViewCell.h"
#import "LMStackLayout.h"

static NSString *const CellIdentifier = @"photoCellIdentifier";
static const CGFloat kPadding = 10.0;

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,PhotoCollectionViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation ViewController

- (NSMutableArray *)images {
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
        
        for (int i = 1; i<=20; i++) {
            [self.images addObject:[NSString stringWithFormat:@"IMG_%d.JPG", i]];
        }
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = self.view.frame.size.width - 2*kPadding;
    CGRect  rect = CGRectMake(kPadding, (self.view.bounds.size.height - 1.5*width)/2.0, width, 1.5*width);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[[LMStackLayout alloc] init]];
    collectionView.backgroundColor = [UIColor orangeColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"LMPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageName = self.images[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark - PhotoCollectionViewCellDelegate 
- (void)photoCollectionViewCell:(LMPhotoCollectionViewCell *)photoCell didShowAttitude:(LMPhotoAttitude)photoAttitude {

    if (photoAttitude == LMPhotoAttitudeNormal) {
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:photoCell];
    [self.images removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

@end
