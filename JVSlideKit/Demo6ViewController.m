//
//  Demo6ViewController.m
//  JVSlideKit
//
//  Created by liu on 16/5/31.
//
//

#import "Demo6ViewController.h"
#import "JVPhotoBrowserView.h"
#import "JVImagePreviewer.h"
#import "TestPhotoBrowser.h"

@interface Demo6ViewController () <JVPhotoBrowserDelegate, JVPhotoBrowserDataSource>

//@property (nonatomic, strong) JVPhotoBrowser *photoBrowser;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) JVImagePreviewer *imagePreviewer;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation Demo6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.btn = [[UIButton alloc] init];
    [self.btn setTitle:@"Test" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(didTapTest) forControlEvents:UIControlEventTouchUpInside];
    self.btn.frame = CGRectMake(50, 100, 200, 60);
    [self.view addSubview:self.btn];
    
    self.imagePreviewer = [[JVImagePreviewer alloc] init];
    self.imagePreviewer.frame = CGRectMake(0, 150, CGRectGetWidth(self.view.bounds), 300);
    self.imagePreviewer.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.imagePreviewer];
    
    self.btn2 = [[UIButton alloc] init];
    [self.btn2 setTitle:@"Test2" forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(didTapTest2) forControlEvents:UIControlEventTouchUpInside];
    self.btn2.frame = CGRectMake(50, 470, 200, 60);
    [self.view addSubview:self.btn2];
    
    self.btn3 = [[UIButton alloc] init];
    [self.btn3 setTitle:@"Test3" forState:UIControlStateNormal];
    [self.btn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btn3 addTarget:self action:@selector(didTapTest3) forControlEvents:UIControlEventTouchUpInside];
    self.btn3.frame = CGRectMake(50, 550, 200, 60);
    [self.view addSubview:self.btn3];
    
}

#pragma mark - Event

- (void)didTapTest {
    [self.imagePreviewer setPreviewImage:[UIImage imageNamed:@"a004.jpg"]];
}

- (void)didTapTest2 {
    self.photos = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
//        int index = arc4random() % 7 + 4;
        NSString *name = [NSString stringWithFormat:@"a0%02d.jpg", i+4];
        UIImage *image = [UIImage imageNamed:name];
        [self.photos addObject:image];
    }

    TestPhotoBrowser *photoBrowser = [[TestPhotoBrowser alloc] init];
//    [photoBrowser setupItems:self.photos];
//    [photoBrowser moveToIndex:5];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

- (void)didTapTest3 {
    TestPhotoBrowser *photoBrowser = [[TestPhotoBrowser alloc] init];
//    photoBrowser.delegate = self;
//    photoBrowser.dataSource = self;
//    [photoBrowser moveToIndex:3];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

#pragma mark - JVPhotoBrowserDataSource

- (NSInteger)numberOfItemsInJVPhotoBrowser:(JVPhotoBrowserView *)browser {
    return 5;
}

- (void)jvPhotoBrowser:(JVPhotoBrowserView *)browser willShowPreviewer:(JVImagePreviewer *)previewer atIndex:(NSInteger)index {
    [previewer setPlaceHolderImage:[UIImage imageNamed:@"a004.jpg"]];
}

#pragma mark - JVPhotoBrowserDelegate



@end
