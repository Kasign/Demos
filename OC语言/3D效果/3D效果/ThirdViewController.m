//
//  ThirdViewController.m
//  3D效果
//
//  Created by Q on 2018/5/9.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ThirdViewController.h"
#import "iCarousel.h"

#define OrgTransformSide    40.f
#define OrgTransFormCount   5

#define OrgScreenWidth  [UIScreen mainScreen].bounds.size.width
#define OrgScreenHeight [UIScreen mainScreen].bounds.size.height

//#define OrgLog(...) NSLog(__VA_ARGS__)
#define OrgLog(...)

@interface ThirdViewController ()<iCarouselDataSource, iCarouselDelegate>{
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) dispatch_source_t  timer;

@end

@implementation ThirdViewController

- (void)dealloc
{
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wrap = YES;
    self.items = [NSMutableArray array];
    for (int i = 0; i < OrgTransFormCount; i++)
    {
        [self.items addObject:@(i)];
    }

    //configure carousel
    
    _width  = MIN(OrgScreenWidth, OrgScreenHeight) - 40.f;
    _height = _width * 139 / 300.f;
    
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(20, 200, _width, _height)];
    _carousel.backgroundColor = [UIColor clearColor];
    _carousel.type = iCarouselTypeCoverFlow2;//iCarouselTypeCustom iCarouselTypeRotary
    _carousel.delegate = self;
    _carousel.dataSource = self;
//    [self autoScroll];
    _carousel.pagingEnabled = YES;
    _carousel.bounceDistance = 0.35;
    [self.view addSubview:_carousel];
}

- (void)autoScroll {
    
    if (!_carousel) {
        return;
    }
    int time = 4;
 
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, time * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.carousel scrollByNumberOfItems:1 duration:2.2f];
            });
        });
        dispatch_resume(_timer);
//    });
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    [self.carousel setCenter:CGPointMake(OrgScreenWidth/2.0, OrgScreenHeight/2.0)];
}

#pragma mark -
#pragma mark iCarousel methods

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    
    return _width - OrgTransformSide;
}

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
        view.frame = CGRectMake(0, 0, _width - OrgTransformSide, _height);
        ((UIImageView *)view).image = [UIImage imageNamed:@"1.jpg"];
        view.layer.cornerRadius  = 8.f;
        view.layer.masksToBounds = YES;
        view.contentMode = UIViewContentModeScaleAspectFill;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag  = 1;
        [view addSubview:label];
        if (index % 3 == 0) {
            view.backgroundColor = [UIColor magentaColor];
        } else if (index % 3 == 1) {
            view.backgroundColor = [UIColor blueColor];
        } else if (index % 3 == 2) {
            view.backgroundColor = [UIColor redColor];
        }
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
//    label.text = [self.items[(NSUInteger)index] stringValue];
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"1.jpg"];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50.0];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    if (ABS(offset) < 0.1) {
        offset = 0;
    }
    transform = CATransform3DRotate(transform, M_PI / 10.0, 0.0, - offset, 0.0);
    return transform;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            OrgLog(@" iCarouselOptionWrap %f",value);
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            OrgLog(@" iCarouselOptionSpacing %f",value);
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                OrgLog(@" iCarouselOptionFadeMax %f",value);
                return carousel.itemWidth * 0.5f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        {
            OrgLog(@" iCarouselOptionShowBackfaces %f",value);
            return YES;
        }
        case iCarouselOptionVisibleItems:
        {
            OrgLog(@" iCarouselOptionVisibleItems %f",value);
            return 3;
        }
        case iCarouselOptionAngle:
        {
            OrgLog(@"iCarouselOptionAngle %f",value);
            return value ;
        }
        case iCarouselOptionCount:
        {
            OrgLog(@" iCarouselOptionCount %f",value);
            return value;
        }
        case iCarouselOptionRadius:
        {
            OrgLog(@"iCarouselOptionRadius %f",value);
            return value;
        }
        case iCarouselOptionArc:
        {
            OrgLog(@" iCarouselOptionArc %f",value);
            return value;
        }
        case iCarouselOptionTilt:
        {
            OrgLog(@" iCarouselOptionTilt %f",value);
            value = 0.9;
            return value;
        }
        case iCarouselOptionFadeMin:
        {
            OrgLog(@" iCarouselOptionFadeMin %f",value);
            return value;
        }
        case iCarouselOptionFadeMinAlpha:
        {
            OrgLog(@" iCarouselOptionFadeMinAlpha %f",value);
            return value;
        }
        case iCarouselOptionFadeRange:
        {
            OrgLog(@" iCarouselOptionFadeRange %f",value);
            return value;
        }
        case iCarouselOptionOffsetMultiplier:
        {
            OrgLog(@" iCarouselOptionOffsetMultiplier %f",value);
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.items)[(NSUInteger)index];
    OrgLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    OrgLog(@"Index: %@", @(self.carousel.currentItemIndex));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
