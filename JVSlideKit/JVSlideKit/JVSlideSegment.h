//
//  JVSlideSegment.h
//  JVSlideKit
//
//  Created by liu on 15/10/10.
//
//

#import <UIKit/UIKit.h>

@class JVSlideSegment;

@protocol JVSlideSegmentDelegate <NSObject>

- (void)slideSegment:(JVSlideSegment *)segment didSelectedIndex:(NSInteger)index;

@end

@interface JVSlideSegment : UIView

@property (nonatomic, weak) id <JVSlideSegmentDelegate> delegate;

@property (nonatomic, copy) NSArray *titles;

/** Default 8.0 */
@property (nonatomic, assign) CGFloat titleSpace;

/** Default 0, if titleWidth = 0, titleWidth is autofit */
@property (nonatomic, assign) CGFloat titleWidth;

@property (nonatomic, assign) CGFloat textSize;

@property (nonatomic, strong) UIColor *cursorColor;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *selectedTextColor;

/** Default 0 */
@property (nonatomic, assign) CGFloat maskWidth;

/** Default UIEdgeInsetsMake(2, 2, 2, 2) */
@property (nonatomic, assign) UIEdgeInsets cursorInset;

/** Default 4.0 */
@property (nonatomic, assign) NSInteger cursorCornerRadius;

@property (nonatomic, assign, getter=isHideCursor) BOOL hideCursor;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end
