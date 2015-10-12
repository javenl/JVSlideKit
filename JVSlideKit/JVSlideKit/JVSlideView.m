//
//  JVSlideView.m
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import "JVSlideView.h"
#import "JVLinearLayout.h"

#define MAX_COUNT INT_LEAST16_MAX

@interface JVSlideView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateJVLineaarLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JVLinearLayout *flowLayout;

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, readwrite) NSInteger currentIndex;

@property (nonatomic, strong) NSTimer *autoSlideTimer;

@end


@implementation JVSlideView

#pragma mark - init Method

- (void)initValue {
//    self.forceCenterView = YES;
    self.itemSpace = 5;
    self.currentIndex = 0;
}

- (void)initSubviews {
    [self initSubviewsWithItemSize:CGSizeZero itemSpace:0];
}

- (void)initSubviewsWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace {
    self.flowLayout = [[JVLinearLayout alloc] init];
    self.flowLayout.delegate = self;
    self.flowLayout.itemSpace = itemSpace;
    self.itemSize = itemSize;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor purpleColor];
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
    self.collectionView.contentInset = UIEdgeInsetsZero;
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
//    self.currentIndex++;
//    if (self.currentIndex >= self.itemCount) {
//        self.currentIndex = 0;
//    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    if ([self.delegate respondsToSelector:@selector(slideView:didStopAtIndex:)]) {
//        [self.delegate slideView:self didStopAtIndex:[self caculateRelativeIndexFromRealIndex:self.currentIndex+1]];
//    }
}

#pragma mark - Helper

- (CGPoint)nearestPointForOffset:(CGPoint)offset {
    CGFloat pageWidth = self.itemSize.width + self.flowLayout.itemSpace;
    NSInteger page = (offset.x + CGRectGetWidth(self.bounds) / 2) / pageWidth;
    if (page > 0) {
        CGFloat pageOffset = pageWidth - ( (CGRectGetWidth(self.bounds) - pageWidth) / 2) + self.flowLayout.itemSpace / 2;
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
    return realIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGFloat pageWidth = self.itemSize.width + self.flowLayout.itemSpace;
//    CGFloat pageOffset = pageWidth - ( (CGRectGetWidth(self.bounds) - pageWidth) / 2) + self.flowLayout.itemSpace / 2;
//    NSLog(@"point %@", NSStringFromCGPoint(*targetContentOffset));
//    NSLog(@"pageOffset %@", @(pageOffset));
    if (self.forceCenterView) {
        if (targetContentOffset->x == 0 || targetContentOffset->x == (scrollView.contentSize.width - scrollView.bounds.size.width)) {
            return;
        }
        CGPoint targetOffset = [self nearestPointForOffset:*targetContentOffset];
        targetContentOffset->x = targetOffset.x;
        targetContentOffset->y = targetOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(slideView:didStopAtIndex:)]) {
        [self.delegate slideView:self didStopAtIndex:[self caculateRelativeIndexFromRealIndex:self.currentIndex]];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    if ([self.delegate respondsToSelector:@selector(slideView:didStopAtIndex:)]) {
        [self.delegate slideView:self didStopAtIndex:[self caculateRelativeIndexFromRealIndex:self.currentIndex]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.itemSize.width + self.flowLayout.itemSpace;
    NSInteger page = (scrollView.contentOffset.x + CGRectGetWidth(self.bounds) / 2) / pageWidth;
    if (page != self.currentIndex) {
        NSLog(@"currenntIndex %@  page %@", @(self.currentIndex), @(page));
        self.currentIndex = page;
        if ([self.delegate respondsToSelector:@selector(slideView:didChangeCenterIndex:)]) {
            [self.delegate slideView:self didChangeCenterIndex:[self caculateRelativeIndexFromRealIndex:self.currentIndex]];
        }
    }
}

#pragma mark - UICollectionViewDelegateJVFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
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
        [self.flowLayout invalidateLayout];
    }
}

- (void)setItemSpace:(CGFloat)itemSpace {
    if (_itemSpace != itemSpace) {
        _itemSpace = itemSpace;
        self.flowLayout.itemSpace = itemSpace;
        [self.flowLayout invalidateLayout];
    }
}

@end
