//
//  ViewController.m
//  Downloader
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

#define MainScreenWidth  [NSScreen mainScreen].frame.size.width
#define MainScreenHeight [NSScreen mainScreen].frame.size.height

@interface ViewController ()

@property (nonatomic, strong) AFHTTPClient  *  downLoadManager;

@property (nonatomic, strong) NSTextField  *  urlTextField;

@property (nonatomic, strong) NSTextView  *  textView;

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

    NSString * document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"\n document:%@",document);
    
    [self initSubViews];
    
    NSString * imageStr = @"http://img5.imgtn.bdimg.com/it/u=4146227749,2786900840&fm=27&gp=0.jpg";
    
    imageStr = @"https://www.tunnelblick.net/release/Tunnelblick_3.7.4_build_4900.dmg";
    
//    self.urlTextField.text;
    
}

- (void)initSubViews{
    
    NSTextField * textfield = [[NSTextField alloc] initWithFrame:CGRectMake(10, 100, MainScreenWidth - 20, 30)];
    
    textfield.layer.borderWidth = 1.5f;
    textfield.layer.borderColor = [NSColor grayColor].CGColor;
    textfield.textColor = [NSColor blackColor];
    textfield.font = [NSFont systemFontOfSize:14];
    [self.view addSubview:textfield];
    _urlTextField = textfield;
    
    
//    NSButton * startButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    NSButton * startButton = [NSButton buttonWithTitle:@"开始" target:self action:@selector(startDownLoad:)];
    
//    [startButton setCenter:CGPointMake(MainScreenWidth/2.0f, CGRectGetMaxY(textfield.frame)+60)];
//
//    [startButton setTitle:@"开始" forState:UIControlStateNormal];
//    [startButton setTitle:@"暂停" forState:UIControlStateSelected];
//
//    [startButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [startButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//
//
//    [startButton addTarget:self action:@selector(startDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startButton];
    
    _textView = [[NSTextView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(startButton.frame)+60, MainScreenWidth-16, MainScreenHeight - 5 - CGRectGetMaxY(startButton.frame)-60)];
    [_textView setBackgroundColor:[NSColor blackColor]];
    [_textView setFont:[NSFont systemFontOfSize:10]];
    [_textView setTextColor:[NSColor whiteColor]];
    _textView.editable = NO;
    
    [self.view addSubview:_textView];
    
}

- (void)startDownLoad:(NSButton*)sender{

        [self download];

    
}

-(AFHTTPClient *)downLoadManager{
    if (!_downLoadManager) {
        _downLoadManager = [[AFHTTPClient alloc] init];
        
        
        
    }
    return _downLoadManager;
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
    
    
//    NSURLSessionDownloadTask *task = [self.downLoadManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        NSString * sysOutPut = [NSString stringWithFormat:@"[%@] %@",appName(),timeNow()];
//
//        NSString * putStr = [NSString stringWithFormat:@"%@ Total:%lld Comleted:%lld \n Progress:%.2f%% \n",sysOutPut,downloadProgress.totalUnitCount,downloadProgress.completedUnitCount,downloadProgress.completedUnitCount*100.0f/downloadProgress.totalUnitCount];
//
//        [self showLogOnScreen:putStr];
//
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//
//        NSURL * urlPath = [NSURL fileURLWithPath:path];
//        return urlPath;
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//        if (!error) {
//            [self showLogOnScreen:@"下载成功"];
//        }else{
//            NSString * failStr = [NSString stringWithFormat:@"下载失败  error:%@",error.description];
//            [self showLogOnScreen:failStr];
//        }
//
//    }];
//
//    [task resume];
    
}




- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
