//
//  ViewController.m
//  语音合成
//
//  Created by walg on 2017/5/19.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#import "iflyMSC/IFlyMSC.h"
@interface ViewController ()<IFlySpeechSynthesizerDelegate>
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //本地资源打包在app内
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    //本地demo本地发音人仅包含xiaoyan资源,由于auto模式为本地优先，为避免找不发音人错误，也限制为xiaoyan
    NSString *newResPath = [[NSString alloc] initWithFormat:@"%@/tts64res/common.jet;%@/tts64res/xiaoyan.jet",resPath,resPath];
    [[IFlySpeechUtility getUtility] setParameter:@"tts" forKey:[IFlyResourceUtil ENGINE_START]];
    [_iFlySpeechSynthesizer setParameter:newResPath forKey:@"tts_res_path"];
    
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
    //设置引擎类型
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_LOCAL] forKey:[IFlySpeechConstant ENGINE_TYPE]];
    
//    //设置语音合成的启动参数
//    [[IFlySpeechUtility getUtility] setParameter:@"tts" forKey:[IFlyResourceUtil ENGINE_START]];
//    //获得语音合成的单例
//    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
//    //设置协议委托对象
//    _iFlySpeechSynthesizer.delegate = self;
//    //设置本地引擎类型
//    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_LOCAL] forKey:[IFlySpeechConstant ENGINE_TYPE]];
//    //设置发音人为小燕
//    [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
//    //获取离线语音合成发音人资源文件路径。以发音人小燕为例，请确保资源文件的存在。
//    NSString *resPath = [[NSBundle mainBundle] resourcePath];
//    NSString *vcnResPath = [[NSString alloc] initWithFormat:@"%@/ttsres/common.jet;%@/tts64res/xiaoyan.jet",resPath,resPath];
//    //设置离线语音合成发音人资源文件路径
//    [_iFlySpeechSynthesizer setParameter:vcnResPath forKey:@"tts_res_path"];
//    
//    //设置音量，取值范围 0~100
//    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
//    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
//    [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
  
    UIButton *butn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 30)];
    [butn setBackgroundColor:[UIColor redColor]];
    [butn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butn];
    
}

-(void)start{
    //启动合成会话
    _iFlySpeechSynthesizer.delegate = self;
    [_iFlySpeechSynthesizer startSpeaking: @"你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。你好，我是科大讯飞的小燕。"];
}

//合成结束
- (void) onCompleted:(IFlySpeechError *) error {
    NSLog(@"合成结束");
    NSLog(@"%@",error.errorDesc);
}

//合成开始
- (void) onSpeakBegin {
    NSLog(@"合成开始");
}

//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
    NSLog(@"合成<%@>缓冲进度：%d",msg,progress);
}

//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    NSLog(@"播放缓冲进度：%d",progress);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
