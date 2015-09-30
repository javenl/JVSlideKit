//
//  ViewController.m
//  JVSlideKit
//
//  Created by liu on 15/9/30.
//
//

#import "ViewController.h"
#import "JVSlideView.h"

@interface ViewController () <JVSlideViewDelegate, JVSlideViewDataSource>

@property (strong, nonatomic) JVSlideView *slideView;

@property (strong, nonatomic) NSArray *titles;

@end

static NSString *kIdentifier = @"SlideView";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.slideView = [[JVSlideView alloc] initWithItemSize:CGSizeMake(150, 150) itemSpace:10];
    self.slideView.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.frame), 300);
    self.slideView.delegate = self;
    self.slideView.dataSource = self;
//    self.slideView.pagingEnabled = YES;
    self.slideView.centerView = YES;
    [self.slideView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    [self.view addSubview:self.slideView];
    
    self.titles = @[@"a", @"b", @"c", @"d", @"e", @"f"];
//    self.titles = @[@"a", @"b"];
    
    [self.slideView reloadData];
    
//    NSLog(@"test %@", @(-4 % 4));
}

#pragma mark - SlideViewDataSource

- (NSInteger)numberOfItemsInSlideView:(JVSlideView *)slideView {
    return self.titles.count;
    return 10;
}

- (NSString *)slideView:(JVSlideView *)slideView identifierAtIndex:(NSInteger)index {
    return kIdentifier;
}

- (UICollectionViewCell *)slideView:(JVSlideView *)slideView updateCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    //    if (index % 2) {
    //        cell.backgroundColor = [UIColor redColor];
    //    } else {
    //        cell.backgroundColor = [UIColor yellowColor];
    //    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:35];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor yellowColor];
//    label.text = [NSString stringWithFormat:@"%@", @(index)];
    label.text = self.titles[index];
    //    NSInteger index = [self caculateIndexFromIndexPath:indexPath];
    //    label.text = self.titles[index];
    
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark - SlideViewDelegate

- (void)slideView:(JVSlideView *)slideView didSelectedAtIndex:(NSInteger)index {
    //    NSLog(@"tap at index %@", @(index));
}

- (void)slideView:(JVSlideView *)slideView didChangeCenterIndex:(NSInteger)index {
    //    NSLog(@"didChangeCenterIndex %@", @(index));
//    self.pageControl.currentPage = index;
}

- (void)slideView:(JVSlideView *)slideView didStopAtIndex:(NSInteger)index {
    //    NSLog(@"didStopAtIndex %@", @(index));
}


@end
