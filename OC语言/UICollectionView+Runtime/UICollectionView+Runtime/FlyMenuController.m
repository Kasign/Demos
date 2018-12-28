//
//  FlyMenuController.m
//  UICollectionView+Runtime
//
//  Created by 66-admin-qs. on 2018/12/26.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyMenuController.h"

#define FlyMenuMainWindow [UIApplication sharedApplication].keyWindow
#define FlyScreenWidth    [UIScreen mainScreen].bounds.size.width
#define FlyScreenHeight   [UIScreen mainScreen].bounds.size.height

@implementation UIView (Frame)

- (CGFloat)fly_h
{
    return self.frame.size.height;
}

- (CGFloat)fly_w
{
    return self.frame.size.width;
}

- (CGFloat)fly_x
{
    return self.frame.origin.x;
}

- (CGFloat)fly_y
{
    return self.frame.origin.y;
}

- (void)setFly_h:(CGFloat)fly_h
{
    CGRect frame = self.frame;
    frame.size.height = fly_h;
    self.frame = frame;
}

- (void)setFly_w:(CGFloat)fly_w
{
    CGRect frame = self.frame;
    frame.size.width = fly_w;
    self.frame = frame;
}

- (void)setFly_x:(CGFloat)fly_x
{
    CGRect frame = self.frame;
    frame.origin.x = fly_x;
    self.frame = frame;
}

- (void)setFly_y:(CGFloat)fly_y
{
    CGRect frame = self.frame;
    frame.origin.y = fly_y;
    self.frame = frame;
}

@end

@interface FlyTriangleBackView : UIView

@property (nonatomic, assign) CGFloat       cornerRadius;
@property (nonatomic, assign) CGFloat       triangWidth;
@property (nonatomic, assign) CGFloat       triangHeight;
@property (nonatomic, assign) CGPoint       triangPosition; //（0~1.0）三角的尖部的位置，有防溢出处理
@property (nonatomic, strong) UIColor   *   fillColor;
@property (nonatomic, assign) FlyViewDirectionType directionType;

@end

@implementation FlyTriangleBackView

