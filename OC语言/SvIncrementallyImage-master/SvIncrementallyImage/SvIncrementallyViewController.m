//
//  SvIncrementallyViewController.m
//  SvIncrementallyImage
//
//  Created by  maple on 6/27/13.
//  Copyright (c) 2013 maple. All rights reserved.
//

#import "SvIncrementallyViewController.h"
#import "SvIncrementallyImage.h"

@interface SvIncrementallyViewController () {
    UIImageView *_imageThumb;
    UIImageView *_imageV;
    SvIncrementallyImage *_webImage;
}

@end

@implementation SvIncrementallyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    _imageV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageV];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    _webImage = [[SvIncrementallyImage alloc] initWithURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateImage
{
    _imageV.image = _webImage.image;
}

@end
