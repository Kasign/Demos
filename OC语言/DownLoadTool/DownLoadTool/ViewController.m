//
//  ViewController.m
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

#import "DownloadToolManager.h"

#import "FlyNativeDownloadManager.h"

#import "FlyOfflineTool.h"

#define MainScreenWidth  [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) AFHTTPSessionManager  *  downLoadManager;

@property (nonatomic, strong) UITextField  *  urlTextField;

@property (nonatomic, strong) UITextView  *  textView;

@property (nonatomic, strong) DownloadToolManager  *  downloadTool;

@end

@implementation ViewController

static NSString * document(){
    NSString * document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    document = @"/Users/Qiushan/Desktop/";
    
    return document;
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
    
    NSString * appName = infoDic[@"CFBundleName"];
    
    return appName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString * document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSLog(@"\n document:%@",document);
    
    [self initSubViews];
    
    
    
//    NSString * imageStr1 = @"http://img5.imgtn.bdimg.com/it/u=4146227749,2786900840&fm=27&gp=0.jpg";
    
    NSString * imageStr2 = @"https://www.tunnelblick.net/release/Tunnelblick_3.7.4_build_4900.dmg";
    
    self.urlTextField.text = imageStr2;
    
    
    NSString * path = document();
    
    NSMutableDictionary * downDic = [@{imageStr2:@"1"} mutableCopy] ;//,imageStr2:@"1"
    
    for (NSString * key in downDic.allKeys) {
        
        NSString * lastPathComponent = [key substringWithRange:NSMakeRange(key.length - 10, 10)];
        
        path = [path stringByAppendingPathComponent:lastPathComponent];
        
        [downDic setValue:path forKey:key];
    }

//    [[FlyNativeDownloadManager sharedInstance] startDownload];
//    https://test-kcdn1.cgyouxi.com/audio/bestman/3JBmDtDXyf.mp3
//    http://120.25.226.186:32812/resources/videos/minion_01.mp4
    [[FlyOfflineTool sharedInstance] startOfflineWithUrlStr:@"https://test-kcdn1.cgyouxi.com/audio/bestman/3JBmDtDXyf.mp3"];
    
}


-(AFHTTPSessionManager *)downLoadManager{
    if (!_downLoadManager) {
        _downLoadManager = [AFHTTPSessionManager manager];
        
        AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _downLoadManager.responseSerializer = responseSerializer;
    }
    return _downLoadManager;
}

- (void)initSubViews{
    
    UITextField * textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, MainScreenWidth - 20, 30)];
    
    textfield.layer.borderWidth = 1.5f;
    textfield.layer.borderColor = [UIColor grayColor].CGColor;
    textfield.textColor = [UIColor blackColor];
    textfield.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textfield];
    _urlTextField = textfield;
    
    
    UIButton * startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [startButton setCenter:CGPointMake(MainScreenWidth/2.0f, CGRectGetMaxY(textfield.frame)+60)];
    
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton setTitle:@"暂停" forState:UIControlStateSelected];
    
    [startButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    
    [startButton addTarget:self action:@selector(startDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(startButton.frame)+60, MainScreenWidth-16, MainScreenHeight - 5 - CGRectGetMaxY(startButton.frame)-60)];
    [_textView setBackgroundColor:[UIColor blackColor]];
    [_textView setFont:[UIFont systemFontOfSize:10]];
    [_textView setTextColor:[UIColor whiteColor]];
    _textView.editable = NO;
    
    [self.view addSubview:_textView];
    
}

- (void)startDownLoad:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
//        [self download];
        [self startDownloadWithTool];
    }else{
//        [self.downLoadManager.downloadTasks.firstObject cancel];
        [_downloadTool stopDownload];
    }
    
}

- (void)startDownloadWithTool{
    [_downloadTool startDownloadTaskWithProgress:^(float progress) {
        
        NSString * progerssStr = [NSString stringWithFormat:@"\n %f",progress];
        
        [self showLogOnScreen:progerssStr];
        
    } completeBlock:^(BOOL success, NSError *error) {
        
        if (!error && success) {
            [self showLogOnScreen:@"\n下载成功"];
        }else{
            NSString * failStr = [NSString stringWithFormat:@"\n下载失败  error:%@",error.description];
            [self showLogOnScreen:failStr];
        }
        
    }];
}




- (void)download{
    
    NSString * urlStr = _urlTextField.text;
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL * fileUrl = [NSURL URLWithString:urlStr];
    
    NSError * error ;
    
    
    NSMutableURLRequest *request = [self.downLoadManager.requestSerializer requestWithMethod:@"GET" URLString:[fileUrl absoluteString] parameters:nil error:&error];
    
    if (!request) {
        NSLog(@"error:%@",error);
    }
    
    NSString * path = document();
    
    NSString * lastPathComponent = [request.URL.absoluteString.lastPathComponent substringWithRange:NSMakeRange(request.URL.absoluteString.lastPathComponent.length - 10, 10)];
    
    path = [path stringByAppendingPathComponent:lastPathComponent];
    
    NSLog(@"path:%@",path);
    
    
    NSURLSessionDownloadTask *task = [self.downLoadManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSString * sysOutPut = [NSString stringWithFormat:@"[%@] %@",appName(),timeNow()];
        
        NSString * putStr = [NSString stringWithFormat:@"%@ Total:%lld Comleted:%lld \n Progress:%.2f%% \n",sysOutPut,downloadProgress.totalUnitCount,downloadProgress.completedUnitCount,downloadProgress.completedUnitCount*100.0f/downloadProgress.totalUnitCount];

        [self showLogOnScreen:putStr];
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL * urlPath = [NSURL fileURLWithPath:path];
        return urlPath;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error) {
            [self showLogOnScreen:@"下载成功"];
        }else{
            NSString * failStr = [NSString stringWithFormat:@"下载失败  error:%@",error.description];
            [self showLogOnScreen:failStr];
        }
        
    }];
    
    [task resume];
    
}

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