- (void)drawRect:(CGRect)rect
{
    UIColor * fillColor  = _fillColor ? _fillColor: [UIColor blackColor];
    CGFloat triangWidth  = _triangWidth;
    CGFloat triangHeight = _triangHeight;
    CGFloat cornerRadius = _cornerRadius;
    CGFloat height       = rect.size.height;
    CGFloat width        = rect.size.width;
    CGFloat startX = 0;
    CGFloat startY = triangHeight;
    
    CGFloat ratioX = MIN(MAX(0, _triangPosition.x), 1.f); //x比例
    CGFloat ratioY = 0; //由于只是横向的，所以y的值应该是固定的 - 以后再扩展
    CGFloat endX   = width;
    CGFloat endY   = height;
    CGFloat triangTopX = endX * ratioX; //按比例算出三角尖部的x
    CGFloat triangTopY = endY * ratioY; //由于只是横向的，所以y的值应该是固定的 - 以后再扩展
    
    triangTopX = MIN(MAX(triangTopX, 0), endX - triangWidth * 0.5);//防止溢出
    triangTopY = MIN(MAX(triangTopY, 0), endY);//防止溢出
    
    CGFloat triangX = triangTopX - triangWidth * 0.5;
    CGFloat triangY = triangTopY + triangHeight;
    
    if (_directionType == FlyViewDirectionTypeTop) {
        startY  = 0;
        endY    = height - triangHeight;
        triangY = endY;
    }
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    //左 从三角坐标x处开始
    [bezierPath moveToPoint:CGPointMake(triangX, startY)];
    if (triangX == 0) {
        
    } else {
        if (triangX > triangWidth) {
            [bezierPath addLineToPoint:CGPointMake(cornerRadius, startY)];
        }
        [bezierPath addArcWithCenter:CGPointMake(startX + cornerRadius, startY + cornerRadius)
                              radius:cornerRadius
                          startAngle:M_PI + M_PI_2
                            endAngle:M_PI
                           clockwise:0];
    }
    [bezierPath addLineToPoint:CGPointMake(startX, endY - cornerRadius)];//下
    
    [bezierPath addArcWithCenter:CGPointMake(startX + cornerRadius, endY - cornerRadius)
                          radius:cornerRadius
                      startAngle:M_PI
                        endAngle:M_PI_2
                       clockwise:0];
    //下
    if (_directionType == FlyViewDirectionTypeTop) {
        [bezierPath addLineToPoint:CGPointMake(triangX, endY)];
        [bezierPath addLineToPoint:CGPointMake(triangX + triangWidth * 0.5, endY + triangHeight)];
        [bezierPath addLineToPoint:CGPointMake(triangX + triangWidth, endY)];
        
        if (triangX != endX - triangWidth || triangWidth == 0 || triangHeight == 0) {
            [bezierPath addLineToPoint:CGPointMake(endX - cornerRadius, endY)];
            [bezierPath addArcWithCenter:CGPointMake(endX - cornerRadius, endY - cornerRadius)
                                  radius:cornerRadius
                              startAngle:M_PI_2
                                endAngle:0
                               clockwise:0];
        }
        //右上
        [bezierPath addLineToPoint:CGPointMake(endX, startY + cornerRadius)];
        [bezierPath addArcWithCenter:CGPointMake(endX - cornerRadius, cornerRadius)
                              radius:cornerRadius
                          startAngle:0
                            endAngle:M_PI + M_PI_2
                           clockwise:0];
        [bezierPath addLineToPoint:CGPointMake(triangX, startY)];
    } else {
        [bezierPath addLineToPoint:CGPointMake(endX - cornerRadius, endY)];
        [bezierPath addArcWithCenter:CGPointMake(endX - cornerRadius, endY - cornerRadius)
                              radius:cornerRadius
                          startAngle:M_PI_2
                            endAngle:0
                           clockwise:0];
        //右上
        [bezierPath addLineToPoint:CGPointMake(endX, startY + cornerRadius)];
        
        if (triangX == endX - triangWidth && triangWidth != 0) {
            [bezierPath addLineToPoint:CGPointMake(endX, startY)];
        } else {
            [bezierPath addArcWithCenter:CGPointMake(endX - cornerRadius, startY + cornerRadius)
                                  radius:cornerRadius
                              startAngle:0
                                endAngle:M_PI + M_PI_2
                               clockwise:0];
        }
        //上右
        [bezierPath addLineToPoint:CGPointMake(triangX + triangWidth, startY)];
        [bezierPath addLineToPoint:CGPointMake(triangX + triangWidth * 0.5, 0)];
        [bezierPath addLineToPoint:CGPointMake(triangX, startY)];
    }
    
    [bezierPath closePath];
    [fillColor setFill];
    [bezierPath fill];
}

- (void)setDirectionType:(FlyViewDirectionType)directionType
{
    if (_directionType != directionType) {
        _directionType = directionType;
        [self setNeedsDisplay];
    }
}

- (void)setTriangPosition:(CGPoint)triangPosition {
    
    if (!CGPointEqualToPoint(_triangPosition, triangPosition)) {
        _triangPosition = triangPosition;
        [self setNeedsDisplay];
    }
}

@end


@implementation FlyMenuItem

- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize
{
    FlyMenuItem * item = [[FlyMenuItem alloc] init];
    item.title         = title;
    item.fontSize      = fontSize;
    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fontSize = 14.f;
    }
    return self;
}

@end


@interface FlyMenuController ()

@property (nonatomic, strong) FlyTriangleBackView  *   contentView;
@property (nonatomic, strong) UIScrollView         *   scrollView;
@property (nonatomic, strong) UIView               *   relyView;

@end

@implementation FlyMenuController

+ (FlyMenuController *)sharedMenuController
{
    FlyMenuController * menuControlelr = [[FlyMenuController alloc] init];
    return menuControlelr;
}

- (CGRect)menuFrame
{
    return self.contentView.frame;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemWidth  = 60.f;
        _itemHeight = 40.f;
        _defaultDirection = FlyViewDirectionTypeTop;
        [self.contentView.layer setZPosition:10000];
    }
    return self;
}

