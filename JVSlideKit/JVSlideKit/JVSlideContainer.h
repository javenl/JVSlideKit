//
//  JVSlideContainer.h
//  JVSlideKit
//
//  Created by liu on 15/10/14.
//
//

#import <UIKit/UIKit.h>


@interface JVSlideContainer : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, readonly) NSInteger currentIndex;

- (void)reloadData;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

- (void)slideContainer:(JVSlideContainer *)slideContainer didScrollToIndex:(NSInteger)index;

@end
