//
//  ThirdViewController.m
//  无限循环CollectionView
//
//  Created by mx-QS on 2019/6/17.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ThirdViewController.h"
#import "iCarousel.h"

@interface ThirdViewController ()<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel     * mx_carousel;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.mx_carousel];
}

- (iCarousel *)mx_carousel {
    
    if (_mx_carousel == nil) {
        CGRect frame = CGRectMake(290, 100, 300, 200);
        _mx_carousel = [[iCarousel alloc] initWithFrame:frame];
        _mx_carousel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        _mx_carousel.type        = iCarouselTypeLinear;
        _mx_carousel.delegate    = self;
        _mx_carousel.dataSource  = self;
//        _mx_carousel.pagingEnabled = YES;
        _mx_carousel.scrollSpeed   = 1.2;
        _mx_carousel.decelerationRate = 0.7;
    }
    return _mx_carousel;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    
    NSLog(@"index:%ld",carousel.currentItemIndex);
    return 100;
}

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel {
    
    return 30;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
    [view setBackgroundColor:[UIColor redColor]];
    
    return view;
}

//- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
//
//    CGFloat tilt = 0.45;
//    CGFloat spacing = 0.25;
//    CGFloat clampedOffset = MAX(-1.0, MIN(1.0, offset));
//    CGFloat itemWidth = carousel.itemWidth;
//
//    CGFloat x = (clampedOffset * 0.5 * tilt + offset * spacing) * itemWidth * 0.8;
//    x = clampedOffset * 0.23 * itemWidth;
//    CGFloat z = fabs(clampedOffset) * -itemWidth * 0.5;
//    CGFloat angle = -clampedOffset * M_PI_2 * tilt;
//    transform = CATransform3DTranslate(transform, x, 0, z);
//    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
//    return transform;
//
//    //transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
//    //return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.mx_carousel.itemWidth);
//}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {

    switch (option)
    {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionSpacing:
        {
            CGFloat sp = 0.24;
            return sp;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.mx_carousel.type == iCarouselTypeCustom) {
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
            return value * 0.f;
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return 3;
            return value;
        }
    }
}

@end
