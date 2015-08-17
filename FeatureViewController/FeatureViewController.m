//
//  FeatureViewController.m
//  FeatureViewController
//
//  Created by David_Tian on 15/8/17.
//  Copyright (c) 2015年 com.ifenghui. All rights reserved.
//

#import "FeatureViewController.h"

@interface FeatureViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *backgroundImageNames;
@property (nonatomic, strong) NSArray *coverImageNames;
@property (nonatomic, strong) NSArray *backgroundViews;
@property (nonatomic, strong) NSArray *scrollViewPages;

@end

@implementation FeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    self.backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    
    [self addBackgroundViews];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self reloadPages];
}

- (NSArray *)scrollViewPages {
    if (_scrollViewPages) {
        return _scrollViewPages;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.coverImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:obj]];
        CGSize size = [UIScreen mainScreen].bounds.size;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, size.width, size.height);
        [tempArray addObject:imgView];
    }];
    _scrollViewPages = tempArray;
    return _scrollViewPages;
}

- (void)addBackgroundViews {
    CGRect frame = self.view.bounds;
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    //    [[[_backgroundImageNames reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    //        imageView.image = [UIImage imageNamed:obj];
    //        imageView.tag = idx+1;
    //        [tmpArray addObject:imageView];
    //        [self.view addSubview:imageView];
    //    }];
    //    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
    
    for (NSString *bgImgName in _backgroundImageNames) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bgImgName]];
        imgView.frame = frame;
        [tmpArray addObject:imgView];
        [self.view addSubview:imgView];
    }
    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
}

- (void)reloadPages {
    
    UIView *view = [[self scrollViewPages] firstObject];
    CGSize size = CGSizeMake(view.frame.size.width * self.scrollViewPages.count, view.frame.size.height);
    self.scrollView.contentSize = size;
    
    __block CGFloat x = 0;
    [self.scrollViewPages enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectOffset(obj.frame, x, 0);
        [self.scrollView addSubview:obj];
        x += obj.frame.size.width;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
    CGFloat alpha = 1-(scrollView.contentOffset.x - index*self.view.frame.size.width)/self.view.frame.size.width;
    
    if ([self.backgroundViews count] > index) {
        UIView *v = [self.backgroundViews objectAtIndex:index];
        if (v) {
            [v setAlpha:alpha];
        }
    }
}

@end
