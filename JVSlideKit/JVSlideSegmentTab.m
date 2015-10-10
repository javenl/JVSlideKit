//
//  JVSlideSegmentTab.m
//  JVSlideKit
//
//  Created by liu on 15/10/10.
//
//

#import "JVSlideSegmentTab.h"

@implementation JVSlideSegmentTab

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        //        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        self.titleLabel.highlightedTextColor = [UIColor redColor];
        //        self.titleLabel.textColor = [UIColor blueColor];
        [self addSubview:self.titleLabel];
        
        //        self.borderView = [[UIView alloc] init];
        //        self.borderView.translatesAutoresizingMaskIntoConstraints = NO;
        //        [self.contentView addSubview:self.borderView];
        
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(@(0));
//            make.left.width.equalTo(self);
//        }];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGSize fitSize = [self.titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    CGSize fitSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - fitSize.height) / 2, CGRectGetWidth(self.bounds), fitSize.height);
}

@end
