//
//  JVSlideLoopView.m
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import "JVSlideLoopView.h"
#import "JVLinearLayout.h"

#define MAX_COUNT INT_LEAST16_MAX

@interface JVSlideLoopView ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign, readwrite) NSInteger currentIndex;

@end

@implementation JVSlideLoopView

@dynamic currentIndex;

- (void)initSubviewsWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace {
    [super initSubviewsWithItemSize:itemSize itemSpace:itemSpace];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentIndex = MAX_COUNT / 2;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:MAX_COUNT / 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}

- (void)didTimerFire:(NSTimer *)timer {
//    self.currentIndex++;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    if ([self.delegate respondsToSelector:@selector(slideView:didStopAtIndex:)]) {
//        [self.delegate slideView:self didStopAtIndex:[self caculateRelativeIndexFromRealIndex:self.currentIndex+1]];
//    }
}

- (NSInteger)caculateRelativeIndexFromRealIndex:(NSInteger)realIndex {
    if (self.itemCount == 0) {
        return 0;
    }
    
    NSInteger realOffset = realIndex - MAX_COUNT / 2;
    NSInteger index = 0;
    NSInteger count = self.itemCount;
    NSInteger offset = realOffset % count;
    if (offset >= 0) {
        index = offset;
    } else {
        index = self.itemCount - labs(offset);
    }
    return index;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.itemCount == 1) {
        return 1;
    } else {
        return MAX_COUNT;
    }
}


@end
