//
//  JVFlowLayout.h
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewDelegateJVFlowLayout <NSObject>

//- (CGFloat)collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

//- (NSInteger)numberOfitemsWithCollectionView:(UICollectionView *)collectionView;

@end

@interface JVFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id <UICollectionViewDelegateJVFlowLayout> delegate;

//@property (nonatomic, readonly) NSUInteger columnCount;

//@property (nonatomic, readonly) CGFloat columnWidth;

@property (nonatomic, assign) BOOL isHorizontal; //default is YES

/**
 *  Default is UIEdgeInsetsMake(10, 10, 10, 10);
 */
//@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 *  Default is 10
 */
@property (nonatomic, assign) CGFloat itemSpace;

/**
 *  Default is 10
 */
//@property (nonatomic, assign) CGFloat columnSpace;

@end
