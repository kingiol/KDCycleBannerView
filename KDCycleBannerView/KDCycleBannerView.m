//
//  KDCycleBannerView.m
//  KDCycleBannerViewDemo
//
//  Created by Kingiol on 14-4-11.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import "KDCycleBannerView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface KDCycleBannerView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL scrollViewBounces;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *datasourceImages;
@property (assign, nonatomic) NSUInteger currentSelectedPage;

@property (strong, nonatomic) CompleteBlock completeBlock;

@end

@implementation KDCycleBannerView

static void *kContentImageViewObservationContext = &kContentImageViewObservationContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollViewBounces = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _scrollViewBounces = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self initialize];
    
    if (self.completeBlock) {
        self.completeBlock();
    }
}

- (void)initialize {
    self.clipsToBounds = YES;
    
    [self initializeScrollView];
    [self initializePageControl];
    
    [self loadData];
    
    // progress autoPlayTimeInterval
    if (self.autoPlayTimeInterval > 0) {
        if ((self.isContinuous && _datasourceImages.count > 3) || (!self.isContinuous &&_datasourceImages.count > 1)) {
            [self performSelector:@selector(autoSwitchBannerView) withObject:nil afterDelay:self.autoPlayTimeInterval];
        }
    }
}

- (void)initializeScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    [self addSubview:_scrollView];
}

