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
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerItem *currentItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 30)];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(playSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 =[[UIButton alloc] initWithFrame:CGRectMake(200, 100, 60, 30)];
    [button2 setBackgroundColor:[UIColor grayColor]];
    [button2 addTarget:self action:@selector(pauseSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

    UIButton *button3 =[[UIButton alloc] initWithFrame:CGRectMake(300, 100, 60, 30)];
    [button3 setBackgroundColor:[UIColor redColor]];
    [button3 addTarget:self action:@selector(stopSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];

    
    
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSLog(@"address：%@",document);
    
    NSString *urlStr = @"http://oss.newaircloud.com/xkycs/att/201708/10/6df537fb-3115-48ad-87db-bc28f8480bc6.mp3";
    
    AVPlayerItem *songItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    _player = [AVPlayer playerWithPlayerItem:songItem];
    
    [self.player play];
    
//        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

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


-(void)playSong{
    [self putLog];
    [self.player play];
    [self putLog];

}

-(void)pauseSong{
    [self putLog];

    [self.player pause];
    
    [self putLog];

}

-(void)stopSong{
    [self putLog];
}

-(void)putLog{
    switch (self.player.status)
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
