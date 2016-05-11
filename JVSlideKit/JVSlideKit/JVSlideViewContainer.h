//
//  JVSlideViewContainer.h
//  JVSlideKit
//
//  Created by liu on 15/10/20.
//
//

#import <UIKit/UIKit.h>

@class JVSlideViewContainer;

@protocol JVSlideViewContainerDelgate <NSObject>

- (void)slideViewContainer:(JVSlideViewContainer *)slideViewContainer didScrollToIndex:(NSInteger)index;

@end

@interface JVSlideViewContainer : UIView

@property (weak, nonatomic) id<JVSlideViewContainerDelgate> delgate;

@property (nonatomic, strong) NSArray *views;

@property (nonatomic, readonly) NSInteger currentIndex;

- (void)reloadData;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

//- (void)slideViewContainer:(JVSlideViewContainer *)slideViewContainer didScrollToIndex:(NSInteger)index;

@end
