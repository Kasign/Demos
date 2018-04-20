//
//  FourthViewController.m
//  WebView+image
//
//  Created by qiuShan on 2018/3/14.
//  Copyright © 2018年 秋山. All rights reserved.
//

#import "FourthViewController.h"
#import <WebKit/WebKit.h>

#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height

@interface FourthViewController ()<UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong)WKWebView   *  webView;

@end

@implementation FourthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_htmlPath.length) {
        NSURL * fileURL = [NSURL fileURLWithPath:_htmlPath];
        NSURL * baseURL = [NSURL fileURLWithPath:[[_htmlPath stringByDeletingLastPathComponent] stringByAppendingString:@"/"]];
        NSString * documentStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSURL * documentUrl = [NSURL fileURLWithPath:[documentStr stringByAppendingString:@"image"]];
        [self.webView loadFileURL:fileURL allowingReadAccessToURL:documentUrl];
    }
    
    [self.view addSubview:self.webView];
}

#pragma mark - 清除缓存和cookie
- (void)cleanCacheAndCookie
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(WKWebView *)webView
{
    if (!_webView) {
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"jsCallNative"];
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController   = userContentController;
        //创建WKWebView
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:configuration];
        
        _webView.backgroundColor     = [UIColor redColor];
        [_webView.scrollView setBackgroundColor:[UIColor whiteColor]];
        _webView.scrollView.delegate = self;
        _webView.navigationDelegate  = self;
        _webView.UIDelegate          = self;
        
    }
    return _webView;
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    NSLog(@"输入框");
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"警告框%@",message);
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"知道" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//js交互
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"\n body:%@ \n name:%@",message.body,message.name);
    
    if ([message.name isEqualToString:@"jsCallNative"]) {
        
        NSString * documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSString * imagePath = [documPath stringByAppendingPathComponent:@"/image/abcd.png"];
        
        NSString * js = [NSString stringWithFormat:@"nativeCallJS('%@')",imagePath];
        
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable data, NSError * _Nullable error) {
            NSLog(@"\n data:%@ \n error:%@",data,error);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
