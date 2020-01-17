//
//  FLYImageChangeView.m
//  图像修改器
//
//  Created by Qiushan on 2020/1/16.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYImageChangeView.h"
#import "FLYImageChangeManager.h"

typedef void(^ProgressBlock)(CGFloat progress);

@interface FLYImageChangeView ()

@property (nonatomic, strong) UIView        *   contentView;
@property (nonatomic, strong) UIImageView   *   imageView;
@property (nonatomic, strong) UIView        *   toolView;
@property (nonatomic, strong) UIView        *   sliderView;
@property (nonatomic, strong) UIView        *   stateView;
@property (nonatomic, strong) FLYImageChangeManager   *   imageManager;
@property (nonatomic, strong) NSMutableDictionary     *   blockDic;
@end

@implementation FLYImageChangeView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _blockDic = [NSMutableDictionary dictionary];
        _imageManager = [[FLYImageChangeManager alloc] init];
        [self startInitViews];
    }
    return self;
}

- (void)startInitViews {
    
    [self addSubview:self.contentView];
    [self recoverAction];
    if (self.imageView.image == nil) {
        NSLog(@"找不到图片");
        return;
    }
    [self.contentView addSubview:self.sliderView];
    [self.contentView addSubview:self.toolView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.stateView];
    
    [self.sliderView setFrame:CGRectMake(10.f, 25.f, CGRectGetWidth(self.sliderView.frame), CGRectGetHeight(self.sliderView.frame))];
    [self.toolView setFrame:CGRectMake(CGRectGetMaxX(self.sliderView.frame) + 15.f, 25.f, CGRectGetWidth(self.toolView.frame), CGRectGetHeight(self.toolView.frame))];
    [self.imageView setFrame:CGRectMake(CGRectGetMaxX(self.toolView.frame) + 15.f, 25.f, CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame))];
    [self.stateView setFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.stateView.frame), 25.f, CGRectGetWidth(self.stateView.frame), CGRectGetHeight(self.stateView.frame))];
}

- (UIView *)contentView {
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    }
    return _contentView;
}

- (UIView *)toolView {
    
    if (_toolView == nil) {
        _toolView = [[UIView alloc] init];
        [_toolView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
        [self initTools];
    }
    return _toolView;
}

- (UIView *)sliderView {
    
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
        [_sliderView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
        [self initSliberViews];
    }
    return _sliderView;
}

- (UIView *)stateView {
    
    if (_stateView == nil) {
        _stateView = [[UIView alloc] init];
        [_stateView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
        [self initStateViews];
    }
    return _stateView;
}

- (UIImageView *)imageView {
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 150, 150)];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        
        [_imageView addGestureRecognizer:tap];
        [_imageView addGestureRecognizer:pan];
        
        [_imageView setUserInteractionEnabled:YES];
    }
    return _imageView;
}

