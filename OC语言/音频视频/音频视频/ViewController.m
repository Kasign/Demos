//
//  ViewController.m
//  音频视频
//
//  Created by Walg on 2017/8/14.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic,strong) AVPlayer     * avPlayer;
@property (nonatomic,strong) AVPlayerItem * currentItem;

@property (nonatomic, strong) AVAudioPlayer * audioPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 30)];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"播放" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 =[[UIButton alloc] initWithFrame:CGRectMake(200, 100, 60, 30)];
    [button2 setBackgroundColor:[UIColor grayColor]];
    [button2 setTitle:@"暂停" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(pauseSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

    UIButton *button3 =[[UIButton alloc] initWithFrame:CGRectMake(300, 100, 60, 30)];
    [button3 setBackgroundColor:[UIColor redColor]];
    [button3 setTitle:@"停止" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(stopSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];

    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSLog(@"address：%@",document);
    
    
    NSString *urlStr = @"http://oss.newaircloud.com/xkycs/att/201708/10/6df537fb-3115-48ad-87db-bc28f8480bc6.mp3";
    
    NSURL * songUrl = [NSURL fileURLWithPath:@"/Users/qiushan/Desktop/+1408-996-1010_20190704103730.m4a"];
    songUrl = [NSURL URLWithString:@"https://video.huishenghuo888888.com/putong/20191224/kYDcU528/index.m3u8"];
//https://video.huishenghuo888888.com/douyin/20191224/8lxbncRj/index.m3u8
//https://video.huishenghuo888888.com/putong/20191224/kYDcU528/index.m3u8
    AVPlayerItem *songItem = [AVPlayerItem playerItemWithURL:songUrl];
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    _avPlayer = [AVPlayer playerWithPlayerItem:songItem];
    _avPlayer.volume = 1;
    
    
    [_avPlayer play];
    
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avLayer.frame = CGRectMake(10, 160, 300, 300);
    [self.view.layer addSublayer:avLayer];
    
//        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    NSURL * url = [NSURL URLWithString:@"/Users/qiushan/Desktop/+1408-996-1010_20190704103730.m4a"];
//    url = [NSURL URLWithString:@"https://video.huishenghuo888888.com/douyin/20200119/FnPiWnrz/index.m3u8"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.volume = 1.0;
//    [_audioPlayer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
}


-(void)playSong
{
    [self putLog];
    [_avPlayer play];
    [self putLog];
//    [_audioPlayer play];
}

-(void)pauseSong
{
    [self putLog];
    [_avPlayer pause];
    [self putLog];
}

-(void)stopSong
{
    [self putLog];
}

-(void)putLog{
    switch (_avPlayer.status)
    {
        case AVPlayerStatusUnknown:
            NSLog(@"KVO：未知状态，此时不能播放");
            break;
        case AVPlayerStatusReadyToPlay:
            NSLog(@"KVO：准备完毕，可以播放");
            break;
        case AVPlayerStatusFailed:
            NSLog(@"KVO：加载失败，网络或者服务器出现问题");
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
