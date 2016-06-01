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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //        flowLayout.itemSize = CGSizeMake(111, 111);
//    flowLayout.itemSize = self.view.bounds.size;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.itemSize = self.view.bounds.size;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)+self.flowLayout.minimumLineSpacing, CGRectGetHeight(self.view.bounds));
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[JVPhotoBrowserCell class] forCellWithReuseIdentifier:kIentifier];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.flowLayout.minimumLineSpacing);
    [self.view addSubview:self.collectionView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

#pragma mark -

- (void)didSingleTap:(UITapGestureRecognizer *)gesture {
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    }
}

#pragma mark -

- (void)setupItems:(NSArray *)items {
    self.items = [NSMutableArray arrayWithArray:items];
    [self.collectionView reloadData];
}

- (void)moveToIndex:(NSInteger)index {
    if (self.view) {
        if (index < [self collectionView:self.collectionView numberOfItemsInSection:0]) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
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
    if ([self.delegate respondsToSelector:@selector(jvPhotoBrowser:willShowPreviewer:atIndex:)]) {
        [self.dataSource jvPhotoBrowser:self willShowPreviewer:cell.imagePreviwer atIndex:indexPath.row];
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
    NSInteger page = (scrollView.contentOffset.x + CGRectGetWidth(self.view.bounds) / 2) / pageWidth;
    if (page != self.currentIndex) {
        //        NSLog(@"currenntIndex %@  page %@", @(self.currentIndex), @(page));
        self.currentIndex = page;
//        if ([self.delegate respondsToSelector:@selector(slideView:didChangeCenterIndex:)]) {
//            [self.delegate slideView:self didChangeCenterIndex:self.currentIndex];
//        }
    }
}

@end