- (void)initTools {
    
    CGFloat startY   = 0;
    CGFloat disSide  = 20;
    CGFloat disY     = 30;
    CGFloat buttonW  = 140;
    CGFloat buttonH  = 40;
    CGFloat fontSize = 30.f;
    
    UIColor  * textColor = [UIColor purpleColor];
    UIButton * bigB = [self buttonWithFrame:CGRectMake(disSide, startY + CGRectGetMaxY(CGRectZero) + disY, buttonW, buttonH) title:@"放大图片" fontSize:fontSize titleColor:textColor sel:@selector(enlargeImageViewAction)];
    [self.toolView addSubview:bigB];
    
    UIButton * smallB = [self buttonWithFrame:CGRectMake(disSide, CGRectGetMaxY(bigB.frame) + disY, buttonW, buttonH) title:@"缩小图片" fontSize:fontSize titleColor:textColor sel:@selector(smallImageViewAction)];
    [self.toolView addSubview:smallB];
    
    UIButton * colorbB = [self buttonWithFrame:CGRectMake(disSide, CGRectGetMaxY(smallB.frame) + disY, buttonW, buttonH) title:@"拾取颜色" fontSize:fontSize titleColor:textColor sel:@selector(getColorAction)];
    [self.toolView addSubview:colorbB];
    
    UIButton * blurryB = [self buttonWithFrame:CGRectMake(disSide, CGRectGetMaxY(colorbB.frame) + disY, buttonW, buttonH) title:@"模糊处理" fontSize:fontSize titleColor:textColor sel:@selector(blurryAction)];
    [self.toolView addSubview:blurryB];
    
    UIButton * coverLeftB = [self buttonWithFrame:CGRectMake(disSide, CGRectGetMaxY(blurryB.frame) + disY, buttonW, buttonH) title:@"左右翻转" fontSize:fontSize titleColor:textColor sel:@selector(turnAtHorizontalAction)];
    [self.toolView addSubview:coverLeftB];
    
    UIButton * coverUpB = [self buttonWithFrame:CGRectMake(disSide, CGRectGetMaxY(coverLeftB.frame) + disY, buttonW, buttonH) title:@"上下翻转" fontSize:fontSize titleColor:textColor sel:@selector(turnAtVerticalAction)];
    [self.toolView addSubview:coverUpB];
    
    UIButton * recoverB = [self buttonWithFrame:CGRectMake(disSide, CGRectGetMaxY(coverUpB.frame) + disY, buttonW, buttonH) title:@"恢复" fontSize:fontSize titleColor:textColor sel:@selector(recoverAction)];
    [self.toolView addSubview:recoverB];
    
    UIButton * saveB = [self buttonWithFrame:CGRectMake(disSide, CGRectGetMaxY(recoverB.frame) + disY, buttonW, buttonH) title:@"保存" fontSize:fontSize titleColor:textColor sel:@selector(saveCurrentImageAction)];
    [self.toolView addSubview:saveB];
    
    [self.toolView setFrame:CGRectMake(0, 0, CGRectGetMaxX(saveB.frame) + disSide, CGRectGetMaxY(saveB.frame) + disY)];
}

- (void)initSliberViews {
    
    CGFloat width = 140;
    
    UILabel * radiuL = [self labelWithFrame:CGRectMake(0, 25, width, 20) fontSize:18 titleColor:[UIColor yellowColor]];
    [radiuL setText:[NSString stringWithFormat:@"半径:%d", (int)_imageManager.radius + 1]];
    __weak typeof(self) weakSelf = self;
    UISlider * radiuS = [self sliderWithFrame:CGRectMake(width * 0.5 - 10.f, CGRectGetMaxY(radiuL.frame) + 5, 20, 200) minValue:0.1 block:^(CGFloat progress) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        progress = (int)(10 * progress) - 1;
        [strongSelf.imageManager setRadius:progress];
        [radiuL setText:[NSString stringWithFormat:@"半径:%d", (int)progress + 1]];
    }];
    [radiuS setValue:(_imageManager.radius + 1) * 0.1 animated:YES];
    
    [self.sliderView addSubview:radiuS];
    [self.sliderView addSubview:radiuL];
    
    UILabel * alphaL = [self labelWithFrame:CGRectMake(0, CGRectGetMaxY(radiuS.frame) + 30, width, 20) fontSize:18 titleColor:[UIColor yellowColor]];
    [alphaL setText:[NSString stringWithFormat:@"模糊:%.2f", _imageManager.currentAlpha]];
    UISlider * alphaS = [self sliderWithFrame:CGRectMake(width * 0.5 - 10.f, CGRectGetMaxY(alphaL.frame) + 5, 20, 200) minValue:0 block:^(CGFloat progress) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.imageManager setCurrentAlpha:progress];
        [alphaL setText:[NSString stringWithFormat:@"模糊:%.2f", progress]];
    }];
    [alphaS setValue:_imageManager.currentAlpha animated:YES];
    
    [self.sliderView addSubview:radiuL];
    [self.sliderView addSubview:radiuS];
    [self.sliderView addSubview:alphaL];
    [self.sliderView addSubview:alphaS];
    
    [self.sliderView setFrame:CGRectMake(0, 0, width, CGRectGetMaxY(alphaS.frame) + 30)];
}

