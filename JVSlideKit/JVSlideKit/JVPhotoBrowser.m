//
//  JVPhotoBrowser.m
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import "JVPhotoBrowser.h"
#import "JVPhotoBrowserCell.h"

@interface JVPhotoBrowser () 

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *items;

//@property (assign, nonatomic) NSInteger startIndex;

@end

static NSString *kIentifier = @"JVPhotoBrowserCell";

@implementation JVPhotoBrowser

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
//        self.backgroundColor = [UIColor yellowColor];
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.minimumLineSpacing = 10;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
//        if ([self.delegate respondsToSelector:@selector(customTableCell)]) {
//            [self.collectionView registerClass:[self.delegate customTableCell] forCellWithReuseIdentifier:kIentifier];
//        } else {
//            [self.collectionView registerClass:[JVPhotoBrowserCell class] forCellWithReuseIdentifier:kIentifier];
//        }
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.flowLayout.minimumLineSpacing);
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)+self.flowLayout.minimumLineSpacing, CGRectGetHeight(self.bounds));
}

#pragma mark - Public

- (void)setupItems:(NSArray *)items {
    self.items = [NSMutableArray arrayWithArray:items];
    [self.collectionView reloadData];
}

- (void)moveToIndex:(NSInteger)index {
    if (index < [self collectionView:self.collectionView numberOfItemsInSection:0]) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)insertItemAtIndex:(NSInteger)index {
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)removeItemAtIndex:(NSInteger)index {
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)reloadItemAtIndex:(NSInteger)index {
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInJVPhotoBrowser:)]) {
        return [self.dataSource numberOfItemsInJVPhotoBrowser:self];
    } else {
        return self.items.count;
    }
}

- (JVPhotoBrowserCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JVPhotoBrowserCell *cell = (JVPhotoBrowserCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kIentifier forIndexPath:indexPath];
    if (self.items) {
        [cell updateCellWithObject:self.items[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(JVPhotoBrowserCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(jvPhotoBrowser:willShowCell:atIndex:)]) {
        [self.dataSource jvPhotoBrowser:self willShowCell:cell atIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(jvPhotoBrowser:didStopAtIndex:)]) {
        [self.delegate jvPhotoBrowser:self didStopAtIndex:self.currentIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    if ([self.delegate respondsToSelector:@selector(jvPhotoBrowser:didStopAtIndex:)]) {
        [self.delegate jvPhotoBrowser:self didStopAtIndex:self.currentIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing;
    NSInteger page = (scrollView.contentOffset.x + CGRectGetWidth(self.bounds) / 2) / pageWidth;
    if (page != self.currentIndex) {
        //        NSLog(@"currenntIndex %@  page %@", @(self.currentIndex), @(page));
        self.currentIndex = page;
//        if ([self.delegate respondsToSelector:@selector(slideView:didChangeCenterIndex:)]) {
//            [self.delegate slideView:self didChangeCenterIndex:self.currentIndex];
//        }
    }
}

#pragma mark - Property

- (void)setDelegate:(id<JVPhotoBrowserDelegate>)delegate {
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(customTableCell)]) {
        [self.collectionView registerClass:[self.delegate customTableCell] forCellWithReuseIdentifier:kIentifier];
    }
}

@end
