//
//  ThirdViewController.m
//  3D效果
//
//  Created by Q on 2018/5/9.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ThirdViewController.h"
#import "OrgLoopView.h"
#import <math.h>

#define OrgTransformSide    20.f
#define OrgTransFormCount   25


#define OrgScreenWidth  [UIScreen mainScreen].bounds.size.width
#define OrgScreenHeight [UIScreen mainScreen].bounds.size.height

//#define OrgLog(...) NSLog(__VA_ARGS__)
#define OrgLog(...)

@interface ThirdViewController ()<OrgLoopViewDataSource, OrgLoopViewDelegate>{
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) OrgLoopView *carousel;
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
    
    _width  = 414.f;
    _height = _width * 139 / 300.f;
    
    _carousel = [[OrgLoopView alloc] initWithFrame:CGRectMake(OrgTransformSide, 200, 414.f, _height)];
    _carousel.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.4];
    _carousel.type = OrgLoopViewTypeCoverFlow;//OrgLoopViewTypeCustom OrgLoopViewTypeRotary
    _carousel.delegate = self;
    _carousel.dataSource = self;
//    [self autoScroll];
    _carousel.pagingEnabled = YES;
    _carousel.bounceDistance = 0.35;
    [_carousel setClipsToBounds:YES];
    [self.view addSubview:_carousel];
    
    
    CGFloat screenWidth = OrgScreenWidth;
    CGFloat distance    = 0;
    CGFloat perspective = -0.002;
    
    CGFloat itemWidth = screenWidth - 2 * distance;//item 宽
    CGFloat itemHight = itemWidth * 139 / 300.f;//item 高
    CGFloat scale = 1/(-itemWidth * 0.5 * perspective + 1);//缩放比例
    CGFloat disY = (1 - scale) * itemHight * 0.5;//y方向上边界距离
    CGFloat disX = itemWidth * (1 - scale) * 0.5;//平移前x方向上边界距离
    CGFloat resultDis = (disX + disY)/scale;//让x方向与y方向平移后显示的移出距离
    
    distance = ((itemWidth * (1 - (1/(-itemWidth * 0.5 * perspective + 1))) * 0.5) + ((1 - (1/(-itemWidth * 0.5 * perspective + 1))) * (itemWidth * 139 / 300.f) * 0.5))/(1/(-itemWidth * 0.5 * perspective + 1));
    
    
    CGFloat spacing = resultDis/itemWidth;//确定spacing的值
    
    NSLog(@"%f   %f",resultDis,spacing);
    
}

- (void)autoScroll {
    
    if (!_carousel) {
        return;
    }
    int time = 4;
 
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        weakSelf.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(weakSelf.timer, DISPATCH_TIME_NOW, time * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(weakSelf.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.carousel scrollByNumberOfItems:1 duration:2.2f];
            });
        });
        dispatch_resume(weakSelf.timer);
    });
    
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    [self.carousel setCenter:CGPointMake(OrgScreenWidth/2.0, OrgScreenHeight/2.0)];
}

#pragma mark -
#pragma mark OrgLoopView methods

- (CGFloat)carouselItemWidth:(OrgLoopView *)carousel {
    
    return _width - OrgTransformSide * 2;
}

- (NSInteger)numberOfItemsInCarousel:(__unused OrgLoopView *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused OrgLoopView *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
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
        
        [label setText:[NSString stringWithFormat:@"%@",[_items objectAtIndex:index]]];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused OrgLoopView *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused OrgLoopView *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
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
    
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused OrgLoopView *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat tilt = 35/360.f;
    CGFloat spacing = 0.25;
    CGFloat clampedOffset = MAX(-1.0, MIN(1.0, offset)); //offset [-1.0 , 1.0]
//    CGFloat toggle    = carousel.toggle;
    CGFloat itemWidth = carousel.itemWidth;
    
    CGFloat x = (clampedOffset * 0.5 * tilt + offset * spacing) * itemWidth * 0.8;
    x = clampedOffset * 0.23 * itemWidth;
    CGFloat z = fabs(clampedOffset) * -itemWidth * 0.5;
    CGFloat angle = -clampedOffset * M_PI_2 * tilt;
    if (fabs(offset) == 1) {
        NSLog(@" **** offset:%f    x: %f   angle: %f ****",offset,x,angle);
    }
    
    transform = CATransform3DTranslate(transform, x, 0, z);
    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);;
    return transform;
}

