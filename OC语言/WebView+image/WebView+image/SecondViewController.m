//
//  SecondViewController.m
//  WebView+image
//
//  Created by qiuShan on 2017/10/27.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView  *  webView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"inxex" ofType:@"html"];
    
    NSString * documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *htmlPath = [documPath stringByAppendingPathComponent:@"/inxex.html"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:fileURL]];


    [self.view addSubview:self.webView];
}

-(UIWebView *)webView{
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        
        [_webView setDelegate:self];
        
        _webView.scalesPageToFit = YES;
        
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