- (void)update
{
    
}

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated
{
    if (menuVisible) {
        [self.contentView setHidden:NO];
        if (animated) {
            self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }
        [self.scrollView setContentOffset:CGPointZero];
    } else {
        if (animated) {
            [self.contentView setHidden:YES];
        } else {
            [self.contentView setHidden:YES];
        }
    }
}

- (FlyViewDirectionType)directionWithRelyView:(UIView *)relyView inView:(UIView *)inView
{
    UIView * relySuperView = relyView.superview ? relyView.superview : relyView;//relyView父view
    CGRect   relyFrame     = [relySuperView convertRect:relyView.frame toView:FlyMenuMainWindow];//relyView相对window坐标
    CGFloat  relyMaxY      = relyFrame.origin.y + relyFrame.size.height;//relyView相对于window最大y值
    CGFloat relyMinY       = relyFrame.origin.y;
    UIView * inSuperView   = inView.superview ? inView.superview : inView;
    CGRect   inFrame       = [inSuperView convertRect:inView.frame toView:FlyMenuMainWindow];//inView相对window坐标
    CGFloat  inMaxY        = inFrame.origin.y + inFrame.size.height;//inView相对window最大的位置
    CGFloat inMinY         = inFrame.origin.y;
    FlyViewDirectionType directionType = _defaultDirection;
    CGFloat distance = 6.f;//保留间距
    if (_defaultDirection == FlyViewDirectionTypeBottom) {
        if (relyMaxY <= inMaxY - CGRectGetHeight(self.contentView.frame) - distance) {
            directionType = FlyViewDirectionTypeBottom;
        } else if (relyMinY >= inMinY + CGRectGetHeight(self.contentView.frame) + distance) {
            directionType = FlyViewDirectionTypeTop;
        } else {
            directionType = FlyViewDirectionTypeMiddle;
        }
    } else if (_defaultDirection == FlyViewDirectionTypeTop) {
        if (relyMinY >= inMinY + CGRectGetHeight(self.contentView.frame) + distance) {
            directionType = FlyViewDirectionTypeTop;
        } else if (relyMaxY <= inMaxY - CGRectGetHeight(self.contentView.frame) - distance) {
            directionType = FlyViewDirectionTypeBottom;
        } else {
            directionType = FlyViewDirectionTypeMiddle;
        }
    }
    
    return directionType;
}

