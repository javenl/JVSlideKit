//
//  JVPhotoBrowserCell.h
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import <UIKit/UIKit.h>
#import "JVImagePreviewer.h"

@interface JVPhotoBrowserCell : UICollectionViewCell

@property (strong, nonatomic) JVImagePreviewer *imagePreviwer;

- (void)updateCellWithObject:(id)obejct;

@end
