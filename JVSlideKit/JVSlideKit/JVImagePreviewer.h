//
//  JVImagePreviewer.h
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import <UIKit/UIKit.h>

@class JVImagePreviewer;

@protocol JVImagePreviewerDelegate <NSObject>

@optional
- (void)didSingleTapInJVImagePreviewer:(JVImagePreviewer *)previewer;

@end

@interface JVImagePreviewer : UIView

@property (weak, nonatomic) id <JVImagePreviewerDelegate> delegate;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) NSInteger zoomScale;

- (void)setPlaceHolderImage:(UIImage *)image;
- (void)setPreviewImage:(UIImage *)image;

@end
