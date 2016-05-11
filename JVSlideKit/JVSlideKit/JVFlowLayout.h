//
//  JVFlowLayout.h
//  JVSlideKit
//
//  Created by liu on 15/10/12.
//
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewDelegateJVLinearLayout <NSObject>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JVFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id <UICollectionViewDelegateJVLinearLayout> delegate;

/**
 *  Default is 10
 */
@property (nonatomic, assign) CGFloat itemSpace;

@end