- (void)initStateViews {
    
    CGFloat width = 140;
    
    CGFloat colorViewWidth = 80;
    
    UIView * colorView = [[UIView alloc] initWithFrame:CGRectMake((width - colorViewWidth) * 0.5, 10, colorViewWidth, colorViewWidth)];
    [colorView.layer setMasksToBounds:YES];
    [colorView.layer setCornerRadius:colorViewWidth * 0.5];
    
    UILabel * rL = [self labelWithFrame:CGRectMake(0, CGRectGetMaxY(colorView.frame) + 20.f, width, 20) fontSize:18 titleColor:[UIColor yellowColor]];
    UILabel * gL = [self labelWithFrame:CGRectMake(0, CGRectGetMaxY(rL.frame) + 10.f, width, 20) fontSize:18 titleColor:[UIColor yellowColor]];
    UILabel * bL = [self labelWithFrame:CGRectMake(0, CGRectGetMaxY(gL.frame) + 10.f, width, 20) fontSize:18 titleColor:[UIColor yellowColor]];
    UILabel * aL = [self labelWithFrame:CGRectMake(0, CGRectGetMaxY(bL.frame) + 10.f, width, 20) fontSize:18 titleColor:[UIColor yellowColor]];
    
    [colorView setTag:200];
    [rL setTag:210];
    [gL setTag:220];
    [bL setTag:230];
    [aL setTag:240];
    
    [self.stateView addSubview:colorView];
    [self.stateView addSubview:rL];
    [self.stateView addSubview:gL];
    [self.stateView addSubview:bL];
    [self.stateView addSubview:aL];
    
    [self.stateView setFrame:CGRectMake(0, 0, width, CGRectGetMaxY(aL.frame) + 30)];
}

