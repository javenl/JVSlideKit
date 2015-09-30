//
//  ViewController.m
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import "ViewController.h"
#import "JVSlideView.h"
#import "JVFlowLayout.h"

@interface ViewController () <JVSlideViewDelegate, JVSlideViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateJVFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) JVFlowLayout *flowLayout;

@property (strong, nonatomic) JVSlideView *slideView;

@property (strong, nonatomic) NSArray *titles;

@end

static NSString *kIdentifier = @"SlideView";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    self.slideView = [[JVSlideView alloc] initWithItemSize:CGSizeMake(150, 150) itemSpace:10];
    self.slideView.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.frame), 300);
    self.slideView.delegate = self;
    self.slideView.dataSource = self;
//    self.slideView.pagingEnabled = YES;
//    self.slideView.forceCenterView = YES;
    [self.slideView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    [self.view addSubview:self.slideView];
    
    self.titles = @[@"a", @"b", @"c", @"d", @"e", @"f"];
//    self.titles = @[@"a", @"b"];
    
    [self.slideView reloadData];
    */
//    NSLog(@"test %@", @(-4 % 4));
    
    
//    CGFloat itemSpace = 10;
//    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.flowLayout.minimumInteritemSpacing = 50;
    //    self.layout.minimumLineSpacing = FLT_MAX;
    //    self.layout.minimumInteritemSpacing = FLT_MAX;
    //    self.layout.minimumInteritemSpacing = FLT_MAX;//prevent to display 2 row
    //    self.layout.minimumLineSpacing = FLT_MAX;
//    self.layout.headerReferenceSize = CGSizeMake(itemSpace, 0);
//    self.layout.footerReferenceSize = CGSizeMake(itemSpace, 0);
    
    self.flowLayout = [[JVFlowLayout alloc] init];
    self.flowLayout.itemSpace = 10;
    self.flowLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    //    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDelegateJVFlowLayout

//- (NSInteger)numberOfitemsWithCollectionView:(UICollectionView *)collectionView {
//    return 10;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, 200);
}

#pragma mark - 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
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
    label.backgroundColor = [UIColor yellowColor];
    label.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    
    [cell.contentView addSubview:label];
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}


#pragma mark - SlideViewDataSource

- (NSInteger)numberOfItemsInSlideView:(JVSlideView *)slideView {
    return self.titles.count;
//    return 10;
}

- (NSString *)slideView:(JVSlideView *)slideView identifierAtIndex:(NSInteger)index {
    return kIdentifier;
}

- (UICollectionViewCell *)slideView:(JVSlideView *)slideView updateCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    //    if (index % 2) {
    //        cell.backgroundColor = [UIColor redColor];
    //    } else {
    //        cell.backgroundColor = [UIColor yellowColor];
    //    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:35];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor yellowColor];
//    label.text = [NSString stringWithFormat:@"%@", @(index)];
    label.text = self.titles[index];
    //    NSInteger index = [self caculateIndexFromIndexPath:indexPath];
    //    label.text = self.titles[index];
    
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark - SlideViewDelegate

- (void)slideView:(JVSlideView *)slideView didSelectedAtIndex:(NSInteger)index {
    //    NSLog(@"tap at index %@", @(index));
}

- (void)slideView:(JVSlideView *)slideView didChangeCenterIndex:(NSInteger)index {
    //    NSLog(@"didChangeCenterIndex %@", @(index));
//    self.pageControl.currentPage = index;
}

- (void)slideView:(JVSlideView *)slideView didStopAtIndex:(NSInteger)index {
    //    NSLog(@"didStopAtIndex %@", @(index));
}


@end