- (void)initializePageControl {
    CGRect pageControlFrame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 30);
    _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    _pageControl.center = CGPointMake(CGRectGetWidth(_scrollView.frame)*0.5, CGRectGetHeight(_scrollView.frame) - 12.);
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)loadData {
    NSAssert(_datasource != nil, @"datasource must not nil");
    _datasourceImages = [_datasource numberOfKDCycleBannerView:self];
    
    if (_datasourceImages.count == 0) {
        //显示默认页，无数据页面
        if ([self.datasource respondsToSelector:@selector(placeHolderImageOfZeroBannerView)]) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = [self.datasource placeHolderImageOfZeroBannerView];
            [_scrollView addSubview:imageView];
        }
        return;
    }
    
    _pageControl.numberOfPages = _datasourceImages.count;
    _pageControl.currentPage = 0;
    
    if (self.isContinuous) {
        NSMutableArray *cycleDatasource = [_datasourceImages mutableCopy];
        [cycleDatasource insertObject:[_datasourceImages lastObject] atIndex:0];
        [cycleDatasource addObject:[_datasourceImages firstObject]];
        _datasourceImages = [cycleDatasource copy];
    }
    
    CGFloat contentWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat contentHeight = CGRectGetHeight(_scrollView.frame);
    
    _scrollView.contentSize = CGSizeMake(contentWidth * _datasourceImages.count, contentHeight);
    
    for (NSInteger i = 0; i < _datasourceImages.count; i++) {
        CGRect imgRect = CGRectMake(contentWidth * i, 0, contentWidth, contentHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imgRect];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = [_datasource contentModeForImageIndex:i];
        
        id imageSource = [_datasourceImages objectAtIndex:i];
        if ([imageSource isKindOfClass:[UIImage class]]) {
            imageView.image = imageSource;
        }else if ([imageSource isKindOfClass:[NSString class]] || [imageSource isKindOfClass:[NSURL class]]) {
            UIActivityIndicatorView *activityIndicatorView = [UIActivityIndicatorView new];
            activityIndicatorView.center = CGPointMake(CGRectGetWidth(_scrollView.frame) * 0.5, CGRectGetHeight(_scrollView.frame) * 0.5);
            activityIndicatorView.tag = 100;
            activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [activityIndicatorView startAnimating];
            [imageView addSubview:activityIndicatorView];
            [imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:kContentImageViewObservationContext];
            
            if ([self.datasource respondsToSelector:@selector(placeHolderImageOfBannerView:atIndex:)]) {
                UIImage *placeHolderImage = [self.datasource placeHolderImageOfBannerView:self atIndex:i];
                NSAssert(placeHolderImage != nil, @"placeHolderImage must not be nil");
                [imageView setImageWithURL:[imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource placeholderImage:placeHolderImage];
            }else {
                [imageView setImageWithURL:[imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource];
            }
            
        }
        [_scrollView addSubview:imageView];
    }
    
    if (self.isContinuous && _datasourceImages.count > 1) {
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
    }
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
}

- (void)reloadDataWithCompleteBlock:(CompleteBlock)competeBlock {
    self.completeBlock = competeBlock;
    [self setNeedsLayout];
}

- (void)moveToTargetPosition:(CGFloat)targetX withAnimated:(BOOL)animated {
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    NSInteger page = MIN(_datasourceImages.count - 1, MAX(0, currentPage));
    
    [self setSwitchPage:page animated:animated withUserInterface:YES];
}

- (void)setSwitchPage:(NSInteger)switchPage animated:(BOOL)animated withUserInterface:(BOOL)userInterface {
    
    NSInteger page = -1;
    
    if (userInterface) {
        page = switchPage;
    }else {
        _currentSelectedPage++;
        page = _currentSelectedPage % (self.isContinuous ? (_datasourceImages.count - 1) : _datasourceImages.count);
    }
    
    if (self.isContinuous) {
        if (_datasourceImages.count > 1) {
            if (page >= (_datasourceImages.count -2)) {
                page = _datasourceImages.count - 3;
                _currentSelectedPage = 0;
                [self moveToTargetPosition:CGRectGetWidth(_scrollView.frame) * (page + 2) withAnimated:animated];
            }else {
                [self moveToTargetPosition:CGRectGetWidth(_scrollView.frame) * (page + 1) withAnimated:animated];
            }
        }else {
            [self moveToTargetPosition:0 withAnimated:animated];
        }
    }else {
        [self moveToTargetPosition:CGRectGetWidth(_scrollView.frame) * page withAnimated:animated];
    }
    
    [self scrollViewDidScroll:_scrollView];
}

- (void)autoSwitchBannerView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchBannerView) object:nil];
    
    [self setSwitchPage:-1 animated:YES withUserInterface:NO];
    
    [self performSelector:_cmd withObject:nil afterDelay:self.autoPlayTimeInterval];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kContentImageViewObservationContext) {
        UIImageView *imageView = (UIImageView *)object;
        UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)[imageView viewWithTag:100];
        [activityIndicatorView removeFromSuperview];
        [imageView removeObserver:self forKeyPath:@"image"];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat targetX = scrollView.contentOffset.x;
    
    CGFloat item_width = CGRectGetWidth(scrollView.frame);
    
    if (self.isContinuous && _datasourceImages.count >= 3) {
        if (targetX >= item_width * (_datasourceImages.count - 1)) {
            targetX = item_width;
            _scrollView.contentOffset = CGPointMake(targetX, 0);
        }else if (targetX <= 0) {
            targetX = item_width * (_datasourceImages.count - 2);
            _scrollView.contentOffset = CGPointMake(targetX, 0);
        }
    }
    
    NSInteger page = (scrollView.contentOffset.x + item_width * 0.5) / item_width;
    
    if (self.isContinuous && _datasourceImages.count > 1) {
        page--;
        if (page >= _pageControl.numberOfPages) {
            page = 0;
        }else if (page < 0) {
            page = _pageControl.numberOfPages - 1;
        }
    }
    
    _currentSelectedPage = page;
    
    if (page != _pageControl.currentPage) {
        if ([self.delegate respondsToSelector:@selector(cycleBannerView:didScrollToIndex:)]) {
            [self.delegate cycleBannerView:self didScrollToIndex:page];
        }
    }
    
    _pageControl.currentPage = page;
}

#pragma mark - UIGestureRecognizerDelegate

#pragma mark - UITapGestureRecognizerSelector

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    
    NSInteger page = (NSInteger)(_scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame));
    
    if ([self.delegate respondsToSelector:@selector(cycleBannerView:didSelectedAtIndex:)]) {
        [self.delegate cycleBannerView:self didSelectedAtIndex:self.isContinuous ? --page : page];
    }
}

@end
