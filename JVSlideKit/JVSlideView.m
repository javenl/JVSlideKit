//
//  JVSlideView.m
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import "JVSlideView.h"

#define MAX_COUNT INT_LEAST16_MAX

@interface JVSlideView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, assign) NSUInteger itemCount;

@property (nonatomic, readwrite) NSUInteger currentIndex;

@property (nonatomic, strong) NSTimer *autoSlideTimer;

@end


@implementation JVSlideView

#pragma mark - init Method

- (void)initValue {
//    self.forceCenterView = YES;
    self.itemSpace = 5;
}

- (void)initSubviews {
    [self initSubviewsWithItemSize:CGSizeZero itemSpace:0];
}

- (void)initSubviewsWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    if (!CGSizeEqualToSize(itemSize, CGSizeZero)) {
        self.layout.itemSize = itemSize;
    }
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.layout.minimumInteritemSpacing = FLT_MAX;//prevent to display 2 row
//    self.layout.minimumLineSpacing = itemSpace;
//    self.layout.minimumLineSpacing = FLT_MAX;//prevent to display 2 row
    self.layout.headerReferenceSize = CGSizeMake(itemSpace, 0);
    self.layout.footerReferenceSize = CGSizeMake(itemSpace, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor purpleColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentIndex = MAX_COUNT / 2;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:MAX_COUNT / 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}

- (instancetype)initWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initSubviewsWithItemSize:itemSize itemSpace:itemSpace];
    }
    return self;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - Public Method

- (void)reloadData {
    NSAssert(self.dataSource != nil, @"SlideView DataSource should not be nil");
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInSlideView:)], @"Method \"numberOfItemsInSlideView:\" should be implemented");
    self.itemCount = [self.dataSource numberOfItemsInSlideView:self];
    [self.collectionView reloadData];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}


- (void)startAutoSlideWithInterval:(NSInteger)interval {
    [self.autoSlideTimer invalidate];
    self.autoSlideTimer = nil;
    self.autoSlideTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(didTimerFire:) userInfo:nil repeats:YES];
}

- (void)stopAutoSlide {
    [self.autoSlideTimer invalidate];
    self.autoSlideTimer = nil;
}

#pragma mark - Event

- (void)didTimerFire:(NSTimer *)timer {
    self.currentIndex++;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - Helper

- (CGPoint)nearestPointForOffset:(CGPoint)offset {
    CGFloat pageWidth = self.layout.itemSize.width + self.layout.minimumLineSpacing;
    NSInteger page = (offset.x + CGRectGetWidth(self.bounds) / 2) / pageWidth;
    if (page > 0) {
        CGFloat pageOffset = pageWidth - ( (CGRectGetWidth(self.bounds) - pageWidth) / 2) + self.layout.minimumLineSpacing / 2;
        CGFloat targetX = pageOffset + (page - 1) * pageWidth;
        return CGPointMake(targetX, offset.y);
    } else {
        return CGPointMake(0, offset.y);
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //    velocity = CGPointMake(1, 0);
    //    scrollView.decelerationRate = 0;
//    NSLog(@"velocity %@", NSStringFromCGPoint(velocity));
    
    if (self.forceCenterView) {
        CGPoint targetOffset = [self nearestPointForOffset:*targetContentOffset];
        targetContentOffset->x = targetOffset.x;
        targetContentOffset->y = targetOffset.y;
    }
    

    /*
     if (!self.pagingEnabled) {
     CGPoint targetOffset = [self nearestPointForOffset:*targetContentOffset];
     targetContentOffset->x = targetOffset.x;
     targetContentOffset->y = targetOffset.y;
     } else {
     CGPoint offset = *targetContentOffset;
     CGFloat pageWidth = self.layout.itemSize.width + self.layout.minimumLineSpacing;
     NSInteger page = (offset.x + CGRectGetWidth(self.bounds) / 2) / pageWidth;
     if (page > 0) {
     NSInteger currentPage = [self caculateRelativeIndexFromRealIndex:self.currentIndex];
     CGFloat pageOffset = pageWidth - ( (CGRectGetWidth(self.bounds) - pageWidth) / 2) + self.layout.minimumLineSpacing / 2;
     CGFloat targetX = 0;
     if (page == currentPage) {
     targetX = pageOffset + (currentPage - 1) * pageWidth;
     } else if (page > currentPage) {
     targetX = pageOffset + (currentPage - 1 + 1) * pageWidth;
     } else if (page < currentPage) {
     targetX = pageOffset + (currentPage - 1 - 1) * pageWidth;
     }
     CGPoint targetOffset = CGPointMake(targetX, offset.y);
     targetContentOffset->x = targetOffset.x;
     targetContentOffset->y = targetOffset.y;
     //            return CGPointMake(targetX, offset.y);
     } else {
     CGPoint targetOffset = CGPointMake(0, offset.y);
     targetContentOffset->x = targetOffset.x;
     targetContentOffset->y = targetOffset.y;
     //            return CGPointMake(0, offset.y);
     }
     }
     */
    //    NSLog(@"point %@", NSStringFromCGPoint(targetOffset));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(slideView:didStopAtIndex:)]) {
        [self.delegate slideView:self didStopAtIndex:[self caculateRelativeIndexFromRealIndex:self.currentIndex]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.layout.itemSize.width + self.layout.minimumLineSpacing;
    NSInteger page = (scrollView.contentOffset.x + CGRectGetWidth(self.bounds) / 2) / pageWidth;
    if (page != self.currentIndex) {
        self.currentIndex = page;
        if ([self.delegate respondsToSelector:@selector(slideView:didChangeCenterIndex:)]) {
            [self.delegate slideView:self didChangeCenterIndex:[self caculateRelativeIndexFromRealIndex:self.currentIndex]];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layout.itemSize;
//    if (indexPath.row % 2 == 0) {
//        return CGSizeMake(50, 50);
//    } else {
//        return CGSizeMake(100, 100);
//    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX_COUNT;
    //    if (self.itemCount == 1) {
    //        return 1;
    //    } else {
    //        return MAX_COUNT;
    //    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.dataSource != nil, @"SlideView DataSource should not be nil");
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInSlideView:)], @"Method \"collectionView:cellForItemAtIndexPath:\" should be implemented");
    
    NSInteger index = [self caculateRelativeIndexFromRealIndex:indexPath.row];
    NSString *idetifier = [self.dataSource slideView:self identifierAtIndex:index];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idetifier forIndexPath:indexPath];
    cell = [self.dataSource slideView:self updateCell:cell atIndex:index];
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self caculateRelativeIndexFromRealIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(slideView:didSelectedAtIndex:)]) {
        [self.delegate slideView:self didSelectedAtIndex:index];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Properties

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        self.layout.itemSize = itemSize;
        [self.layout invalidateLayout];
    }
}

- (void)setItemSpace:(CGFloat)itemSpace {
    if (_itemSpace != itemSpace) {
        _itemSpace = itemSpace;
        self.layout.minimumLineSpacing = itemSpace;
        self.layout.headerReferenceSize = CGSizeMake(itemSpace, 0);
        self.layout.footerReferenceSize = CGSizeMake(itemSpace, 0);
        [self.layout invalidateLayout];
    }
}

@end
