//
//  SalScreenShotTool.m
//  MXSALEnigine
//
//  Created by mx-QS on 2019/10/29.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "SalScreenShotTool.h"

//@interface SalScreenShotTool ()
//
//@property (nonatomic, strong) NSMutableArray   *   imageModelArr;
//@property (nonatomic, assign) CGFloat              startTime;
//
//@end
//
//@implementation SalScreenShotModel
//
//+ (instancetype)instanceWithImage:(UIImage *)image time:(CGFloat)time {
//
//    SalScreenShotModel * model = [SalScreenShotModel new];
//    model.image = image;
//    model.time  = time;
//    return model;
//}
//
//@end
//
//@implementation SalScreenShotTool
//
//#pragma mark - 录屏
//- (void)recodeSKView:(SKView *)skView scene:(SalScene *)scene currentTime:(NSTimeInterval)currentTime {
//
//    NSInteger framesTotal = 480;
//    static int item = 1;
//    if (item < 2) {
//
//        __weak __typeof(self) weakSelf = self;
//
//        CGFloat date = 1.0/20.f;
//
//        _startTime += date;
//
//        date = _startTime;
//
//        if (_imageModelArr == nil) {
//            _imageModelArr = [NSMutableArray array];
//        }
//
//        NSString * msg = [NSString stringWithFormat:@"%f", date];
////        [scene setDebugMessage:msg];
//
////        NSLog(@" ---->>>%f", date);
//
//        NSString * audioFileName = [NSString stringWithFormat:@"audio_%d.aac", item];
//
//        if (_imageModelArr.count < framesTotal) {
//            if (![SalConverVideoTool isStartRecode]) {
//                [SalConverVideoTool recodeAudioWithName:audioFileName resultBlock:^(BOOL isSuccess) {
//
//                }];
//            }
//
//            UIImage * image = nil;
//#if TARGET_OS_IPHONE
////            image = [UIImageDataCenter cache_getImageWithView:skView];
//#else
//            SKTexture * texture = [skView textureFromNode:scene];
//            CGImageRef cgImage = texture.CGImage;
//            image = [[UIImage alloc] initWithCGImage:cgImage size:texture.size];
//            if (imageRef) {
//                CGImageRelease(imageRef);
//            }
//#endif
//            if ([image isKindOfClass:[UIImage class]]) {
//
//                SalScreenShotModel * model = [SalScreenShotModel instanceWithImage:image time:date];
//                [_imageModelArr addObject:model];
//            }
//        }
//
//        FLYLog(@"count : %ld", _imageModelArr.count);
//
//        if (_imageModelArr.count == framesTotal) {
//
//            [SalConverVideoTool pauseRecode];
//            [self.delegate pauseScene];
//
//            NSString * videoFileName = [NSString stringWithFormat:@"movie_%d.mov", item];
//
//            [SalConverVideoTool startConverImageWithArray:[_imageModelArr copy] videoSize:skView.bounds.size videoName:videoFileName audioName:audioFileName resultBlock:^(BOOL isSuccess) {
//                 __strong __typeof(weakSelf) strongSelf = weakSelf;
//                if (isSuccess) {
//                    [strongSelf.delegate resumeScene];
//                }
//            }];
//            [self releaseCaptureArr];
//            item ++;
//        }
//    }
//}
//
//- (void)releaseCaptureArr {
//
//    while (_imageModelArr.lastObject) {
//        id lastObject = _imageModelArr.lastObject;
//        [_imageModelArr removeLastObject];
//        lastObject = nil;
//    }
//    _imageModelArr = nil;
//    _startTime = 0.f;
//}
//
//- (NSArray *)getImageArr {
//
//    return _imageModelArr;
//}

//@end
