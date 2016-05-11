//
//  JVHorizontalPagedLayout.m
//  JVSlideKit
//
//  Created by liu on 16/5/11.
//
//

#import "JVHorizontalPagedLayout.h"

@interface JVHorizontalPagedLayout ()

@property (nonatomic, readwrite) NSInteger itemCount;

@property (nonatomic, strong) NSMutableArray *attributeArray;

@property (nonatomic, assign) CGFloat currentX;
@property (nonatomic, assign) CGFloat currentY;
@property (nonatomic, assign) CGFloat currentPage;

@end

@implementation JVHorizontalPagedLayout

- (id)init {
    self = [super init];
    if (self) {
        self.attributeArray = [NSMutableArray array];
        self.verticalSpace = 0;
        self.horizontalSpace = 0;
        self.itemSize = CGSizeMake(30, 30);
    }
    return self;
}

#pragma mark - Method

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    if (self.itemCount <= 0) {
        return;
    }
    
    [self.attributeArray removeAllObjects];
    
    self.currentX = 0;
    self.currentY = 0;
    self.currentPage = 1;
    
    for (NSInteger i = 0; i < self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGFloat pageWidth = CGRectGetWidth(self.collectionView.bounds);
        CGFloat pageHeight = CGRectGetHeight(self.collectionView.bounds);
        
        NSAssert(self.itemSize.width < pageWidth, @"itemSize.width should not lager than collectionView width");
        NSAssert(self.itemSize.height < pageHeight, @"itemSize.width should not lager than collectionView width");
        
        CGFloat testX = self.currentX + self.itemSize.width;
        if (testX <= pageWidth * self.currentPage) {
            attribute.frame = CGRectMake(self.currentX, self.currentY, self.itemSize.width, self.itemSize.height);
            self.currentX = testX + self.horizontalSpace;
        } else {
            CGFloat testY = self.currentY + (self.itemSize.height * 2 + self.verticalSpace);
            if (testY > pageHeight) {
                self.currentY = 0;
                self.currentPage++;
            } else {
                self.currentY += self.itemSize.height + self.verticalSpace;
            }
            self.currentX = pageWidth * (self.currentPage-1);
            attribute.frame = CGRectMake(self.currentX, self.currentY, self.itemSize.width, self.itemSize.height);
            self.currentX = CGRectGetMaxX(attribute.frame) + self.horizontalSpace;
        }
        [self.attributeArray addObject:attribute];
    }
}


#pragma mark - UICollectionViewLayout

- (CGSize)collectionViewContentSize {
    CGSize size = CGSizeMake(self.currentPage * CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //    NSLog(@"layoutAttributesForElementsInRect %@", NSStringFromCGRect(rect));
    NSMutableArray *totalAttribures = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.attributeArray) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [totalAttribures addObject:attribute];
        }
    }
    return totalAttribures;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributeArray[indexPath.row];
}

@end
