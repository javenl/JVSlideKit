//
//  JVSlideSegment.m
//  JVSlideKit
//
//  Created by liu on 15/10/10.
//
//

#import "JVSlideSegment.h"
#import "JVSlideSegmentTab.h"


@interface JVSlideSegment () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, assign, readwrite) NSInteger selectedIndex;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *segmentTabs;

@property (nonatomic, assign) BOOL needSetupSubviews;

//@property (nonatomic, strong) UIView *scrollViewMask;

@property (nonatomic, strong) CAGradientLayer *maskLayer;

@end


@implementation JVSlideSegment

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
//        self.scrollViewMask = [[UIView alloc] init];
//        self.scrollViewMask.frame = self.bounds;
//        [self addSubview:self.scrollViewMask];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.frame = self.bounds;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentInset = UIEdgeInsetsZero;
        [self addSubview:self.scrollView];
        
        self.cursorView = [[UIView alloc] init];
        self.cursorView.backgroundColor = self.cursorColor;
        [self.scrollView addSubview:self.cursorView];
        
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        id transparent = (id)[[UIColor clearColor] CGColor];
        id opaque = (id)[[UIColor blueColor] CGColor];
        maskLayer.colors = @[transparent, opaque, opaque, transparent];
        maskLayer.locations = @[@(0.0),@(0.0),@(1), @(1)];
        maskLayer.startPoint = CGPointMake(0, 0.5);
        maskLayer.endPoint = CGPointMake(1, 0.5);
        maskLayer.frame = self.scrollView.bounds;
        [self.layer setMask:maskLayer];
        self.maskLayer = maskLayer;
        
        [self initValues];
    }
    return self;
}

- (void)initValues {
    self.titleSpace = 8;
    self.cursorCornerRadius = 4.0f;
    self.cursorInset = UIEdgeInsetsMake(2, 2, 2, 2);
    self.textColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor blueColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.scrollViewMask.frame = self.bounds;
    self.scrollView.frame = self.bounds;
    self.maskLayer.frame = self.bounds;
//    CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
//    self.maskLayer.locations = @[@(0.0),@(rate),@(1-rate), @(1)];
    if (self.needSetupSubviews) {
        [self setupSubviews];
    }
    if (self.scrollView.contentSize.width > CGRectGetWidth(self.bounds) + self.maskWidth) {
        CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
        self.maskLayer.locations = @[@(0.0),@(0),@(1 - rate), @(1)];
    }
//    [self setupMaskLayerLocations];
}

- (void)setupMaskLayerLocations {
    if (self.scrollView.contentSize.width == 0) {
        return;
    }
    
//    CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
//    self.maskLayer.locations = @[@(0.0),@(rate),@(1-rate), @(1)];

    CGFloat left = 0;
    CGFloat right = 0;
    BOOL needReset = NO;
    
//    if (self.maskLayer.locations != nil) {
        left = [self.maskLayer.locations[1] doubleValue];
        right = [self.maskLayer.locations[2] doubleValue];
//    }
    
    if (self.scrollView.contentOffset.x <= self.maskWidth) {
        if (left != 0) {
            left = 0;
            needReset = YES;
        }
    }
//    NSLog(@"self.scrollView.contentOffset.x %@  self.scrollView.contentSize.width %@ CGRectGetWidth(self.scrollView.bounds) %@", @(self.scrollView.contentOffset.x), @(self.scrollView.contentSize.width), @(CGRectGetWidth(self.scrollView.bounds)));
    if (self.scrollView.contentOffset.x >= self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds) - self.maskWidth) {
        if (right != 1) {
            right = 1;
            needReset = YES;
        }
    }
    if (self.scrollView.contentOffset.x > self.maskWidth && self.scrollView.contentOffset.x < self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds) - self.maskWidth) {
        CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
        if ((int)(left * 1000) != (int)(rate * 1000)) {
            left = rate;
            needReset = YES;
        }
        if ((int)(right * 1000) != (int)((1 - rate) * 1000)) {
            right = 1 - rate;
            needReset = YES;
        }
    }
    if (needReset) {
        self.maskLayer.locations = @[@(0.0),@(left),@(right), @(1)];
    }
}

#pragma makr - Event

- (void)didTapView:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.scrollView];
    //    NSLog(@"tap point %@", NSStringFromCGPoint(point));
    for (int i = 0; i < self.segmentTabs.count; i++) {
        JVSlideSegmentTab *tab = self.segmentTabs[i];
        if (CGRectContainsPoint(tab.frame, point)) {
            [self didSelectTabAtIndex:i];
        }
    }
}

