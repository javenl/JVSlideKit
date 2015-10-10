//
//  Demo4ViewController.m
//  JVSlideKit
//
//  Created by liu on 15/10/10.
//
//

#import "Demo4ViewController.h"
#import "JVSlideSegment.h"


@interface Demo4ViewController () <JVSlideSegmentDelegate>

@property (nonatomic, strong) JVSlideSegment *segment;

@property (nonatomic, strong) JVSlideSegment *segment2;

@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation Demo4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.segment = [[JVSlideSegment alloc] init];
    self.segment.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 44);
    self.segment.delegate = self;
    self.segment.cursorColor = [UIColor yellowColor];
    self.segment.selectedTextColor = [UIColor redColor];
    [self.view addSubview:self.segment];
    
    
    self.segment2 = [[JVSlideSegment alloc] init];
    self.segment2.frame = CGRectMake(0, 200, CGRectGetWidth(self.view.bounds), 44);
    self.segment2.delegate = self;
    self.segment2.cursorColor = [UIColor yellowColor];
    self.segment2.selectedTextColor = [UIColor redColor];
    self.segment2.titleWidth = CGRectGetWidth(self.view.bounds) / 5;
    [self.view addSubview:self.segment2];
    
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextBtn.frame = CGRectMake(0, 64 + 10, 60, 44);
    [self.nextBtn setTitle:@"next" forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(didTapNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    NSArray *titles = @[@"avaer", @"cwet", @"we", @"ccwmoriwr", @"fwcwet", @"wcaefwt", @"wwcwet", @"fwcetvrt", @"oewpr"];
    self.segment.titles = titles;
    
    NSArray *titles2 = @[@"1", @"2", @"3", @"4", @"5"];
    self.segment2.titles = titles2;
}

#pragma mark - Event

- (void)didTapNext {
    NSInteger index = self.segment.selectedIndex + 1;
    if (index >= self.segment.titles.count) {
        index = 0;
    }
    [self.segment scrollToIndex:index animated:YES];
    
    NSInteger index2 = self.segment2.selectedIndex + 1;
    if (index2 >= self.segment2.titles.count) {
        index2 = 0;
    }
    [self.segment2 scrollToIndex:index2 animated:YES];
}

#pragma mark - DDSlideSegmentDelegate

- (void)slideSegment:(JVSlideSegment *)segment didSelectedIndex:(NSInteger)index {
//    [self scrollToIndex:index animated:YES];
}


@end