- (void)showRelyView:(UIView *)relyView inView:(UIView *)inView
{
    if ([relyView isKindOfClass:[UIView class]]) {
        _relyView = relyView;
        UIView * relySuperView = relyView.superview ? relyView.superview : relyView;
        CGRect  relyFrame      = [relySuperView convertRect:relyView.frame toView:inView];
        CGFloat relyMaxY       = relyFrame.origin.y + relyFrame.size.height;
        CGFloat relyMinY       = relyFrame.origin.y;
        CGFloat contentHeight  = CGRectGetHeight(self.contentView.frame);
        CGFloat contentY       = CGRectGetMinY(self.contentView.frame);
        contentY = relyMaxY;
        FlyViewDirectionType directionType = [self directionWithRelyView:relyView inView:inView];
        if (directionType == FlyViewDirectionTypeTop) { //显示在上面
            contentY = relyMinY - contentHeight;
        } else if (directionType == FlyViewDirectionTypeBottom) {//显示在下面
            contentY = relyMaxY;
        } else if (directionType == FlyViewDirectionTypeMiddle) {//显示在中间
            if ([inView isKindOfClass:[UIScrollView class]]) {
                UIScrollView * scrollView = (UIScrollView *)inView;
                CGFloat offsetY = scrollView.contentOffset.y;
                contentY = CGRectGetHeight(inView.frame) * 0.5 + offsetY - contentHeight;
            } else {
                contentY = relyMinY + relyFrame.size.height * 0.5;
            }
            directionType = _defaultDirection;
        }
        
        CGFloat triangPositionX = 1.f * (relyFrame.origin.x + relyFrame.size.width * 0.5) / CGRectGetWidth(inView.frame);
        [self.contentView setTriangPosition:CGPointMake(triangPositionX, 0)];
        
//        [self.contentView setFrame:CGRectMake((FlyScreenWidth - CGRectGetWidth(self.contentView.frame)) * 0.5, contentY, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        
        [self.contentView setFrame:CGRectMake(CGRectGetMinX(relyFrame) + CGRectGetWidth(relyFrame) * 0.5 - triangPositionX * CGRectGetWidth(self.contentView.frame), contentY, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
        
        [self.contentView setDirectionType:directionType];
        
        CGFloat scrollViewY = 0;
        if (directionType == FlyViewDirectionTypeBottom) {
            scrollViewY = self.contentView.triangHeight;
        }
        [self.scrollView setFly_y:scrollViewY];
        
        
        if (self.contentView.superview != inView) {
            if (self.contentView.superview) {
                [self.contentView removeFromSuperview];
            }
            [inView addSubview:self.contentView];
        }
    }
}

- (void)resetScrollView {
    
    for (UIView * subView in self.scrollView.subviews) {
        if (([subView isKindOfClass:[UIButton class]] && subView.tag >= 100) || ([subView isMemberOfClass:[UIView class]] && subView.tag == 200)) {
            [subView removeFromSuperview];
        }
    }
}

- (void)setMenuItems:(NSArray<FlyMenuItem *> *)menuItems {
    
    if (_menuItems != menuItems) {
        if (![menuItems isEqualToArray:_menuItems]) {
            [self resetScrollView];
            _menuItems = menuItems;
            if ([menuItems isKindOfClass:[NSArray class]]) {
                CGFloat contentWidth = MIN(menuItems.count * _itemWidth, FlyScreenWidth - 40.f);
                [self.contentView setFrame:CGRectMake(0, 0, contentWidth, _itemHeight + self.contentView.triangHeight)];
                [self.contentView setNeedsDisplay];
                [self.scrollView  setFrame:self.contentView.bounds];
                [self.scrollView  setContentSize:CGSizeMake(menuItems.count * (_itemWidth + 1) - 2.f, _itemHeight)];
                [self.contentView addSubview:self.scrollView];
                for (NSInteger i = 0; i < menuItems.count; i ++) {
                    @autoreleasepool {
                        FlyMenuItem * menuItem = [menuItems objectAtIndex:i];
                        if ([menuItem isKindOfClass:[FlyMenuItem class]]) {
                            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                            [button setFrame:CGRectMake(i * _itemWidth + 1, 0, _itemWidth, _itemHeight)];
                            [button setTitle:menuItem.title forState:UIControlStateNormal];
                            [button.titleLabel setFont:[UIFont systemFontOfSize:menuItem.fontSize]];
                            [button addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
                            [button setTag:i + 100];
                            
                            [self.scrollView addSubview:button];
                            if (i != 0) {
                                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(button.frame), 0, 1.f, _itemHeight)];
                                [lineView setBackgroundColor:[UIColor whiteColor]];
                                [lineView setTag:200];
                                [self.scrollView addSubview:lineView];
                            }
                        }
                    }
                }
            }
        }
    }
}

- (FlyTriangleBackView *)contentView {
    
    if (!_contentView) {
        _contentView = [[FlyTriangleBackView alloc] init];
        [_contentView setCornerRadius:8.0];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [_contentView setTriangWidth:7.5f];
        [_contentView setTriangHeight:5.f];
        [_contentView setDirectionType:FlyViewDirectionTypeBottom];
        [_contentView setFillColor:[UIColor blackColor]];
        [_contentView setHidden:YES];
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _scrollView;
}

- (void)itemClickAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag - 100;
    if (tag < _menuItems.count) {
        FlyMenuItem * item = [_menuItems objectAtIndex:tag];
        if (_flyMenuClickBlock) {
            _flyMenuClickBlock(item,self.relyView);
        }
    }
}

- (BOOL)isMenuVisible {
    
    return !self.contentView.isHidden;
}

- (void)dealloc {
    
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
}

@end
