//
//  JVFlowLayout.m
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import "JVFlowLayout.h"

@interface JVFlowLayout ()

//@property (nonatomic, readwrite) NSInteger columnCount;

@property (nonatomic, readwrite) NSInteger itemCount;

@property (nonatomic, strong) NSMutableArray *attributeArray;

@end

@implementation JVFlowLayout

- (id)init {
    self = [super init];
    if (self) {
//        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//        self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.isHorizontal = YES;
        self.itemSpace = 10;
        self.attributeArray = [NSMutableArray array];
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
    
    CGFloat left = 0;
    CGFloat top = 0;
    for (NSInteger i = 0; i < self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        if (self.isHorizontal) {
            if (i == 0) {
                left += self.itemSpace;
            }
            CGFloat x = left;
            CGFloat y = ((CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom) - itemSize.height) / 2;
            attribute.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            left += self.itemSpace + itemSize.width;
        } else {
            if (i == 0) {
                top += self.itemSpace;
            }
            CGFloat x = ((CGRectGetWidth(self.collectionView.bounds) - self.collectionView.contentInset.left - self.collectionView.contentInset.right) - itemSize.width) / 2;
            CGFloat y = top;
            attribute.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            top += self.itemSpace + itemSize.height;
        }
        [self.attributeArray addObject:attribute];
    }
}


#pragma mark - UICollectionViewLayout

- (CGSize)collectionViewContentSize {
//    CGFloat columnHeight = [self maxHeightForColumns:self.columns] + self.contentInsets.top + self.contentInsets.bottom;
    UICollectionViewLayoutAttributes *attribute = [self.attributeArray lastObject];
    if (self.isHorizontal) {
        CGFloat width = CGRectGetMaxX(attribute.frame) + self.itemSpace;
        width = MAX(width, CGRectGetWidth(self.collectionView.bounds)+ 1);
        return CGSizeMake(width, CGRectGetHeight(self.collectionView.bounds));
    } else {
        CGFloat height = CGRectGetMaxY(attribute.frame) + self.itemSpace;
        height = MAX(height, CGRectGetHeight(self.collectionView.bounds)+ 1);
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height);
    }

    //保证contentSize比bounds.height大，否则小于一页不能滚动
//    CGFloat height = MAX(columnHeight, CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top + 1);
    //    NSLog(@"columnHeight %@  columnBounds %@  columnInsets %@", @(columnHeight), NSStringFromCGRect(self.collectionView.bounds), NSStringFromUIEdgeInsets(self.collectionView.contentInset));
    //    NSLog(@"contentHeight %@", @(height));
    
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

//- (NSLayoutAttribute *)la

@end
