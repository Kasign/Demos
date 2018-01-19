//
//  ViewController.m
//  DownloadAndPlay
//
//  Created by qiuShan on 2018/1/15.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import "OnlineMusicPlayerManager.h"

@interface ViewController ()
@property (nonatomic, strong) OnlineMusicPlayerManager  *  manager;
@end

@implementation ViewController

static NSString * fullPath(NSString * fileName)
{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentPath stringByAppendingPathComponent:fileName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[OnlineMusicPlayerManager alloc] init];
    [self addButton];
    NSLog(@"***********>>>>>>>>path:%@",fullPath(@""));
}

//    http://120.25.226.186:32812/resources/videos/minion_01.mp4
//    https://test-wmodcdn.cgyouxi.com/audio/9645ab9cb84431da4aee0d92a5aef605/61/612c17ba5fe53793d37b6c978df7886b.mp3
//60M//   http://other.web.rh01.sycdn.kuwo.cn/resource/n3/94/61/1415881847.mp3
//  https://test-wmodcdn.cgyouxi.com/audio/9645ab9cb84431da4aee0d92a5aef605/e8/e8a14af01a43cf9373c7e111e58d0deb

- (void)addButton
{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 30)];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitle:@"暂停" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSString * str = @"https://test-wmodcdn.cgyouxi.com/audio/9645ab9cb84431da4aee0d92a5aef605/e8/e8a14af01a43cf9373c7e111e58d0deb";
        [_manager playAudioUrlStr:str];
    } else {
        [_manager stopPlay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
