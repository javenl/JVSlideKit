//
//  JVPhotoBrowserCell.m
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import "JVPhotoBrowserCell.h"

@interface JVPhotoBrowserCell () <UIScrollViewDelegate>

//@property (strong, nonatomic)

@end

@implementation JVPhotoBrowserCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imagePreviwer = [[JVImagePreviewer alloc] init];
        self.imagePreviwer.frame = self.bounds;
//        self.imagePreviwer.backgroundColor = [UIColor yellowColor];
//        self.imagePreviwer.delegate = self;
        [self.contentView addSubview:self.imagePreviwer];
        [self layoutIfNeeded];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imagePreviwer.frame = self.bounds;
//    self.imagePreviwer.imageView.frame = self.bounds;
//    self.imagePreviwer.imageView.frame = CGRectMake(0, CGRectGetWidth(<#CGRect rect#>), <#CGFloat width#>, <#CGFloat height#>)  = self.imagePreviwer.frame.center;
}
/*
#pragma mark - UIScorllViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scale %@", @(scrollView.zoomScale));
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"scrollView.contentSize %@", NSStringFromCGSize(scrollView.contentSize));
//    CGFloat maxWidth = CGRectGetWidth(self.imagePreviwer.imageView.frame);
//    CGFloat maxHeight = CGRectGetHeight(self.imagePreviwer.imageView.frame);
//    CGFloat width = scrollView.contentSize.width < maxWidth ? scrollView.contentSize.width : maxWidth;
//    CGFloat height = scrollView.contentSize.height < maxHeight ? scrollView.contentSize.height : maxHeight;
//    scrollView.contentSize = CGSizeMake(width, height);
//    NSLog(@"scrollView.contentSize %@", NSStringFromCGSize(scrollView.contentSize));
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return self.imagePreviwer.imageView;
//}
*/

#pragma mark - Method

- (void)updateCellWithObject:(id)obejct {
//    self.imagePreviwer.imageView.image = [UIImage imageNamed:@"a004.jpg"];
    [self.imagePreviwer setPreviewImage:obejct];
//    UIImage *image = obejct;
//    CGFloat ratio = CGRectGetWidth(self.bounds) / CGRectGetHeight(self.bounds);
//    CGFloat height = image.size.height * ratio;
//    CGRect frame = CGRectMake(0, (CGRectGetHeight(self.bounds)-height)/2.0f, CGRectGetWidth(self.bounds), height);
//    self.imagePreviwer.imageView.frame = frame;
//    NSLog(@"imageView.frame %@", NSStringFromCGRect(frame));
}

#pragma mark - Reuse

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imagePreviwer.zoomScale = 1;
//    self.imagePreviwer.contentInset = UIEdgeInsetsZero;
//    self.imagePreviwer.frame = self.bounds;
//    self.imagePreviwer.frame = CGRectZero;
//    self.scrollView.contentSize = CGSizeZero;
//    self.scrollView.contentOffset = CGPointZero;
}

@end
