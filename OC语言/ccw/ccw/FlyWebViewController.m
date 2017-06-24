//
//  FlyWebViewController.m
//  ccw
//
//  Created by Walg on 2017/5/20.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyWebViewController.h"

@interface FlyWebViewController ()<UIWebViewDelegate>

@end

@implementation FlyWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
    [webView setBackgroundColor:[UIColor whiteColor]];
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://c16000.com"]];
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"失败");
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gt8822228.com"]];
    
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
