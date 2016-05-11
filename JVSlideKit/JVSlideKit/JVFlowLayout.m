//
//  JVFlowLayout.m
//  JVSlideKit
//
//  Created by liu on 15/10/12.
//
//

#import "JVFlowLayout.h"

@interface JVFlowInsertPoint : NSObject

@property (assign, nonatomic) CGPoint point;
@property (assign, nonatomic) CGFloat reaminWidth;

@end

@interface JVFlowLayout ()

@property (nonatomic, readwrite) NSInteger itemCount;

@property (nonatomic, strong) NSMutableArray *attributeArray;

@property (nonatomic, strong) NSMutableArray *insertPoints;

@end

@implementation JVFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        //        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        //        self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        self.isHorizontal = YES;
        self.itemSpace = 10;
        self.attributeArray = [NSMutableArray array];
        self.insertPoints = [NSMutableArray array];
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
    
    CGFloat maxX = 0;
    CGFloat minY = 0;
    CGFloat maxY = 0;
    
    for (NSInteger i = 0; i < self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        CGFloat contentWidth = CGRectGetWidth(self.collectionView.bounds) - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
        
        NSAssert(itemSize.width < contentWidth, @"itemSize.width should not lager than collectionView width");
        
        CGFloat widthRemain = contentWidth - maxX;
        if (itemSize.width <= widthRemain) {
            attribute.frame = CGRectMake(maxX, minY, itemSize.width, itemSize.height);
            CGFloat afterWidth = maxX + itemSize.width + self.itemSpace;
            if (afterWidth >= contentWidth) {
                if (minY + itemSize.height < maxY) {
//                    maxX
                }
            }

            if (maxX > widthRemain) {
//                maxX = 0;
            }
        } else {
            attribute.frame = CGRectMake(0, maxY, itemSize.width, itemSize.height);
            maxX = itemSize.width + self.itemSpace;
            
//            CGFloat widthRemain = contentWidth - maxX - self.itemSpace;
            if (widthRemain <= 0) {
//                maxY =
            }
        }
        
        maxY = MAX(minY + itemSize.height + self.itemSpace, itemSize.height);
        
        
        maxY = maxY + itemSize.height + self.itemSpace;
//        maxX = maxX
     
        /*
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
        */
        [self.attributeArray addObject:attribute];
    }
}


#pragma mark - UICollectionViewLayout

- (CGSize)collectionViewContentSize {
    //保证contentSize比bounds.height大，否则小于一页不能滚动
    UICollectionViewLayoutAttributes *attribute = [self.attributeArray lastObject];
    
//    if (self.isHorizontal) {
        CGFloat width = CGRectGetMaxX(attribute.frame) + self.itemSpace;
        width = MAX(width, CGRectGetWidth(self.collectionView.bounds)+ 1);
        return CGSizeMake(width, CGRectGetHeight(self.collectionView.bounds));
//    } else {
        CGFloat height = CGRectGetMaxY(attribute.frame) + self.itemSpace;
        height = MAX(height, CGRectGetHeight(self.collectionView.bounds)+ 1);
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height);
//    }
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
