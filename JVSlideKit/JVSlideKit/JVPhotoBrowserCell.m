//
//  JVPhotoBrowserCell.m
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import "JVPhotoBrowserCell.h"

@interface JVPhotoBrowserCell ()


@end

@implementation JVPhotoBrowserCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imagePreviwer = [[JVImagePreviewer alloc] init];
        self.imagePreviwer.frame = self.bounds;
//        self.imagePreviwer.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.imagePreviwer];
        [self layoutIfNeeded];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imagePreviwer.frame = self.bounds;
}

#pragma mark - Method

- (void)updateCellWithObject:(id)obejct {
//    [self.imagePreviwer setPreviewImage:obejct];
}

#pragma mark - Reuse

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imagePreviwer.zoomScale = 1;
}

@end