- (CGFloat)carousel:(__unused OrgLoopView *)carousel valueForOption:(OrgLoopViewOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case OrgLoopViewOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            OrgLog(@" OrgLoopViewOptionWrap %f",value);
            return self.wrap;
        }
        case OrgLoopViewOptionSpacing:
        {
            //add a bit of spacing between the item views
            OrgLog(@" OrgLoopViewOptionSpacing %f",value);
            CGFloat itemWidth = carousel.itemWidth;//item 宽
            CGFloat itemHight = carousel.bounds.size.height;//item 高
            CGFloat scale = 1/(-itemWidth * 0.5 * carousel.perspective + 1);//缩放比例
            CGFloat disY = (1 - scale) * itemHight * 0.5;//y方向上边界距离
            CGFloat disX = itemWidth * (1 - scale) * 0.5;//平移前x方向上边界距离
            CGFloat resultDis = (disX + disY)/scale;//让x方向与y方向平移后显示的移出距离
            CGFloat spacing = resultDis/itemWidth;//确定spacing的值
            
            return spacing;
            return value;
        }
        case OrgLoopViewOptionFadeMax:
        {
            if (self.carousel.type == OrgLoopViewTypeCustom)
            {
                //set opacity based on distance from camera
                OrgLog(@" OrgLoopViewOptionFadeMax %f",value);
                return carousel.itemWidth * 0.5f;
            }
            return value;
        }
        case OrgLoopViewOptionShowBackfaces:
        {
            OrgLog(@" OrgLoopViewOptionShowBackfaces %f",value);
            return YES;
        }
        case OrgLoopViewOptionVisibleItems:
        {
            OrgLog(@" OrgLoopViewOptionVisibleItems %f",value);
            return value;
        }
        case OrgLoopViewOptionAngle:
        {
            OrgLog(@"OrgLoopViewOptionAngle %f",value);
            return value ;
        }
        case OrgLoopViewOptionCount:
        {
            OrgLog(@" OrgLoopViewOptionCount %f",value);
            return value;
        }
        case OrgLoopViewOptionRadius:
        {
            OrgLog(@"OrgLoopViewOptionRadius %f",value);
            return value;
        }
        case OrgLoopViewOptionArc:
        {
            OrgLog(@" OrgLoopViewOptionArc %f",value);
            return value;
        }
        case OrgLoopViewOptionTilt:
        {
            OrgLog(@" OrgLoopViewOptionTilt %f",value);
            return 0;
            return value;
        }
        case OrgLoopViewOptionFadeMin:
        {
            OrgLog(@" OrgLoopViewOptionFadeMin %f",value);
            return value;
        }
        case OrgLoopViewOptionFadeMinAlpha:
        {
            OrgLog(@" OrgLoopViewOptionFadeMinAlpha %f",value);
            return value;
        }
        case OrgLoopViewOptionFadeRange:
        {
            OrgLog(@" OrgLoopViewOptionFadeRange %f",value);
            return value;
        }
        case OrgLoopViewOptionOffsetMultiplier:
        {
            OrgLog(@" OrgLoopViewOptionOffsetMultiplier %f",value);
            return value;
        }
    }
}

#pragma mark -
#pragma mark OrgLoopView taps

- (void)carousel:(__unused OrgLoopView *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.items)[(NSUInteger)index];
    OrgLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused OrgLoopView *)carousel
{
    OrgLog(@"Index: %@", @(self.carousel.currentItemIndex));
}

- (void)carouselWillBeginDragging:(OrgLoopView *)carousel {
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)carouselDidEndDragging:(OrgLoopView *)carousel willDecelerate:(BOOL)decelerate {
    
    if (_timer) {
        dispatch_resume(_timer);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
