//
//  AudioResourceLoaderManager.h
//  Unity-iPhone
//
//  Created by qiuShan on 2018/1/11.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString * fullPath(NSString * fileName)
{
    NSString * fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    fullPath = [fullPath stringByAppendingFormat:@"/audio/"];
    NSHomeDirectory()
    return [fullPath stringByAppendingPathComponent:fileName];
}

@class AudioResourceLoaderManager;

@protocol AudioResourceLoaderDelegate <NSObject>

- (void)resourceLoader:(AudioResourceLoaderManager *)loader didReciveDataWithPath:(NSString *)fullPath request:(NSURLRequest *)request;

- (void)resourceLoader:(AudioResourceLoaderManager *)loader shouldStartPlayWithPath:(NSString *)fullPath request:(NSURLRequest *)request;

- (void)resourceLoader:(AudioResourceLoaderManager *)loader finishReciveDataWithPath:(NSString *)fullPath request:(NSURLRequest *)request;

@end

@interface AudioResourceLoaderManager: NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<AudioResourceLoaderDelegate>  delegate;

- (void)startOfflineWithUrlStr:(NSString*)urlStr;

@end
