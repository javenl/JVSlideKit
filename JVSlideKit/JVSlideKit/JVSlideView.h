//
//  JVSlideView.h
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import <UIKit/UIKit.h>

@class JVSlideView;

@protocol JVSlideViewDataSource <NSObject>

- (NSString *)slideView:(JVSlideView *)slideView identifierAtIndex:(NSInteger)index;

- (UICollectionViewCell *)slideView:(JVSlideView *)slideView updateCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index;

- (NSInteger)numberOfItemsInSlideView:(JVSlideView *)slideView;

@end

@protocol JVSlideViewDelegate <NSObject>

@optional

- (void)slideView:(JVSlideView *)slideView didSelectedAtIndex:(NSInteger)index;

- (void)slideView:(JVSlideView *)slideView didStopAtIndex:(NSInteger)index;

- (void)slideView:(JVSlideView *)slideView didChangeCenterIndex:(NSInteger)index;

@end

@interface JVSlideView : UIView

@property (nonatomic, weak) id <JVSlideViewDelegate> delegate;
@property (nonatomic, weak) id <JVSlideViewDataSource> dataSource;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemSpace;
@property (nonatomic, assign) BOOL forceCenterView;

@property (nonatomic, assign) BOOL scrollEnable;
@property (nonatomic, assign) BOOL bounces;

- (instancetype)initWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (void)reloadData;

- (void)startAutoSlideWithInterval:(NSInteger)interval;

- (void)stopAutoSlide;

#pragma mark - 

- (void)initSubviewsWithItemSize:(CGSize)itemSize itemSpace:(NSInteger)itemSpace;

@end