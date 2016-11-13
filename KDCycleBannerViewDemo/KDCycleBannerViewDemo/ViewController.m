//
//  ViewController.m
//  KDCycleBannerViewDemo
//
//  Created by Kingiol on 14-4-11.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import "ViewController.h"

#import "KDCycleBannerView.h"

@interface ViewController () <KDCycleBannerViewDataSource, KDCycleBannerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet KDCycleBannerView *cycleBannerViewTop;
@property (strong, nonatomic) KDCycleBannerView *cycleBannerViewBottom;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _cycleBannerViewTop.autoPlayTimeInterval = 5;
    
    _cycleBannerViewBottom = [KDCycleBannerView new];
    _cycleBannerViewBottom.frame = CGRectMake(20, 270, 280, 150);
    _cycleBannerViewBottom.datasource = self;
    _cycleBannerViewBottom.delegate = self;
    _cycleBannerViewBottom.continuous = YES;
    _cycleBannerViewBottom.autoPlayTimeInterval = 5;
    [self.view addSubview:_cycleBannerViewBottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KDCycleBannerViewDataSource

- (NSArray *)dataForCycleBannerView:(KDCycleBannerView *)bannerView {
    
    return @[[UIImage imageNamed:@"image1"],
             @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=ed59838948ed2e73fce9812cb339a08b/58ee3d6d55fbb2fb9835341f4d4a20a44623dca5.jpg",
             @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=5ad7fab780025aafd33279cbcfd5aa64/8601a18b87d6277f15eb8e4f2a381f30e824fcc8.jpg",
             @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=df5d0b61cdfc1e17fdbf8b317ea8f703/0bd162d9f2d3572c8d2b20ab8813632763d0c3f8.jpg",
             @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=a11d7b94552c11dfded1b823571f63d0/eaf81a4c510fd9f914eee91e272dd42a2934a4c8.jpg"];
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleAspectFill;
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"image1"];
}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index {
    NSLog(@"didScrollToIndex:%ld", (long)index);
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"didSelectedAtIndex:%ld", (long)index);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *text = textField.text;
    
    @try {
        NSInteger page = [text integerValue];
        [_cycleBannerViewTop setCurrentPage:page animated:YES];
        [_cycleBannerViewBottom setCurrentPage:page animated:YES];
    }
    @catch (NSException *exception) {
        
    }
    
    return YES;
}

@end
