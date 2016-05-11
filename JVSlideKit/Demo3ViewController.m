//
//  Demo3ViewController.m
//  JVSlideKit
//
//  Created by liu on 15/10/9.
//
//

#import "Demo3ViewController.h"
#import "JVBannerView.h"

@interface Demo3ViewController () <JVSlideViewDelegate, JVSlideViewDataSource>

@property (strong, nonatomic) JVBannerView *bannerView;

@property (strong, nonatomic) NSArray *titles;

@end

static NSString *kIdentifier = @"BannerCell";

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame), 300);
    self.bannerView = [[JVBannerView alloc] initWithItemSize:size itemSpace:0];
    self.bannerView.frame = CGRectMake(0, 64 + 20, CGRectGetWidth(self.view.frame), 300);
    self.bannerView.delegate = self;
    self.bannerView.dataSource = self;
//    self.bannerView.pagingEnabled = YES;
    self.bannerView.loop = YES;
    self.bannerView.forceCenterView = YES;
    [self.bannerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
    [self.view addSubview:self.bannerView];
    
    self.titles = @[@"A1", @"B2", @"C3", @"D4", @"E5", @"F6", @"G7"];
    
//    self.titles = @[@"A1", @"B2", @"C3"];
    
    [self.bannerView reloadData];
    
    [self.bannerView startAutoSlideWithInterval:3];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.bannerView stopAutoSlide];
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
//    label.backgroundColor = [UIColor yellowColor];
    label.text = self.titles[index];
    [cell.contentView addSubview:label];
    
    switch (index) {
        case 0:
            cell.contentView.backgroundColor = [UIColor yellowColor];
            break;
        case 1:
            cell.contentView.backgroundColor = [UIColor brownColor];
            break;
        case 2:
            cell.contentView.backgroundColor = [UIColor orangeColor];
            break;
        case 3:
            cell.contentView.backgroundColor = [UIColor grayColor];
            break;
        case 4:
            cell.contentView.backgroundColor = [UIColor redColor];
            break;
        case 5:
            cell.contentView.backgroundColor = [UIColor purpleColor];
            break;
        case 6:
            cell.contentView.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
    
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