- (void)updateStateViews {
    
    UIColor * color    = _imageManager.currentColor;
    if ([color isKindOfClass:[UIColor class]]) {
        UIView * colorView = [self.stateView viewWithTag:200];
        [colorView setBackgroundColor:color];
        
        UILabel * rL = [self.stateView viewWithTag:210];
        UILabel * gL = [self.stateView viewWithTag:220];
        UILabel * bL = [self.stateView viewWithTag:230];
        UILabel * aL = [self.stateView viewWithTag:240];
        
        const CGFloat * colorComponents = CGColorGetComponents(color.CGColor);
        
        [rL setText:[NSString stringWithFormat:@"R:%d", (int)(colorComponents[0] * 255)]];
        [gL setText:[NSString stringWithFormat:@"G:%d", (int)(colorComponents[1] * 255)]];
        [bL setText:[NSString stringWithFormat:@"B:%d", (int)(colorComponents[2] * 255)]];
        [aL setText:[NSString stringWithFormat:@"A:%d", (int)(colorComponents[3] * 255)]];
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor sel:(SEL)sel {
    
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)labelWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor {
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    [label setTextColor:titleColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (UISlider *)sliderWithFrame:(CGRect)frame minValue:(CGFloat)minValue block:(ProgressBlock)block {
    
    UISlider * slider = [[UISlider alloc] init];
    [slider setMaximumValue:1.f];
    [slider setMinimumValue:minValue];
    [slider setMinimumTrackTintColor:[UIColor blueColor]];
    [slider setMaximumTrackTintColor:[UIColor blackColor]];
    [slider setThumbTintColor:[UIColor purpleColor]];
    [slider setTransform:CGAffineTransformMakeRotation(M_PI * 0.5)];
    slider.frame = frame;
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    if (block) {
        [_blockDic setValue:block forKey:[NSString stringWithFormat:@"%p", slider]];
    }
    
    return slider;
}

#pragma mark - button Actions

- (void)getColorAction {
    
    [_imageManager setChangType:FLYImageChangeType_GetColor];
}

- (void)recoverAction {
    
    [_imageManager setChangType:FLYImageChangeType_GetColor];
    UIImage * image = [UIImage imageNamed:@"th.jpeg"];
    if (image) {
        [_imageManager setOriImage:image];
        [self.imageView setImage:image];
        [_imageView setFrame:CGRectMake(CGRectGetMaxX(self.toolView.frame) + 10.f, 10.f, image.size.width * 2, image.size.height * 2)];
    }
}

- (void)turnAtHorizontalAction {
    
    [self changeImageWithDirection:FLYImageChangeType_ChangeHorizontal];
}

- (void)turnAtVerticalAction {
    
    [self changeImageWithDirection:FLYImageChangeType_ChangeVertical];
}

- (void)saveCurrentImageAction {
    
    [self saveInLocalWithImage:_imageView.image];
}

- (void)enlargeImageViewAction {
    
    if (_imageView.image) {
        CGFloat currentScale = _imageView.frame.size.width / _imageView.image.size.width;
        
        if (currentScale >= 1) {
            currentScale ++;
        } else {
            currentScale = currentScale * 2;
            if (currentScale > 1) {
                currentScale = 1;
            }
        }
        [self changeImageViewWithScale:currentScale];
    }
}

- (void)smallImageViewAction {
    
    if (_imageView.image) {
        CGFloat currentScale = _imageView.frame.size.width / _imageView.image.size.width;
        if (currentScale > 1) {
            currentScale --;
        } else {
            currentScale = currentScale * 0.5;
        }
        [self changeImageViewWithScale:currentScale];
    }
}

- (void)blurryAction {
    
    [_imageManager setChangType:FLYImageChangeType_ChangeAlpha];
}

- (void)sliderAction:(UISlider *)slider {
    
    CGFloat value  = slider.value;
    NSString * key = [NSString stringWithFormat:@"%p", slider];
    ProgressBlock block = [_blockDic objectForKey:key];
    if (block) {
        block(value);
    }
}

- (void)changeImageViewWithScale:(CGFloat)scale {
    
    if (_imageView.image) {
        CGRect oriFrame  = _imageView.frame;
        CGSize imageSize = _imageView.image.size;
        [_imageView setFrame:CGRectMake(oriFrame.origin.x, oriFrame.origin.y, imageSize.width * scale, imageSize.height * scale)];
    }
}

#pragma mark - touch
- (void)imageViewTapAction:(UIGestureRecognizer *)gesture {
    
    BOOL isChangeColor = _imageManager.changType == FLYImageChangeType_GetColor;
    CGPoint currentPoint = [gesture locationInView:_imageView];
    [_imageManager pixelWithPosition:currentPoint currentSize:_imageView.frame.size];
    [self getCurrentImage];
    if (isChangeColor) {
        [self updateStateViews];
    }
}

#pragma mark - Method

- (void)changeImageColorInPosition:(CGPoint)position {
    
    [_imageManager pixelWithPosition:position currentSize:_imageView.frame.size];
    [self getCurrentImage];
}

- (void)changeImageWithDirection:(FLYImageChangeType)direction {
    
    [_imageManager setChangType:direction];
    [self getCurrentImage];
}

- (void)getCurrentImage {
    
    UIImage * image = [_imageManager currentImage];
    [_imageView setImage:image];
}

- (void)saveInLocalWithImage:(UIImage *)image {
    
    NSData * data = UIImagePNGRepresentation(image);
    NSString * path = @"/Users/qiushan/Downloads/th1.png";
    [data writeToFile:path atomically:YES];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.contentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.stateView setFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.stateView.frame) - 10.f, 25.f, CGRectGetWidth(self.stateView.frame), CGRectGetHeight(self.stateView.frame))];
}


@end
