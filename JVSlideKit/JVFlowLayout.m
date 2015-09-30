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
    
//    self.itemCount = [self.delegate numberOfitemsWithCollectionView:self.collectionView];
    
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    if (self.itemCount <= 0) {
        return;
    }
    //    self.columns = [NSMutableArray arrayWithCapacity:self.columnCount];
    
    //    CGFloat columnWidth = CGRectGetWidth(self.collectionView.bounds) / 2 - 30;
    
//    CGFloat left = self.itemSpace;
    
    [self.attributeArray removeAllObjects];
    
//    NSInteger i = 0;
//    CGFloat maxWidth = 0;
//    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGSize itemSize = [self.delegate collectionView:self.collectionView sizeForItemAtIndexPath:indexPath];
        CGFloat x = self.itemSpace + i * (itemSize.width + self.itemSpace);
        CGFloat y = ((CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom) - itemSize.height) / 2;
        attribute.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        [self.attributeArray addObject:attribute];
//        [column.attributes addObject:attribute];
//        column.columnHeight += height;
    }
    
    /*
    CGFloat columnWidth = ((CGRectGetWidth(self.collectionView.bounds) - self.contentInsets.left - self.contentInsets.right - (self.columnCount - 1) * self.columnSpace)) / self.columnCount;
    
    self.columnWidth = columnWidth;
    
    self.columns = [NSMutableArray array];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        WaterFallLayoutColumn *column = [[WaterFallLayoutColumn alloc] init];
        column.index = i;
        column.x = self.contentInsets.left + (self.columnSpace + columnWidth) * i;
        //+ self.contentInsets.left * (i + 1)
        [self.columns addObject:column];
    }
    
    //    NSInteger numberOfSections = [self.collectionView numberOfSections];
    //    for (NSInteger i = 0; i < numberOfSections; i++) {
    NSInteger i = 0;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:i];
    for (NSInteger j = 0; j < numberOfItems; j++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        NSInteger selectIndex = [self minHeightIndexForColumns:self.columns];
        WaterFallLayoutColumn *column = self.columns[selectIndex];
        
        CGFloat height = [self.delegate collectionView:self.collectionView heightForItemAtIndexPath:indexPath];
        CGFloat x = column.x;
        CGFloat y = self.contentInsets.top + column.columnHeight + column.attributes.count * self.interItemSpace;
        //            CGFloat width = CGRectGetWidth(self.collectionView.bounds) / 2 - 30;
        CGFloat width = columnWidth;
        
        attribute.frame = CGRectMake(x, y, width, height);
        [column.attributes addObject:attribute];
        column.columnHeight += height;
        //            NSLog(@"select %@  index %@  height %@", @(selectIndex), @(indexPath.row), @(column.columnHeight));
        //            NSLog(@"height %@", @(column.columnHeight));
    }
    */
    //    }
    //    NSLog(@"finish");
}


#pragma mark - UICollectionViewLayout

- (CGSize)collectionViewContentSize {
//    CGFloat columnHeight = [self maxHeightForColumns:self.columns] + self.contentInsets.top + self.contentInsets.bottom;
    UICollectionViewLayoutAttributes *attribute = [self.attributeArray lastObject];
    CGFloat width = CGRectGetMaxX(attribute.frame) + self.itemSpace;
    width = MAX(width, CGRectGetWidth(self.collectionView.bounds)+ 1);
    //保证contentSize比bounds.height大，否则小于一页不能滚动
//    CGFloat height = MAX(columnHeight, CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top + 1);
    //    NSLog(@"columnHeight %@  columnBounds %@  columnInsets %@", @(columnHeight), NSStringFromCGRect(self.collectionView.bounds), NSStringFromUIEdgeInsets(self.collectionView.contentInset));
    //    NSLog(@"contentHeight %@", @(height));
    return CGSizeMake(width, CGRectGetHeight(self.collectionView.bounds));
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

@end
