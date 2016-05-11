//
//  JVBannerView.m
//  JVSlideKit
//
//  Created by liu on 15/10/9.
//
//

#import "JVBannerView.h"

@interface JVSlideView ()

- (void)initValue;

- (void)startAutoSlideTimer;

- (void)stopAutoSlideTimer;

@end

@interface JVBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, readwrite) NSInteger currentIndex;

@property (strong, nonatomic) NSTimer *autoSlideTimer;

@property (assign, nonatomic) NSInteger autoSlideTimerInterval;

@end

@implementation JVBannerView

@dynamic currentIndex;

- (void)initValue {
    [super initValue];
    self.loop = YES;
}

- (void)initSubviewsWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace {
    [super initSubviewsWithItemSize:itemSize itemSpace:itemSpace];
    
    self.collectionView.pagingEnabled = YES;
//    self.currentIndex = 0;
    
    if (self.loop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentIndex = 0;
            [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
        });
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.loop) {
        [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    }
}

#pragma mark - Event

- (void)didTimerFire:(NSTimer *)timer {
    if (!self.loop) {
        NSInteger index = self.currentIndex + 1;
        if (index >= self.itemCount) {
            index = 0;
        }
        [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*index, 0) animated:YES];
    } else {
        [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*2, 0) animated:YES];
    }
    
//    if ([self.delegate respondsToSelector:@selector(slideView:didStopAtIndex:)]) {
//        [self.delegate slideView:self didStopAtIndex:self.currentIndex+1];
//    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoSlideTimerInterval > 0) {
        [self stopAutoSlideTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.autoSlideTimerInterval > 0) {
        [self startAutoSlideTimer];
    }
    
//    NSLog(@"scrollViewDidEndDecelerating");
    
//    NSLog(@"contentOffset %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    //    self.flag = NO;
//    NSLog(@"contentOffet %@  currentIndex %@",@(scrollView.contentOffset.x), @(self.currentIndex));
    /*
    if (self.loop) {
        if (scrollView.contentOffset.x == CGRectGetWidth(self.bounds)) {// 没有换页
            return;
        }
    } else {
        if (scrollView.contentOffset.x == CGRectGetWidth(self.bounds) * self.currentIndex) {// 没有换页
            return;
        }
    }
    */
    //    self.currentIndex = self.tmpIndex;
//    if (self.loop) {
        //        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        //        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
//    }
    //    [self.collectionView reloadData];
    
//    if ([self.delegate respondsToSelector:@selector(loopView:didChangeIndex:)]) {
//        [self.delegate loopView:self didChangeIndex:self.currentIndex];
//    }
    

    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (!self.loop) {
//        return;
//    }
    int xOffset = scrollView.contentOffset.x;
    //    NSLog(@"xOffset %@", @(xOffset));
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    NSInteger lastIndex = self.currentIndex;
    
    if (!self.loop) {
        self.currentIndex = scrollView.contentOffset.x / pageWidth;
        
    } else {
        // 水平滚动
        // 往下翻一张
        if(xOffset >= (2*pageWidth)) {
            //向右
            self.currentIndex++;
            if (self.currentIndex >= self.itemCount) {
                self.currentIndex = 0;
            }
            //        if (self.loop) {
            [self reloadData];
            [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
            //        }
        }
        if(xOffset <= 0) {
            //向左
            self.currentIndex--;
            if (self.currentIndex < 0) {
                //            if (self.loop) {
                self.currentIndex = self.itemCount - 1;
                //            } else {
                //                self.currentIndex = 0;
                //                return;
                //            }
            }
            
            //        if (self.loop) {
            [self reloadData];
            [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
            //        }
        }
    }
    
    if (lastIndex != self.currentIndex) {
        //        if ([self.delegate respondsToSelector:@selector(slideView:didChangeCenterIndex:)]) {
        //            [self.delegate slideView:self didChangeCenterIndex:self.currentIndex];
        //        }
        [self.delegate slideView:self didStopAtIndex:self.currentIndex];
    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.loop) {
        return 3;
    } else {
        return self.itemCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.dataSource != nil, @"SlideView DataSource should not be nil");
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInSlideView:)], @"Method \"collectionView:cellForItemAtIndexPath:\" should be implemented");
    
    NSInteger index = 0;
    if (self.loop) {
        index = self.currentIndex;
        if (indexPath.row == 0 ) {
            index -= 1;
            if (index < 0) {
                index = self.itemCount - 1;
            }
        }
        if (indexPath.row == 1) {
    
        }
        if (indexPath.row == 2) {
            index += 1;
            if (index >= self.itemCount) {
                index = 0;
            }
        }
    } else {
        index = indexPath.row;
    }
//    NSInteger index = [self caculateRelativeIndexFromRealIndex:indexPath.row];
    NSString *idetifier = [self.dataSource slideView:self identifierAtIndex:index];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
    cell = [self.dataSource slideView:self updateCell:cell atIndex:index];
    return cell;
}

#pragma makr - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger index = [self caculateRelativeIndexFromRealIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(slideView:didSelectedAtIndex:)]) {
        [self.delegate slideView:self didSelectedAtIndex:self.currentIndex];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
