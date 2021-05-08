////
////  SalConverVideoTool.m
////  MXSALEngine
////
////  Created by mx-QS on 2019/10/9.
////  Copyright © 2019 Fly. All rights reserved.
////
//
//#import "SalConverVideoTool.h"
//#import <MediaPlayer/MediaPlayer.h>
//#import <AVFoundation/AVFoundation.h>
//#import "SalScreenShotTool.h"
//
//@implementation SalConverVideoTool
//
//+ (NSString *)pathWithFileName:(NSString *)fileName {
//    
//    NSString * rootPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString * moviePath = [rootPath stringByAppendingPathComponent:fileName];
//    return moviePath;
//}
//
//+ (void)operationInMainQueue:(void(^)(void))operation {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (operation) {
//            operation();
//        }
//    });
//}
//
////对图片尺寸进行压缩--
//+ (SALImage *)imageWithImage:(SALImage *)image scaledToSize:(CGSize)imageSize {
//    
//    return [SalDataTool resizeImage:image size:imageSize];
//}
//
//+ (NSArray *)resetImagesWithArr:(NSArray *)imageArr imageSize:(CGSize)videoSize {
//    
////    NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:imageArr.count];
//    
//    int width  = videoSize.width;
//    int height = videoSize.height;
//    
//    int perCount = 16;
//    if (width%perCount != 0) {
//        width = width - width%perCount;
//    }
//    height = (int)(height * width / videoSize.width);
//    CGSize trueVideoSize = CGSizeMake(width, height);
//    for (int i = 0; i < imageArr.count; i++) {
//        SalScreenShotModel * imageModel = imageArr[i];
//        if (!CGSizeEqualToSize(imageModel.image.size, trueVideoSize)) {
//            imageModel.image = [self imageWithImage:imageModel.image scaledToSize:trueVideoSize];
//        }
////        [imageArray addObject:image];
//    }
//    
//    return imageArr;
//}
//
//#pragma mark - 转换开始
//+ (void)startConverImageWithArray:(NSArray *)imageArr videoSize:(CGSize)videoSize videoName:(NSString *)videoName audioName:(NSString *)audioName resultBlock:(ConverBlock)block {
//    
//    static NSOperationQueue * operationQueue = nil;
//    if (operationQueue == nil) {
//        operationQueue = [[NSOperationQueue alloc] init];
//        [operationQueue setMaxConcurrentOperationCount:2];
//    }
//    
//    [operationQueue addOperationWithBlock:^{
//        
//        @autoreleasepool {
//            
//            if ([imageArr isKindOfClass:[NSArray class]] && imageArr.count > 0 && [videoName isKindOfClass:[NSString class]] && videoName.length > 0 && [audioName isKindOfClass:[NSString class]] && audioName.length > 0) {
//                
//                NSString * videoPath = [self pathWithFileName:videoName];
//                NSString * audioPath = [self pathWithFileName:audioName];
//                
//               __block NSArray * targetArr = [self resetImagesWithArr:imageArr imageSize:videoSize];
//           
//                [self startConverWithArray:targetArr videoSize:videoSize moviePath:videoPath resultBlock:^(BOOL isSuccess) {
//                    
//                    targetArr = nil;
//                    if (isSuccess) {
//                        [self addAudioToVideoAudioPath:audioPath videoPath:videoPath completion:^(BOOL isSuccess) {
//                            
//                            if (isSuccess) {
//                                SALLog(@"-------------音视频合成完成------------\n%@", videoPath);
//                                
//                            } else {
//                                SALLog(@"-----音视频合成失败-----\n%@", videoPath);
//                            }
//                            
//                            if (block) {
//                                [self operationInMainQueue:^{
//                                    block(isSuccess);
//                                }];
//                            }
//                        }];
//                    } else {
//                        SALLog(@"-----视频合成失败-----\n%@", videoPath);
//                        if (block) {
//                            [self operationInMainQueue:^{
//                                block(isSuccess);
//                            }];
//                        }
//                    }
//                }];
//            }
//        }
//    }];
//}
//
//#pragma mark - 开始合成视频
//+ (NSString *)startConverWithArray:(NSArray *)imageArray videoSize:(CGSize)videoSize moviePath:(NSString *)moviePath resultBlock:(ConverBlock)block {
//    
//    NSError * error = nil;
//    //    转成UTF-8编码
//    unlink([moviePath UTF8String]);
//    
//    //     iphone提供了AVFoundation库来方便的操作多媒体设备，AVAssetWriter这个类可以方便的将图像和音频写成一个完整的视频文件
//    
//    AVAssetWriter * videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:moviePath] fileType:AVFileTypeQuickTimeMovie error:&error];
//    
//    NSParameterAssert(videoWriter);
//    
//    if(error) {
//        SALLog(@"error = %@", [error localizedDescription]);
//        return nil;
//    }
//    
//    //mov的格式设置 编码格式 宽度 高度
//    NSDictionary * videoSettingsDic = @{AVVideoCodecKey : AVVideoCodecTypeH264,
//                                        AVVideoWidthKey : [NSNumber numberWithInt:videoSize.width],
//                                        AVVideoHeightKey : [NSNumber numberWithInt:videoSize.height]};
//    
//    AVAssetWriterInput * writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettingsDic];
//    
//    NSDictionary * sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey,nil];
//    
//    //    AVAssetWriterInputPixelBufferAdaptor提供CVPixelBufferPool实例,
//    //    可以使用分配像素缓冲区写入输出文件。使用提供的像素为缓冲池分配通常
//    //    是更有效的比添加像素缓冲区分配使用一个单独的池
//    AVAssetWriterInputPixelBufferAdaptor * adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
//    
//    NSParameterAssert(writerInput);
//    
//    if(![videoWriter canAddInput:writerInput]){
//        
//        if (block) {
//            [self operationInMainQueue:^{
//                block(NO);
//            }];
//        }
//        imageArray = nil;
//        return nil;
//    }
//    
//    [videoWriter addInput:writerInput];
//    [videoWriter startWriting];
//    [videoWriter startSessionAtSourceTime:kCMTimeZero];
//    
//    //合成多张图片为一个视频文件
//    __block int frame = 0;
//    
//    int countPermin   = 24;//帧数
//    int countPerFrame = 1;
//    
//    if (imageArray.count < countPermin) {
//        countPermin = (int)imageArray.count;
//    }
//    dispatch_queue_t dispatchQueue = dispatch_get_main_queue();
//    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
//        
//        while([writerInput isReadyForMoreMediaData]) {
//            
//            @autoreleasepool {
//                
//                
//                int idx = frame / countPerFrame;
//                
//                SalScreenShotModel * model = [imageArray objectAtIndex:idx];
//                
//                CVPixelBufferRef buffer = [self pixelBufferFromCGImage:model.image];
//                
//                //            if (![writerInput isReadyForMoreMediaData]) {
//                //                break;
//                //            }
//                
//                while (![writerInput isReadyForMoreMediaData]) {
//                    
//                    NSLog(@"等 -- %d",idx);
//                }
//                
//                if(buffer) {
////                    CMTime time = CMTimeMake(frame, countPermin);
//                    CMTime time = CMTimeMakeWithSeconds(model.time, 1000);
//                    //设置每秒钟播放图片的个数
//                    BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:time];
//                    CFRelease(buffer);
//                    NSString * progress = [NSString stringWithFormat:@"合成进度:%0.2f - %d - %f", idx * 1.0 / [imageArray count], idx, CMTimeGetSeconds(time)];
//                    if(!result) {
//                        progress = [progress stringByAppendingString:@" - FAIL"];
//                        frame--;
//                    } else {
//                        progress = [progress stringByAppendingString:@" - OK"];
//                    }
//                    SALLog(@"%@", progress);
//                }
//                
//                if(++frame >= [imageArray count] * countPerFrame) {
//                    
//                    [writerInput markAsFinished];
//                    
//                    [videoWriter finishWritingWithCompletionHandler:^{
//                        
//                        if (block) {
//                            [self operationInMainQueue:^{
//                                block(YES);
//                            }];
//                        }
//                    }];
//                    break;
//                }
//            }
//        }
//    }];
//    
//    return moviePath;
//}
//
//+ (CVPixelBufferRef)pixelBufferFromCGImage:(SALImage *)oriImage {
//    
//    CGImageRef imageRef = [SalDataTool imageRefWithImage:oriImage];
//    size_t imageWidth  = CGImageGetWidth(imageRef);//imageSize.width
//    size_t imageHeight = CGImageGetHeight(imageRef);//imageSize.height
//    
//    const void *keys[] = {
//        kCVPixelBufferIOSurfacePropertiesKey,
//        kCVPixelBufferCGImageCompatibilityKey,
//        kCVPixelBufferCGBitmapContextCompatibilityKey,
//    };
//    
//    const void *values[] = {
//        (__bridge const void *)([NSDictionary dictionary]),
//        (__bridge const void *)([NSNumber numberWithBool:YES]),
//        (__bridge const void *)([NSNumber numberWithBool:YES]),
//    };
//    
//    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 3, NULL, NULL);
//    
//    OSType bufferPixelFormat = kCVPixelFormatType_32ARGB;//kCVPixelFormatType_32ARGB
//    
//    CVPixelBufferRef pxbuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageWidth, imageHeight, bufferPixelFormat, optionsDictionary, &pxbuffer);
//    
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//    
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    
//    void * pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    
//    NSParameterAssert(pxdata != NULL);
//    
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    /*
//     当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，
//     Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
//     
//     8, 4 * imageSize.width
//     */
//    
//    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
//    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
//    
//    CGContextRef context = CGBitmapContextCreate(pxdata, imageWidth, imageHeight, bitsPerComponent, bytesPerRow, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
//    
//    //    NSParameterAssert(context);
//    
//    if (context) {
//        
//        //使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
//        
//        //当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是SALImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
//        
//        CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
//        
//        //    CGContextDrawImage(context, CGRectMake(0 + (imageSize.width - CGImageGetWidth(image))/2,
//        //                                           (imageSize.height - CGImageGetHeight(image))/2,
//        //                                           CGImageGetWidth(image),
//        //                                           CGImageGetHeight(image)), image);
//        
//        // 释放context
//        CGContextRelease(context);
//    }
//    //释放色彩空间
//    CGColorSpaceRelease(rgbColorSpace);
//    // 解锁pixel buffer
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//    
//    return pxbuffer;
//}
//
//#pragma mark - 录音
//static AVAudioRecorder * audioRecorder = nil;
//+ (void)recodeAudioWithName:(NSString *)audioName resultBlock:(ConverBlock)block {
//    
//#if TARGET_OS_IPHONE
//    //音频会话
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *sessionError;
//    /*
//     AVAudioSessionCategoryPlayAndRecord :录制和播放
//     AVAudioSessionCategoryAmbient       :用于非以语音为主的应用,随着静音键和屏幕关闭而静音.
//     AVAudioSessionCategorySoloAmbient   :类似AVAudioSessionCategoryAmbient不同之处在于它会中止其它应用播放声音。
//     AVAudioSessionCategoryPlayback      :用于以语音为主的应用,不会随着静音键和屏幕关闭而静音.可在后台播放声音
//     AVAudioSessionCategoryRecord        :用于需要录音的应用,除了来电铃声,闹钟或日历提醒之外的其它系统声音都不会被播放,只提供单纯录音功能.
//     */
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
//    [session setActive:YES error:nil];
//#else
//    
//#endif
//    // 录音参数
//    NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,// 编码格式
//                             [NSNumber numberWithFloat:8000], AVSampleRateKey, //采样率
//                             [NSNumber numberWithInt:2], AVNumberOfChannelsKey, //通道数
//                             [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,  //采样位数(PCM专属)
//                             [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,  //是否允许音频交叉(PCM专属)
//                             [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,  //采样信号是否是浮点数(PCM专属)
//                             [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,  //是否是大端存储模式(PCM专属)
//                             [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,  //音质
//                             nil];
//    
//    
//    if (audioRecorder == nil) {
//        //保存路径
//        NSString * audioPath = [self pathWithFileName:audioName];
//        
//        if (![[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
//            [[NSFileManager defaultManager] createFileAtPath:audioPath contents:[NSData data] attributes:nil];
//        }
//        
//        NSError * error = nil;
//        audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:audioPath] settings:setting error:&error];
//        
//        //    audioRecorder.delegate = self;
//        //开启音频测量
//        audioRecorder.meteringEnabled = YES;
//    }
//    
//    if (!audioRecorder.isRecording) {
//        //准备 / 开始录音
//        [audioRecorder prepareToRecord];
//        [audioRecorder record];
//    }
//}
//
//+ (BOOL)isStartRecode {
//    
//    return audioRecorder != nil;
//}
//
//+ (void)pauseRecode {
//    
//    if (audioRecorder) {
//        [audioRecorder stop];
//        audioRecorder = nil;
//    }
//}
//
//#pragma mark - 音视频合成
//
//+ (void)addAudioToVideoAudioPath:(NSString *)audioPath videoPath:(NSString *)videoPath completion:(ConverBlock)completion {
//    
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        //初始化audioAsset
//        AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:audioPath] options:nil];
//        //初始化videoAsset
//        AVURLAsset * videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
//        
//        
//        //初始化合成类
//        AVMutableComposition * mixComposition = [AVMutableComposition composition];
//        
//        //初始化设置轨道type为AVMediaTypeAudio
//        NSError * audioTrackError = nil;
//        AVMutableCompositionTrack * compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//        //根据音频时常添加到设置里面
//        [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&audioTrackError];
//        
//        
//        //初始化设置轨道type为VideoTrack
//        NSError * videoTrackError = nil;
//        AVMutableCompositionTrack * compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        //设置视频时长等
//        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:&videoTrackError];
//        
//        
//        //初始化导出类 AVAssetExportPresetMediumQuality AVAssetExportPresetPassthrough
//        AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
//        //导出路径
//        NSString * exportPath = videoPath;
//        NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
//            [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
//        }
//        
//        assetExport.outputFileType = AVFileTypeQuickTimeMovie;
//        assetExport.outputURL = exportUrl;
//        assetExport.shouldOptimizeForNetworkUse = YES;
//        
//        __weak __typeof(assetExport) weakAssetExport = assetExport;
//        //导出
//        [assetExport exportAsynchronouslyWithCompletionHandler:^{
//            
//            SALLog(@"*->>合成音视频进度:%.1f error:%@", weakAssetExport.progress, weakAssetExport.error);
//            
//            /*
//             AVAssetExportSessionStatusUnknown = 0,
//             AVAssetExportSessionStatusWaiting = 1,
//             AVAssetExportSessionStatusExporting = 2,
//             AVAssetExportSessionStatusCompleted = 3,
//             AVAssetExportSessionStatusFailed = 4,
//             AVAssetExportSessionStatusCancelled = 5
//             */
//            switch (weakAssetExport.status) {
//                case AVAssetExportSessionStatusCompleted:
//                    if (completion) {
//                        [self operationInMainQueue:^{
//                            completion(YES);
//                        }];
//                    }
//                    break;
//                case AVAssetExportSessionStatusFailed:
//                    if (completion) {
//                        [self operationInMainQueue:^{
//                            completion(YES);
//                        }];
//                    }
//                    break;
//                case AVAssetExportSessionStatusExporting:
//                    
//                    break;
//                default:
//                    break;
//            }
//        }];
//        
//    });
//}
//
////转换成mp4格式
//+ (void)convertToMP4VideoPath:(NSString *)videoPath completed:(ConverBlock)completed {
//    
//    NSString * filePath = videoPath;
//    
//    NSString * mp4FilePath = [filePath stringByReplacingOccurrencesOfString:@"mov" withString:@"mp4"];
//    
//    AVURLAsset * avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
//    
//    NSArray * compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//    
//    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
//        
//        AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
//        exportSession.outputURL = [NSURL fileURLWithPath:mp4FilePath];
//        exportSession.outputFileType = AVFileTypeMPEG4;
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:mp4FilePath]) {
//            
//            [[NSFileManager defaultManager] removeItemAtPath:mp4FilePath error:nil];
//        }
//        
//        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
//            switch (exportSession.status) {
//                case AVAssetExportSessionStatusUnknown: {
//                    SALLog(@"AVAssetExportSessionStatusUnknown");
//                    break;
//                }
//                case AVAssetExportSessionStatusWaiting: {
//                    SALLog(@"AVAssetExportSessionStatusWaiting");
//                    break;
//                }
//                case AVAssetExportSessionStatusExporting: {
//                    SALLog(@"AVAssetExportSessionStatusExporting");
//                    break;
//                }
//                case AVAssetExportSessionStatusFailed: {
//                    SALLog(@"AVAssetExportSessionStatusFailed error:%@", exportSession.error);
//                    break;
//                }
//                case AVAssetExportSessionStatusCompleted: {
//                    SALLog(@"AVAssetExportSessionStatusCompleted");
//                    dispatch_async(dispatch_get_main_queue(),^{
//                        if (completed) {
//                            completed(YES);
//                        }
//                    });
//                    break;
//                }
//                default: {
//                    SALLog(@"AVAssetExportSessionStatusCancelled");
//                    break;
//                }
//            }
//        }];
//    }
//}
//
//
//#pragma mark - 逆向转换
//
//+ (SALImage *)imageConverWithImage:(SALImage *)image size:(CGSize)size
//{
//    if (!CGSizeEqualToSize(image.size, size)) {
//        image = [SalConverVideoTool imageWithImage:image scaledToSize:size];
//    }
//    CVPixelBufferRef buffer = [self pixelBufferFromCGImage:image];
//    SALImage * targetImage = [self trasformToImageFromCVPixelBufferRef:buffer];
//    CFRelease(buffer);
//    return targetImage;
//}
//
//// CVImageBufferRef to SALImage
//+ (SALImage *)trasformToImageFromCVImageBufferRef:(CVImageBufferRef)imageBuffer
//{
//    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
//    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//    CGImageRef videoImage = [temporaryContext
//                             createCGImage:ciImage
//                             fromRect:CGRectMake(0, 0,
//                                                 CVPixelBufferGetWidth(imageBuffer),
//                                                 CVPixelBufferGetHeight(imageBuffer))];
//    SALImage * image = [SalDataTool imageWithImageRef:videoImage];
//    CGImageRelease(videoImage);
//    return image;
//}
//
//+ (SALImage *)trasformToImageFromCMSampleBufferRef:(CMSampleBufferRef)sampleBuffer
//{
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
//                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    CGImageRef videoImage = CGBitmapContextCreateImage(context);
//    
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    SALImage * image = [SalDataTool imageWithImageRef:videoImage];
//    CGImageRelease(videoImage);
//    return (image);
//}
//
//+ (SALImage*)trasformToImageFromCVPixelBufferRef:(CVPixelBufferRef)bufferRef {
//    
//    CIImage * ciImage = [CIImage imageWithCVPixelBuffer:bufferRef];
//    CIContext * context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
//    CGRect rect = CGRectMake(0, 0, CVPixelBufferGetWidth(bufferRef), CVPixelBufferGetHeight(bufferRef));
//    CGImageRef videoImage = [context createCGImage:ciImage fromRect:rect];
//    SALImage * image = [SalDataTool imageWithImageRef:videoImage];
//    CGImageRelease(videoImage);
//    
//    return image;
//}
//
//@end
