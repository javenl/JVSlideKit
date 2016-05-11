//
//  JVLinearLayout.h
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewDelegateJVLinearLayout <NSObject>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JVLinearLayout : UICollectionViewLayout

@property (nonatomic, weak) id <UICollectionViewDelegateJVLinearLayout> delegate;

@property (nonatomic, assign) BOOL isHorizontal; //default is YES

/**
 *  Default is 10
 */
@property (nonatomic, assign) CGFloat itemSpace;


@end
