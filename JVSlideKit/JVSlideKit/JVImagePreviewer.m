//
//  JVImagePreviewer.m
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import "JVImagePreviewer.h"

@interface JVImagePreviewer () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation JVImagePreviewer

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 3;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.backgroundColor = [UIColor greenColor];
        [self.scrollView addSubview:self.imageView];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *singeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
        singeTapGesture.numberOfTapsRequired = 1;
        [singeTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [self addGestureRecognizer:singeTapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

#pragma mark - Event

- (void)didSingleTap:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didSingleTapInJVImagePreviewer:)]) {
        [self.delegate didSingleTapInJVImagePreviewer:self];
    }
}

- (void)didDoubleTap:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:1 animated:YES];
    } else {
        CGFloat newZoomScale = (self.scrollView.maximumZoomScale + self.scrollView.minimumZoomScale) / 2;
        CGFloat xSize = self.scrollView.bounds.size.width / newZoomScale;
        CGFloat ySize = self.scrollView.bounds.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xSize / 2, touchPoint.y - ySize / 2, xSize, ySize) animated:YES];
    }
}

#pragma mark - Method

- (void)setPlaceHolderImage:(UIImage *)image {
//    self.scrollView.scrollEnabled = NO;
    self.imageView.image = image;
    [self resizeImageViewWithImage:image];
}

- (void)setPreviewImage:(UIImage *)image {
    self.imageView.image = image;
    [self resizeImageViewWithImage:image];
//    self.scrollView.scrollEnabled = YES;
}

- (void)resizeImageViewWithImage:(UIImage *)image {
    CGFloat screenAspectRatio = CGRectGetWidth(self.bounds) / CGRectGetHeight(self.bounds);
    CGFloat imageAspectRatio = image.size.width / image.size.height;
    
    if (screenAspectRatio > imageAspectRatio) { //
        //        self.imageView.frame = CGRectMake(0, 0, 100, 100);
        CGFloat ratio = image.size.height / CGRectGetHeight(self.bounds);
        CGFloat width = image.size.width / ratio;
        //        NSLog(@"imageSize %@ ratio %@ bounds %@ frame %@", NSStringFromCGSize(image.size), @(ratio), NSStringFromCGRect(self.bounds), NSStringFromCGRect(self.frame));
        self.imageView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds));
        self.scrollView.contentInset = UIEdgeInsetsMake(0, (CGRectGetWidth(self.bounds)-width)/2.0f, 0, 0);
    } else {
        CGFloat ratio = image.size.width / CGRectGetWidth(self.bounds);
        CGFloat height = image.size.height/ratio;
        //        NSLog(@"imageSize %@ ratio %@ bounds %@ frame %@", NSStringFromCGSize(image.size), @(ratio), NSStringFromCGRect(self.bounds), NSStringFromCGRect(self.frame));
        self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), height);
        self.scrollView.contentInset = UIEdgeInsetsMake((CGRectGetHeight(self.bounds)-height)/2.0f, 0, 0, 0);
    }
}

#pragma property

- (void)setZoomScale:(NSInteger)zoomScale {
    self.scrollView.zoomScale = zoomScale;
}

- (NSInteger)zoomScale {
    return self.scrollView.zoomScale;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat screenAspectRatio = CGRectGetWidth(self.bounds) / CGRectGetHeight(self.bounds);
    CGFloat imageAspectRatio = self.imageView.image.size.width / self.imageView.image.size.height;
    
    if (screenAspectRatio > imageAspectRatio) {

        CGFloat space = CGRectGetWidth(self.imageView.frame) - CGRectGetWidth(self.bounds);
//        NSLog(@"self.imageView.height %@ self.height %@", @(CGRectGetHeight(self.imageView.frame)), @(CGRectGetHeight(self.bounds)));
        if (space > 0) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, fabs(space) / 2.0, 0, 0);
        }
        
    } else {
        
        CGFloat space = CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.bounds);
//        NSLog(@"self.imageView.height %@ self.height %@", @(CGRectGetHeight(self.imageView.frame)), @(CGRectGetHeight(self.bounds)));
        if (space > 0) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(fabs(space) / 2.0, 0, 0, 0);
        }

    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
