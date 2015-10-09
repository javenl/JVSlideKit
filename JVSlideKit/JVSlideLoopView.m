//
//  JVSlideLoopView.m
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import "JVSlideLoopView.h"
#import "JVFlowLayout.h"

#define MAX_COUNT INT_LEAST16_MAX

@interface JVSlideLoopView ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSUInteger itemCount;

@property (nonatomic, readwrite) NSUInteger currentIndex;

@end

@implementation JVSlideLoopView

- (void)initSubviewsWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace {
    [super initSubviewsWithItemSize:itemSize itemSpace:itemSpace];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentIndex = MAX_COUNT / 2;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:MAX_COUNT / 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
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
