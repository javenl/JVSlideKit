//
//  JVPhotoBrowser.h
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import <UIKit/UIKit.h>
#import "JVImagePreviewer.h"
#import "JVPhotoBrowserCell.h"

@class JVPhotoBrowserView;

@protocol JVPhotoBrowserDelegate <NSObject>

@optional
- (void)jvPhotoBrowser:(JVPhotoBrowserView *)browser didStopAtIndex:(NSInteger)index;
- (Class)customTableCell;

@end

@protocol JVPhotoBrowserDataSource <NSObject>

@optional
- (NSInteger)numberOfItemsInJVPhotoBrowser:(JVPhotoBrowserView *)browser;
- (void)jvPhotoBrowser:(JVPhotoBrowserView *)browser willShowCell:(JVPhotoBrowserCell *)cell atIndex:(NSInteger)index;

@end

@interface JVPhotoBrowserView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) id<JVPhotoBrowserDelegate> delegate;
@property (nonatomic, weak) id<JVPhotoBrowserDataSource> dataSource;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)setupItems:(NSArray *)items;
- (void)moveToIndex:(NSInteger)index;

- (void)insertItemAtIndex:(NSInteger)index;
- (void)removeItemAtIndex:(NSInteger)index;
- (void)reloadItemAtIndex:(NSInteger)index;
- (void)reloadData;

@end
