//
//  OnlineMusicPlayerManager.m
//  Unity-iPhone
//
//  Created by qiuShan on 2018/1/4.
//

#import "OnlineMusicPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioResourceLoaderManager.h"

@interface OnlineMusicPlayerManager ()<AudioResourceLoaderDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) AVPlayer  *  localPlayer;
@property (nonatomic, strong) AVPlayer  *  serverPlayer;

@property (nonatomic, strong) AVAudioPlayer  *  audioPlayer;

@property (nonatomic, strong) NSMutableArray * delegateArr;
@property (nonatomic, strong) AudioResourceLoaderManager  *  resourceLoaderManager;
@end

@implementation OnlineMusicPlayerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegateArr = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        _resourceLoaderManager = [[AudioResourceLoaderManager alloc] init];
        _resourceLoaderManager.delegate = self;
    }
    return self;
}

- (void)playAudioUrlStr:(NSString *)urlStr
{
    NSLog(@"-------------------------------------------------------");

    _serverPlayer = [self playerWithUrl:urlStr player:_serverPlayer];
}

- (void)stopAudio
{
    if (_localPlayer) {
        [_localPlayer pause];
    }
}

- (AVPlayer *)playerWithUrl:(NSString *)urlStr player:(AVPlayer *)player
{
    AVPlayerItem * item = [self creatNewItemWithUrl:urlStr];
    AVPlayer * avPlyer  = player;
    if (avPlyer) {
        [self removeObserverWithPlayer:avPlyer];
        [avPlyer pause];
        [avPlyer replaceCurrentItemWithPlayerItem:item];
    } else {
        avPlyer = [[AVPlayer alloc] initWithPlayerItem:item];
    }
    [self changeVolumeWithPlayer:player volume:1.0f];
    [self addObserverWithPlayer:avPlyer];
    return avPlyer;
}

- (void)changeVolumeWithPlayer:(AVPlayer *)avPlayer volume:(CGFloat)volume
{
    [self setPlayerVolumeWithVolume:volume player:avPlayer];
}

- (void)setPlayerVolumeWithVolume:(CGFloat)volume player:(AVPlayer*)player
{
    if (player.currentItem) {
        NSMutableArray *allAudioParams = [NSMutableArray array];
        AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:volume atTime:kCMTimeZero];
        [audioInputParams setTrackID:1];
        [allAudioParams addObject:audioInputParams];
        AVMutableAudioMix * audioMix = [AVMutableAudioMix audioMix];
        [audioMix setInputParameters:allAudioParams];
        [player.currentItem setAudioMix:audioMix];
    }
    if (player) {
        [player setVolume:volume];
    }
}

- (AVPlayerItem *)creatNewItemWithUrl:(NSString *)urlStr
{
    NSString * musicUrlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL * url = [NSURL URLWithString:musicUrlStr];
    
    AVURLAsset * musicAsset  = [[AVURLAsset alloc] initWithURL:url options:nil];

    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:musicAsset];

    return item;
}

- (void)addObserverWithPlayer:(AVPlayer *)player
{
    if (player) {
        if (player.currentItem) {
            [player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

- (void)removeObserverWithPlayer:(AVPlayer *)avplayer
{
    if (avplayer) {
        if (avplayer.currentItem) {
            [avplayer.currentItem removeObserver:self forKeyPath:@"status"];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem * item = object;
        if ([keyPath isEqualToString:@"status"]) {
            switch (item.status) {
                case AVPlayerItemStatusReadyToPlay:
                {
                    if (object == _localPlayer.currentItem) {
                        [_localPlayer play];
                        NSLog(@"*******************local start play*********************");
                    }
                    if (object == _serverPlayer.currentItem) {
                        [_serverPlayer play];
                        NSLog(@"*******************server start play*********************");
                    }
                }
                    break;
                default:
                {
                    NSLog(@"***********error:%@",item.error);
                    AVURLAsset * currentAsset = (AVURLAsset*)item.asset;
                    NSURL * currentUrl = currentAsset.URL;
                    NSString * path = fullPath(currentUrl.absoluteString.lastPathComponent);
                    if (!path.pathExtension.length) {
                        path = [path stringByAppendingPathExtension:@"mp3"];
                    }
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [self startPlayWithFileStr:path];
                    } else {
                        [self startLoadDataWithUrlStr:currentUrl.absoluteString];
                    }
                }
                    break;
            }
        }
    }
}

- (void)startLoadDataWithUrlStr:(NSString *)urlStr
{
    [_resourceLoaderManager startOfflineWithUrlStr:urlStr];
}

- (void)resourceLoader:(AudioResourceLoaderManager *)loader didReciveDataWithPath:(NSString *)fullPath request:(NSURLRequest *)request
{
    
}

- (void)resourceLoader:(AudioResourceLoaderManager *)loader shouldStartPlayWithPath:(NSString *)fullPath request:(NSURLRequest *)request
{
    [self startPlayWithFileStr:fullPath];
}

- (void)resourceLoader:(AudioResourceLoaderManager *)loader finishReciveDataWithPath:(NSString *)fullPath request:(NSURLRequest *)request
{
//    [self startPlayWithFileStr:fullPath];
}

- (void)startPlayWithFileStr:(NSString *)path
{
    AVURLAsset * currentAsset = (AVURLAsset*)_localPlayer.currentItem.asset;
    NSURL * currentUrl = currentAsset.URL;
    NSString * currentPath = currentUrl.absoluteString;
    if (![path.lastPathComponent isEqualToString:currentPath.lastPathComponent]) {
        NSURL * url = [NSURL fileURLWithPath:path isDirectory:NO];
        AVURLAsset * musicAsset  = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:musicAsset];
        _localPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
        [self addObserverWithPlayer:_localPlayer];
        [self changeVolumeWithPlayer:_localPlayer volume:1.0f];
    }
}

// 播放完成后
- (void)playbackFinished:(NSNotification *)notification
{
    AVPlayerItem * item = [notification object];
    if (item == _localPlayer.currentItem) {
//        [item seekToTime:kCMTimeZero completionHandler:nil];// item 跳转到初始
//        [_localPlayer play]; // 循环播放
    }
}

- (void)stopPlay
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_localPlayer) {
        [self removeObserverWithPlayer:_localPlayer];
        [_localPlayer pause];
        [_localPlayer.currentItem cancelPendingSeeks];
        [_localPlayer.currentItem.asset cancelLoading];
        _localPlayer = nil;
    }
    
    if (_serverPlayer) {
        [self removeObserverWithPlayer:_serverPlayer];
        [_serverPlayer pause];
        [_serverPlayer.currentItem cancelPendingSeeks];
        [_serverPlayer.currentItem.asset cancelLoading];
        _serverPlayer = nil;
    }
//    [[NSFileManager defaultManager] file];
}

@end
