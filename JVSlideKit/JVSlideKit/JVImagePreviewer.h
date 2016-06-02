//
//  JVImagePreviewer.h
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import <UIKit/UIKit.h>

@interface JVImagePreviewer : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) NSInteger zoomScale;

- (void)setPlaceHolderImage:(UIImage *)image;
- (void)setPreviewImage:(UIImage *)image;

@end
