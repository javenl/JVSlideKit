//
//  JVSlideViewContainer.m
//  JVSlideKit
//
//  Created by liu on 15/10/20.
//
//

#import "JVSlideViewContainer.h"

@interface JVSlideViewContainer () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, readwrite) NSInteger currentIndex;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

static NSString *kIdentifier = @"JVSlideViewContainer";

@implementation JVSlideViewContainer

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.itemSize = self.bounds.size;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    //    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //        self.collectionView.bounces = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    
    return self;
    //    NSLog(@"itemSize %@", NSStringFromCGSize(self.layout.itemSize));
    //    NSLog(@"bounds %@", NSStringFromCGRect(self.view.bounds));
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Method

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.currentIndex == index) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

//- (void)slideViewContainer:(JVSlideViewContainer *)slideViewContainer didScrollToIndex:(NSInteger)index {
//    
//}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return 10;
    return self.views.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    //    cell.frame = cell.bounds;
    //
    //    NSLog(@"cell frame %@", NSStringFromCGRect(cell.frame));
    //    NSLog(@"cell bounds %@", NSStringFromCGRect(cell.bounds));
    //    NSLog(@"itemSize %@", NSStringFromCGSize(self.layout.itemSize));
    //    NSLog(@"bounds %@", NSStringFromCGRect(self.view.bounds));
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //    UIView *view = [self.dataSource loopView:self viewAtIndex:self.tmpIndex];
    
    [cell.contentView addSubview:self.views[indexPath.row]];
    
    /*
    UIViewController *vc = self.viewControllers[indexPath.row];
    //    if([vc isKindOfClass:[DDBaseModuleViewController class]]) {
    //        ((DDBaseModuleViewController *)vc).navigationBar.hidden = YES;
    //    }
    //    vc.view.frame = self.view.bounds;
    //    [cell.contentView addSubview:vc.view];
    
    
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    
    
    vc.view.frame = self.view.bounds;
    [self addChildViewController:vc];
    [cell.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    */
    
    //    NSLog(@"frame %@", NSStringFromCGRect(cell.frame));
    //    NSLog(@"tmpIndex %@", @(self.tmpIndex));
    //    NSLog(@"currentIndex %@", @(self.currentIndex));
    
    return cell;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger index = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
        self.currentIndex = index;
//        [self slideContainer:self didScrollToIndex:index];
        [self.delgate slideViewContainer:self didScrollToIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        //    NSLog(@"%@", @(scrollView.contentOffset.x));
        //    NSLog(@"%@", @(round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds))));
        NSInteger index = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
        self.currentIndex = index;
//        [self slideContainer:self didScrollToIndex:index];
        [self.delgate slideViewContainer:self didScrollToIndex:index];
    }
}

@end
