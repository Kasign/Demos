//
//  ViewController.m
//  iOS绘制
//
//  Created by mx-QS on 2019/7/22.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyDrawView.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView   *   imaegView;
@property (nonatomic, strong) UIColor       *   currentColor;
@property (nonatomic, assign) BOOL              isGetColor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    FlyDrawView * view = [[FlyDrawView alloc] initWithFrame:self.view.bounds];
    //    [view setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
    //    [self.view addSubview:view];
    
    //    FlyDrawLayer * layer = [FlyDrawLayer layer];
    //    [layer setFrame:self.view.bounds];
    //    [layer setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2].CGColor];
    //    [layer setNeedsDisplay];
    //    [self.view.layer addSublayer:layer];
    //
    //    UIView * tipView1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2, self.view.frame.size.height * 0.5 - 100, 1.f, 100)];;
    //    [tipView1 setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:1.f]];
    //    [self.view addSubview:tipView1];
    //
    //    UIView * tipView2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.8, self.view.frame.size.height * 0.5 - 100, 1.f, 100)];;
    //    [tipView2 setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:1.f]];
    //    [self.view addSubview:tipView2];
    
    
    [self test];
}

- (void)test {
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    [self recover];
    if (!_imaegView) {
        NSLog(@"找不到图片");
        return;
    }
    [self.view addSubview:_imaegView];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_imaegView.frame) + 50, 60, 40)];;
    [button setTitle:@"颜色" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(_imaegView.frame) + 50, 60, 40)];;
    [button1 setTitle:@"恢复" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(recover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_imaegView.frame) + 150, 100, 40)];;
    [button2 setTitle:@"左右翻转" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(turnWithHor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton * button4 = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_imaegView.frame) + 250, 100, 40)];;
    [button4 setTitle:@"上下翻转" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(turnWithVir) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton * button3 = [[UIButton alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(_imaegView.frame) + 150, 60, 40)];;
    [button3 setTitle:@"保存" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(saveCurrentImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

- (void)getColor {
    
    _isGetColor = YES;
}

- (void)recover {
    
    _isGetColor = YES;
    UIImage * image = [UIImage imageNamed:@"th.jpeg"];
    
    if (!image) {
        NSLog(@"找不到图片");
        return;
    }
    if (_imaegView == nil) {
        _imaegView = [[UIImageView alloc] initWithImage:image];
    } else {
        [_imaegView setImage:image];
    }
}

- (void)turnWithHor {
    
    [self changeImageWithDirection:1];
}

- (void)turnWithVir {
    
    [self changeImageWithDirection:2];
}

- (void)saveCurrentImage {
    
    [self saveInLocalWithImage:_imaegView.image];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint currentPoint = [[touches anyObject] locationInView:_imaegView];
    if (_isGetColor) {
        _currentColor = [self colorInImage:_imaegView.image atPixel:currentPoint currentSize:_imaegView.frame.size];
        _isGetColor = NO;
    } else {
        [self changeImageColorInPosition:currentPoint];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint currentPoint = [[touches anyObject] locationInView:_imaegView];
    if (!_isGetColor) {
        [self changeImageColorInPosition:currentPoint];
    }
}

#pragma mark - Method

- (void)changeImageColorInPosition:(CGPoint)position {
    
    UIImage * image = [self changeIamgeColor:_imaegView.image atPixel:position currentSize:_imaegView.frame.size color:_currentColor];
    if (image) {
        [_imaegView setImage:image];
    }
}

- (void)changeImageWithDirection:(int)direction {
    
    UIImage * image = _imaegView.image;
    image = [self changeIamgeDirection:image direction:direction];
    [_imaegView setImage:image];
}

- (void)saveInLocalWithImage:(UIImage *)image {
    
    NSData * data = UIImagePNGRepresentation(image);
    NSString * path = @"/Users/qiushan/Desktop/th1.png";
    [data writeToFile:path atomically:YES];
}

#pragma mark - Change Color
///Change Color
- (UIImage *)changeIamgeColor:(UIImage *)image atPixel:(CGPoint)position currentSize:(CGSize)currentSize color:(UIColor *)color {

    if (!CGSizeEqualToSize(image.size, currentSize)) {
        position.x = position.x * image.size.width / currentSize.width;
        position.y = position.y * image.size.height / currentSize.height;
    }
    UIImage * targetImage = image;
    if ([image isKindOfClass:[UIImage class]] && [color isKindOfClass:[UIColor class]] && currentSize.width >= position.x && position.x >= 0 && currentSize.height >= position.y && position.y >= 0) {
        CGImageRef oriImgRef  = image.CGImage;
        size_t imageWidth  = CGImageGetWidth(oriImgRef);
        size_t imageHeight = CGImageGetHeight(oriImgRef);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        size_t bitsPerComponent    = CGImageGetBitsPerComponent(oriImgRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(oriImgRef);
        size_t bytesPerRow  = CGImageGetBytesPerRow(oriImgRef);
        size_t componentsPerPixel = bitsPerPixel/bitsPerComponent;
        size_t pixelPerRow  = bytesPerRow/componentsPerPixel;
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;//CGImageGetBitmapInfo(oriImgRef)
        
        uint32_t * rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
        
        CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
        
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), oriImgRef);
        
        size_t pixelNum    = pixelPerRow * imageHeight;
        uint32_t * pCurPtr = rgbImageBuf;
        
        const CGFloat * colorComponents = nil;
        if ([color isKindOfClass:[UIColor class]]) {
            colorComponents = CGColorGetComponents(color.CGColor);
        }
        
        size_t offset = position.x + (int)position.y * pixelPerRow;
        uint8_t * ptr = (uint8_t *)(pCurPtr + offset);
        
        ptr = (uint8_t *)(pCurPtr + offset - 1);
        [self changeValueWithPointer:ptr targetPointer:colorComponents];
        ptr = (uint8_t *)(pCurPtr + offset - pixelPerRow);
        [self changeValueWithPointer:ptr targetPointer:colorComponents];
        ptr = (uint8_t *)(pCurPtr + offset);
        [self changeValueWithPointer:ptr targetPointer:colorComponents];
        ptr = (uint8_t *)(pCurPtr + offset + pixelPerRow);
        [self changeValueWithPointer:ptr targetPointer:colorComponents];
        ptr = (uint8_t *)(pCurPtr + offset + 1);
        [self changeValueWithPointer:ptr targetPointer:colorComponents];
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        if (imageRef != NULL) {
            targetImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
        }
        // 释放
        CGImageRelease(imageRef);
        
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
    }
    return targetImage;
}

- (void)changeValueWithPointer:(uint8_t *)oriPointer targetPointer:(const CGFloat *)colorComponents {
    
    float oriA = oriPointer[3];
    float a = colorComponents[3] * oriA/255.f;
    oriPointer[0]  = colorComponents[0] * 255.f * a; //red   0~255
    oriPointer[1]  = colorComponents[1] * 255.f * a; //green 0~255
    oriPointer[2]  = colorComponents[2] * 255.f * a; //blue  0~255
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
    data = nil;
    free(info);
    info = nil;
}

#pragma mark - Change Direction
- (UIImage *)changeIamgeDirection:(UIImage *)image direction:(int)direction{

    UIImage * targetImage = image;
    if ([image isKindOfClass:[UIImage class]]) {
        CGImageRef oriImgRef = image.CGImage;
        size_t imageWidth  = CGImageGetWidth(oriImgRef);
        size_t imageHeight = CGImageGetHeight(oriImgRef);
        
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(oriImgRef);
        size_t bitsPerComponent    = CGImageGetBitsPerComponent(oriImgRef);
        size_t bytesPerRow      = CGImageGetBytesPerRow(oriImgRef);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(oriImgRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(oriImgRef);
        size_t componentsPerPixel = bitsPerPixel/bitsPerComponent;
        size_t pixelPerRow  = bytesPerRow/componentsPerPixel;
        
        uint32_t * rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
        
        CGContextRef context   = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
        
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), oriImgRef);
        
        size_t pixelNum    = pixelPerRow * imageHeight;
        uint32_t * pCurPtr = rgbImageBuf;
        
        for (int i = 0; i < pixelNum; i ++) {
            
            int rowNum  = i /pixelPerRow;
            int lineNum = i % pixelPerRow;
            
            if (direction == 1) {//横向
                if (lineNum > pixelPerRow * 0.5) {
                    uint32_t * pCurPtrC = pCurPtr + i;
                    uint32_t pCurValue  = *pCurPtrC;
                    *pCurPtrC = *(uint32_t *)(pCurPtr + i - lineNum + pixelPerRow - lineNum);
                    pCurPtrC  = pCurPtr + i - lineNum + pixelPerRow - lineNum;
                    *pCurPtrC  = pCurValue;
                } else {
                    continue;
                }
            } else if (direction == 2) {//纵向
                if (rowNum < imageHeight * 0.5) {
                    
                    uint32_t * pCurPtrC = pCurPtr + i;
                    uint32_t pCurValue  = *pCurPtrC;
                    *pCurPtrC = *(uint32_t *)(pCurPtr + i + pixelPerRow * (imageHeight - 2 * rowNum));
                    pCurPtrC  = pCurPtr + i + pixelPerRow * (imageHeight - 2 * rowNum);
                    *pCurPtrC = pCurValue;
                } else {
                    break;
                }
            }
        }
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        if (imageRef != NULL) {
            targetImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
        }
        // 释放
        CGImageRelease(imageRef);
        
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
    }
    return targetImage;
}

#pragma mark - Get Color Inpixel
- (UIColor *)colorInImage:(UIImage *)image atPixel:(CGPoint)position currentSize:(CGSize)currentSize {
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, currentSize.width, currentSize.height), position) || image == nil) {
        return nil;
    }
    
    if (!CGSizeEqualToSize(image.size, currentSize)) {
        position.x = position.x * image.size.width / currentSize.width;
        position.y = position.y * image.size.height / currentSize.height;
    }
    
    CGImageRef oriImageRef = image.CGImage;
    CGRect sourceRect   = CGRectMake(position.x, position.y, 1.f, 1.f);
    CGImageRef imageRef = CGImageCreateWithImageInRect(oriImageRef, sourceRect);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(oriImageRef);
    unsigned char * buffer = malloc(4);
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;//RGBA
    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy); //设置颜色模式
    CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.f, 1.f), imageRef);
    CGImageRelease(imageRef);
    CGContextRelease(context);
    
    CGFloat r = buffer[0] / 255.f;
    CGFloat g = buffer[1] / 255.f;
    CGFloat b = buffer[2] / 255.f;
    CGFloat a = buffer[3] / 255.f;
    
    free(buffer);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
