//
//  TestPhotoBrowser.m
//  JVSlideKit
//
//  Created by liu on 16/6/1.
//
//

#import "TestPhotoBrowser.h"
#import "JVPhotoBrowser.h"

@interface TestPhotoBrowser () <JVPhotoBrowserDataSource, JVPhotoBrowserDelegate>

@property (strong, nonatomic) JVPhotoBrowser *photoBrowser;
//@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation TestPhotoBrowser

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [super scrollViewDidScroll:scrollView];
//    self.title = [NSString stringWithFormat:@"%@ / %@", @(self.currentIndex+1), @(self.items.count)];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.photoBrowser = [[JVPhotoBrowser alloc] initWithFrame:self.view.bounds];
    self.photoBrowser.delegate = self;
    self.photoBrowser.dataSource = self;
    [self.view addSubview:self.photoBrowser];
    
    UITapGestureRecognizer *singleTapGesrure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [singleTapGesrure requireGestureRecognizerToFail:doubleTapGesture];
    singleTapGesrure.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGesrure];
    [self.view addGestureRecognizer:doubleTapGesture];
}

#pragma mark - Event

- (void)didSingleTap:(UITapGestureRecognizer *)gesture {
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    }
}

- (void)didDoubleTap:(UITapGestureRecognizer *)gesture {
    
}

#pragma mark - JVPhotoBrowserDataSource

- (NSInteger)numberOfItemsInJVPhotoBrowser:(JVPhotoBrowser *)browser {
    return 5;
}

- (void)jvPhotoBrowser:(JVPhotoBrowser *)browser willShowPreviewer:(JVImagePreviewer *)previewer atIndex:(NSInteger)index {
    [previewer setPlaceHolderImage:[UIImage imageNamed:@"a004.jpg"]];
}

#pragma mark - JVPhotoBrowserDelegate

- (void)jvPhotoBrowser:(JVPhotoBrowser *)browser didStopAtIndex:(NSInteger)index {
    self.title = [NSString stringWithFormat:@"%@ / %@", @(index+1), @(5)];
}

@end
