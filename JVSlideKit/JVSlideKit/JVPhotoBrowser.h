//
//  JVPhotoBrowser.h
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import <UIKit/UIKit.h>
#import "JVImagePreviewer.h"

@class JVPhotoBrowser;

@protocol JVPhotoBrowserDelegate <NSObject>

@optional
- (void)jvPhotoBrowser:(JVPhotoBrowser *)browser didStopAtIndex:(NSInteger)index;

@end

@protocol JVPhotoBrowserDataSource <NSObject>

@optional
- (NSInteger)numberOfItemsInJVPhotoBrowser:(JVPhotoBrowser *)browser;
- (void)jvPhotoBrowser:(JVPhotoBrowser *)browser willShowPreviewer:(JVImagePreviewer *)previewer atIndex:(NSInteger)index;

@end

@interface JVPhotoBrowser : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) id<JVPhotoBrowserDelegate> delegate;
@property (nonatomic, weak) id<JVPhotoBrowserDataSource> dataSource;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)setupItems:(NSArray *)items;
- (void)moveToIndex:(NSInteger)index;

@end
