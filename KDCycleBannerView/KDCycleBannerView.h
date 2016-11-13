//
//  KDCycleBannerView.h
//  KDCycleBannerViewDemo
//
//  Created by Kingiol on 14-4-11.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDCycleBannerView;

typedef void(^CompleteBlock)(void);

@protocol KDCycleBannerViewDataSource <NSObject>

@required
/**
 @return Array of UIImage or NSString or NSURL objects with direct image data objects or URLs to images.
 Heterogeneous array is also allowed, that is with different types of items.
 */
- (NSArray *)dataForCycleBannerView:(KDCycleBannerView *)bannerView;
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index;

@optional
- (UIImage *)placeHolderImageOfZeroBannerView;
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index;

@end

@protocol KDCycleBannerViewDelegate <NSObject>

@optional
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index;
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index;

@end

@interface KDCycleBannerView : UIView

// Delegate and Datasource
@property (weak, nonatomic) IBOutlet id<KDCycleBannerViewDataSource> datasource;
@property (weak, nonatomic) IBOutlet id<KDCycleBannerViewDelegate> delegate;

/**
 Show activity UIActivityIndicatorView. Default `NO`.
 */
@property (assign, nonatomic) BOOL showActivityIndicatorViewWhenDownloadingImages;

/**
 *  set desired UIActivityIndicatorViewStyle
 *
 *  @param style The style of the UIActivityIndicatorView
 Default value `UIActivityIndicatorViewStyleWhiteLarge`.
 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorStyle;

@property (assign, nonatomic, getter = isContinuous) BOOL continuous;   // if YES, then bannerview will show like a carousel, default is NO
@property (assign, nonatomic) NSUInteger autoPlayTimeInterval;  // if autoPlayTimeInterval more than 0, the bannerView will autoplay with autoPlayTimeInterval value space, default is 0

- (void)reloadDataWithCompleteBlock:(CompleteBlock)competeBlock;
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

@end