- (void)didSelectTabAtIndex:(NSInteger)index {
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - Method

- (void)setupSubviews {
    self.segmentTabs = [NSMutableArray arrayWithCapacity:self.titles.count];
    CGFloat totalWidth = 0;
    for (int i = 0; i < self.titles.count; i++) {
        JVSlideSegmentTab *tab = [[JVSlideSegmentTab alloc] init];
        tab.titleLabel.textColor = self.textColor;
        tab.titleLabel.highlightedTextColor = self.selectedTextColor;
        tab.titleLabel.text = self.titles[i];
        
        CGFloat width = 0;
        if (self.titleWidth != 0) {
            width = self.titleWidth;
        } else {
            width = ceil([tab.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:tab.titleLabel.font}].width) + 2 * self.titleSpace;
        }
        
        tab.frame = CGRectMake(totalWidth, 0, width, CGRectGetHeight(self.bounds));
        
        [self.scrollView addSubview:tab];
        [self.segmentTabs addObject:tab];
        
        if (i == 0) {
            tab.titleLabel.highlighted = YES;
            self.cursorView.frame = CGRectMake(self.cursorInset.left, self.cursorInset.top, width - (self.cursorInset.left + self.cursorInset.right), CGRectGetMaxY(self.scrollView.bounds)-self.cursorInset.bottom);
        }
        
        totalWidth += width;
    }
    
    self.needSetupSubviews = NO;
    
    JVSlideSegmentTab *tab = self.segmentTabs.lastObject;
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(tab.frame), CGRectGetHeight(self.scrollView.bounds));
//    [self setupMaskLayerLocations];
//    NSLog(@"frmae %@", NSStringFromCGRect(self.scrollView.bounds));
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    JVSlideSegmentTab *tab = self.segmentTabs[index];
    CGFloat tabX = CGRectGetMidX(tab.frame);
    CGFloat midScrollX = CGRectGetWidth(self.bounds)/2;
    CGFloat x = 0;
    
//    NSLog(@"tab.frame %@", NSStringFromCGRect(tab.frame));
    if (tabX - midScrollX < 0) {
        x = 0;
    } else if (tabX + midScrollX > self.scrollView.contentSize.width){
        x = self.scrollView.contentSize.width - midScrollX * 2;
        if (x < 0) {
            x = 0;
        }
    } else {
        x = tabX - midScrollX;
    }
    NSLog(@"x %@", @(x));
    CGPoint point = CGPointMake(x, 0);
    NSLog(@"point %@", NSStringFromCGPoint(point));
    NSLog(@"contentWidth %@", @(self.scrollView.contentSize.width));
    [self.scrollView setContentOffset:point animated:YES];
    
    [self setSelectedIndex:index animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setupMaskLayerLocations];
    /*
//    CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
    if (scrollView.contentOffset.x <= self.maskWidth) {
        if ([self.maskLayer.locations[1] integerValue] != 0) {
            CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
            self.maskLayer.locations = @[@(0.0),@(0),@(1-rate), @(1)];
        }
    }
    if (scrollView.contentOffset.x >= self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds)) {
        if ([self.maskLayer.locations[2] integerValue] != 1) {
            CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
            self.maskLayer.locations = @[@(0.0),@(0),@(1-rate), @(1)];
        }
        CGFloat rate = self.maskWidth / CGRectGetWidth(self.maskLayer.bounds);
        self.maskLayer.locations = @[@(0.0),@(rate),@(1), @(1)];
    } else {
        
        self.maskLayer.locations = @[@(0.0),@(rate),@(1-rate), @(1)];
    }
    */
}

#pragma mark - Properties

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (selectedIndex == _selectedIndex) {
        return;
    }
    
    NSInteger lastIndex = self.selectedIndex;
    JVSlideSegmentTab *lastTab = self.segmentTabs[lastIndex];
    //        NSLog(@"last Index %@", @(lastIndex));
    lastTab.titleLabel.highlighted = NO;
    
    _selectedIndex = selectedIndex;
    JVSlideSegmentTab *tab = self.segmentTabs[selectedIndex];
    tab.titleLabel.highlighted = YES;
    //        NSLog(@"tab frame %@", NSStringFromCGRect(tab.frame));
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.cursorView.frame = CGRectMake(CGRectGetMinX(tab.frame)+self.cursorInset.left, CGRectGetMinY(self.cursorView.frame), CGRectGetWidth(tab.frame)-(self.cursorInset.left+self.cursorInset.right), CGRectGetHeight(self.cursorView.frame));
        }];
    } else {
        self.cursorView.frame = CGRectMake(CGRectGetMinX(tab.frame)+self.cursorInset.left, CGRectGetMinY(self.cursorView.frame), CGRectGetWidth(tab.frame)-(self.cursorInset.left+self.cursorInset.right), CGRectGetHeight(self.cursorView.frame));
    }
    [self.delegate slideSegment:self didSelectedIndex:_selectedIndex];
    
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    for (JVSlideSegmentTab *tab in self.segmentTabs) {
        [tab removeFromSuperview];
    }
    [self.segmentTabs removeAllObjects];
    self.needSetupSubviews = YES;
    [self setNeedsLayout];
}

- (void)setMaskWidth:(CGFloat)maskWidth {
    _maskWidth = maskWidth;
    [self setNeedsLayout];
}

- (void)setCursorCornerRadius:(NSInteger)cursorCornerRadius {
    self.cursorView.layer.masksToBounds = YES;
    self.cursorView.layer.cornerRadius = cursorCornerRadius;
}

-(void)setHideCursor:(BOOL)hideCursor {
    self.cursorView.hidden = hideCursor;
}

- (void)setCursorColor:(UIColor *)cursorColor {
    _cursorColor = cursorColor;
    self.cursorView.backgroundColor = cursorColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (JVSlideSegmentTab *tab in self.segmentTabs) {
        tab.titleLabel.textColor = textColor;
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    for (JVSlideSegmentTab *tab in self.segmentTabs) {
        tab.titleLabel.highlightedTextColor = selectedTextColor;
    }
}

- (void)setTextSize:(CGFloat)textSize {
    _textSize = textSize;
    for (JVSlideSegmentTab *tab in self.segmentTabs) {
        tab.titleLabel.font = [UIFont systemFontOfSize:textSize];
    }
}

@end