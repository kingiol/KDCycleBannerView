KDCycleBannerView
=================

A Cycle Or Loop ScrollView For Banner

![ScreenShoot](https://github.com/kingiol/KDCycleBannerView/raw/master/ScreenShoot.gif)

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries.

### Podfile

``` ruby
platform :ios
pod "KDCycleBannerView"
```

## Usage

It is quite easy to use, you can use this by two methods, one is for code, another is for IB.

``` objc
_cycleBannerViewBottom = [KDCycleBannerView new];
_cycleBannerViewBottom.frame = CGRectMake(20, 270, 280, 150);
_cycleBannerViewBottom.datasource = self;
_cycleBannerViewBottom.delegate = self;
_cycleBannerViewBottom.continuous = YES;
_cycleBannerViewBottom.autoPlayTimeInterval = 5;
[self.view addSubview:_cycleBannerViewBottom];
```

For more infomation, please check the demo project, Good Luck!


## Inspiration

1.[KIImagePager](https://github.com/kimar/KIImagePager)

2.[SGFocusImageFrame](https://github.com/shanegao/SGFocusImageFrame)

## License

MIT LICENSE

Copyright (C)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.