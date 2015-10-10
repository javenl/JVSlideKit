//
//  Demo2ViewController.m
//  JVSlideKit
//
//  Created by liu on 15/10/9.
//
//

#import "Demo2ViewController.h"
#import "JVSlideView.h"
#import "JVSlideLoopView.h"

@interface Demo2ViewController () <JVSlideViewDelegate, JVSlideViewDataSource>

@property (strong, nonatomic) JVSlideLoopView *slideLoopView;

@property (strong, nonatomic) NSArray *titles;

@end

static NSString *kIdentifier = @"SlideLoopViewCell";

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.slideLoopView = [[JVSlideLoopView alloc] initWithItemSize:CGSizeMake(150, 150) itemSpace:10];
    self.slideLoopView.frame = CGRectMake(0, 64 + 20, CGRectGetWidth(self.view.frame), 300);
    self.slideLoopView.delegate = self;
    self.slideLoopView.dataSource = self;
    //    self.slideView.pagingEnabled = YES;
    self.slideLoopView.forceCenterView = YES;
    [self.slideLoopView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    [self.view addSubview:self.slideLoopView];
    
    self.titles = @[@"A1", @"B2", @"C3", @"D4", @"E5", @"F6", @"G7"];
    
    [self.slideLoopView reloadData];
    
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.slideLoopView.bounds)/2, 0, 1, CGRectGetHeight(self.view.bounds))];
    centerLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:centerLine];
    
    [self.slideLoopView startAutoSlideWithInterval:5];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.slideLoopView stopAutoSlide];
}

#pragma mark - SlideViewDataSource

- (NSInteger)numberOfItemsInSlideView:(JVSlideView *)slideView {
    return self.titles.count;
}

- (NSString *)slideView:(JVSlideView *)slideView identifierAtIndex:(NSInteger)index {
    return kIdentifier;
}

- (UICollectionViewCell *)slideView:(JVSlideView *)slideView updateCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:35];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor yellowColor];
    label.text = self.titles[index];
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark - SlideViewDelegate

- (void)slideView:(JVSlideView *)slideView didSelectedAtIndex:(NSInteger)index {
    NSLog(@"tap at index %@", @(index));
}

- (void)slideView:(JVSlideView *)slideView didChangeCenterIndex:(NSInteger)index {
    NSLog(@"didChangeCenterIndex %@", @(index));
}

- (void)slideView:(JVSlideView *)slideView didStopAtIndex:(NSInteger)index {
    NSLog(@"didStopAtIndex %@", @(index));
}



@end
