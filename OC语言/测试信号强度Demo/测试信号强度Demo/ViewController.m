//
//  ViewController.m
//  测试信号强度Demo
//
//  Created by qiuShan on 2017/11/20.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "ViewController.h"

#define MainScreenWidth  [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

@property (nonatomic, strong) UITextView  *  textView;

@property (nonatomic, strong) NSTimer  *  timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(netState) userInfo:nil repeats:YES];
}

static NSString * timeNow(){
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * time = [dateFormatter stringFromDate:date];
    
    return time;
}

static NSString * appName(){
    
    NSDictionary * infoDic = [NSBundle mainBundle].infoDictionary;
    
    NSString * appName = infoDic[@"CFBundleDisplayName"];
    
    return appName;
}

//static NSString * deviceInfo(){
//  UIDevice * currentDevice = [UIDevice currentDevice];
//
//
//}

- (void)initSubViews{
    
    UIButton * startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [startButton setCenter:CGPointMake(MainScreenWidth/2.0f,60)];
    
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton setTitle:@"暂停" forState:UIControlStateSelected];
    startButton.selected = YES;
    
    [startButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [startButton addTarget:self action:@selector(pauseOrStart:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(startButton.frame)+30, MainScreenWidth-16, MainScreenHeight - 5 - CGRectGetMaxY(startButton.frame)-30)];
    [_textView setBackgroundColor:[UIColor blackColor]];
    [_textView setFont:[UIFont systemFontOfSize:10]];
    [_textView setTextColor:[UIColor whiteColor]];
    _textView.editable = NO;
    
    [self.view addSubview:_textView];
    
}

- (void)pauseOrStart:(UIButton*)sender{
    
    if (sender.selected) {
        [_timer invalidate];
        _timer = nil;
    }else{
        if (!_timer) {
          _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(netState) userInfo:nil repeats:YES];
        }
    }
    sender.selected = !sender.selected;
    [sender setTitle:@"开始" forState:UIControlStateNormal];
    [sender setTitle:@"暂停" forState:UIControlStateSelected];
}

- (void)netState{
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *foregroundViews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    NSString * result = @"";
    
    for (id child in foregroundViews) {
        
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            
           int type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            NSString *stateString = @"wifi";
            
            switch (type) {
                case 0:
                    stateString = @"notReachable";
                    break;
                    
                case 1:
                    stateString = @"2G";
                    break;
                    
                case 2:
                    stateString = @"3G";
                    break;
                    
                case 3:
                    stateString = @"4G";
                    break;
                    
                case 4:
                    stateString = @"LTE";
                    break;
                    
                case 5:
                    stateString = @"wifi";
                    break;
                    
                default:
                    break;
            }
            NSLog(@"%@",stateString);
            
            [child setValue:@1 forKey:@"showRSSI"];
//            [child setValue:@1 forKey:@"enableRSSI"];
            
            
            NSInteger wifiStrengthRaw = [[child valueForKey:@"wifiStrengthRaw"] integerValue];
            
            NSInteger wifiStrengthBars = [[child valueForKey:@"wifiStrengthBars"] integerValue];
            
            result = [result stringByAppendingFormat:@"\n (3.1)currentNet:%@ \n (3.2)wifiStrengthRaw:%ld \n (3.3)wifiStrengthBars:%ld",stateString,wifiStrengthRaw,wifiStrengthBars];
            
        }
        
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarServiceItemView") class]]) {
           
            [child setValue:@1 forKey:@"loopingNecessaryForString"];
//            [child setValue:@1 forKey:@"loopNowIfNecessary"];
//            [child setValue:@1 forKey:@"loopingNow"];
            
            NSInteger serviceWidth = [[child valueForKeyPath:@"serviceWidth"] intValue];
            
            NSInteger maxWidth  = [[child valueForKey:@"maxWidth"] integerValue];
            
            NSString * serviceString = [child valueForKey:@"serviceString"];
            
            NSInteger crossfadeStep = [[child valueForKey:@"crossfadeStep"] integerValue];
            
            double crossfadeWidth = [[child valueForKey:@"crossfadeWidth"] doubleValue];
            
            NSInteger contentType = [[child valueForKey:@"contentType"] integerValue];
            
            result = [result stringByAppendingFormat:@"\n (2.1)serviceWidth:%ld \n (2.2)maxWidth:%ld \n (2.3)%@ \n (2.4)crossfadeStep:%ld \n (2.5)crossfadeWidth:%lf \n (2.6)contentType:%ld",serviceWidth,maxWidth,serviceString,crossfadeStep,crossfadeWidth,contentType];
        }
        
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
            
            [child setValue:@1 forKey:@"showRSSI"];
//            [child setValue:@1 forKey:@"enableRSSI"];
            
            NSInteger signalStrengthBars = [[child valueForKeyPath:@"signalStrengthBars"] integerValue];
            
            NSInteger signalStrengthRaw = [[child valueForKey:@"signalStrengthRaw"] integerValue];
            
            result = [result stringByAppendingFormat:@"\n (1.1)signalStrengthBars:%ld \n (1.2)signalStrengthRaw:%ld",signalStrengthBars,signalStrengthRaw];
           
        }
    }
    
    
    result = [NSString stringWithFormat:@"\n\n %@ %@ %@",appName(),timeNow(),result];
    
    [self showLogOnScreen:result];
}

//- (int)getSignal{
//    void *libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LAZY);
//    int (*CTGetSignalStrength)();
//    CTGetSignalStrength = dlsym(libHandle, "CTGetSignalStrength");
//    if( CTGetSignalStrength == NULL) MY_DEBUGGER_LOG(@"Could not find CTGetSignalStrength");
//    int result = CTGetSignalStrength();
//    dlclose(libHandle);
//    return result;
//}

- (void)showLogOnScreen:(NSString*)newLog{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView setText:[NSString stringWithFormat:@"%@%@",self.textView.text,newLog]];
//        [self.textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height-15, _textView.contentSize.width, 10) animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - newLog.length, newLog.length)];
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
