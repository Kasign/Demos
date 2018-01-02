//
//  WebViewController.m
//  UIWebView
//
//  Created by qiuShan on 2017/12/20.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSURL  *  url;

@end

@implementation WebViewController

- (instancetype)initWithUrlStr:(NSString *)urlStr
{
    self = [super init];
    if (self) {
        _url = [NSURL URLWithString:urlStr];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [webView setBackgroundColor:[UIColor cyanColor]];
    [webView loadRequest:[NSURLRequest requestWithURL:_url]];
    [self.view addSubview:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:error.description preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
