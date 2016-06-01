//
//  TestPhotoBrowser.m
//  JVSlideKit
//
//  Created by liu on 16/6/1.
//
//

#import "TestPhotoBrowser.h"

@interface TestPhotoBrowser ()

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation TestPhotoBrowser

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    self.title = [NSString stringWithFormat:@"%@ / %@", @(self.currentIndex+1), @(self.items.count)];
}

@end
