//
//  JVBannerView.m
//  JVSlideKit
//
//  Created by liu on 15/10/9.
//
//

#import "JVBannerView.h"

@interface JVBannerView ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, readwrite) NSInteger currentIndex;

@end

@implementation JVBannerView

@dynamic currentIndex;

- (void)initSubviewsWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace {
    [super initSubviewsWithItemSize:itemSize itemSpace:itemSpace];
    
    self.collectionView.pagingEnabled = YES;
//    self.currentIndex = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentIndex = 0;
        [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    });
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
}

#pragma mark - Event

- (void)didTimerFire:(NSTimer *)timer {
    [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*2, 0) animated:YES];
//    if ([self.delegate respondsToSelector:@selector(slideView:didStopAtIndex:)]) {
//        [self.delegate slideView:self didStopAtIndex:self.currentIndex+1];
//    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
    
    //    NSLog(@"contentOffset %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    //    self.flag = NO;
    
    if (self.loop) {
        if (scrollView.contentOffset.x == CGRectGetWidth(self.bounds)) {// 没有换页
            return;
        }
    } else {
        if (scrollView.contentOffset.x == CGRectGetWidth(self.bounds) * self.currentIndex) {// 没有换页
            return;
        }
    }
    
    //    self.currentIndex = self.tmpIndex;
//    if (self.loop) {
        //        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        //        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
//    }
    //    [self.collectionView reloadData];
    
//    if ([self.delegate respondsToSelector:@selector(loopView:didChangeIndex:)]) {
//        [self.delegate loopView:self didChangeIndex:self.currentIndex];
//    }
    [self.delegate slideView:self didStopAtIndex:self.currentIndex];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (!self.flag) {
    //        return;
    //    }
    
    int xOffset = scrollView.contentOffset.x;
//    NSLog(@"xOffset %@", @(xOffset));
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    NSInteger lastIndex = self.currentIndex;
    // 水平滚动
    // 往下翻一张
    if(xOffset >= (2*pageWidth)) {
        //向右
        self.currentIndex++;
        if (self.currentIndex >= self.itemCount) {
            self.currentIndex = 0;
        }
//        NSLog(@"++ page %@", @(self.currentIndex));
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
            [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
            //            [self.collectionView layoutIfNeeded];
            //        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        });
        //        [self.collectionView setNeedsLayout];
        
        //        [self setNeedsLayout];
        //        [self layoutIfNeeded];
        //        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
        
        //        selectedImageIndex++;
        //        selectedImageIndex = selectedImageIndex % [dtoArray count];
        //        [self refreshScrollView];
    }
    if(xOffset <= 0) {
        //        BOOL needScroll = YES;
        //向左
        self.currentIndex--;
        if (self.currentIndex < 0) {
            if (self.loop) {
                self.currentIndex = self.itemCount - 1;
            } else {
                self.currentIndex = 0;
                return;
                //                needScroll = NO;
            }
        }
//        NSLog(@"-- page %@", @(self.currentIndex));
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
            [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
            //            [self.collectionView layoutIfNeeded];
            //        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        });
    }
    if (lastIndex != self.currentIndex) {
        if ([self.delegate respondsToSelector:@selector(slideView:didChangeCenterIndex:)]) {
            [self.delegate slideView:self didChangeCenterIndex:self.currentIndex];
        }
    }
}

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
    
        NSInteger index = self.currentIndex;
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
    
//    NSInteger index = [self caculateRelativeIndexFromRealIndex:indexPath.row];
    NSString *idetifier = [self.dataSource slideView:self identifierAtIndex:index];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
    cell = [self.dataSource slideView:self updateCell:cell atIndex:index];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger index = [self caculateRelativeIndexFromRealIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(slideView:didSelectedAtIndex:)]) {
        [self.delegate slideView:self didSelectedAtIndex:self.currentIndex];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
