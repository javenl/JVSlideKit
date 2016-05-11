//
//  Demo5ViewController.m
//  JVSlideKit
//
//  Created by liu on 16/5/11.
//
//

#import "Demo5ViewController.h"
#import "JVSlideView.h"
#import "JVHorizontalPagedLayout.h"

@interface Demo5ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) JVHorizontalPagedLayout *pagedLayout;

//@property (strong, nonatomic) JVSlideView *slideView;

@property (strong, nonatomic) NSArray *titles;

@end

static NSString *kIdentifier = @"SlideViewCell";

@implementation Demo5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pagedLayout = [[JVHorizontalPagedLayout alloc] init];
    self.pagedLayout.verticalSpace = 10;
    self.pagedLayout.horizontalSpace = 5;
    self.pagedLayout.itemSize = CGSizeMake(50, 50);
//    self.pagedLayout.delegate = self;
//    self.pagedLayout.isHorizontal = YES;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 170) collectionViewLayout:self.pagedLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    //    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    
}
/*
#pragma mark - UICollectionViewDelegateJVFlowLayout

//- (NSInteger)numberOfitemsWithCollectionView:(UICollectionView *)collectionView {
//    return 10;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return CGSizeMake(100, 100);
    } else {
        return CGSizeMake(200, 200);
    }
}
*/
#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:35];
    label.textColor = [UIColor blackColor];
//    label.backgroundColor = [UIColor yellowColor];
    label.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    
    [cell.contentView addSubview:label];
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

@end
