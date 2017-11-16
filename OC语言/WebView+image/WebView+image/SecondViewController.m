//
//  SecondViewController.m
//  WebView+image
//
//  Created by qiuShan on 2017/10/27.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "SecondViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)jsCallNative;
- (void)shareString:(NSString *)shareString;

@end

@interface SecondViewController ()<UIWebViewDelegate,JSObjcDelegate>

@property (nonatomic, strong) UIWebView  *  webView;

@property (nonatomic, strong) JSContext  *  jsContext;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString * lastPath = [NSString stringWithFormat:@"/%@.html",HtmlName];
    
    NSString *htmlPath = [documPath stringByAppendingPathComponent:lastPath];
    
    NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:fileURL]];


    [self.view addSubview:self.webView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

//此时不会销毁，可能是因为JSContext与self互相引用的关系
- (void)dealloc{
    NSLog(@"*******************dealloc**************************");
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
    NSLog(@"fail");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self doSomeJsThings];
}

//- (void)doSomeJsThings{
//
//    self.jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
//        NSLog(@"出现异常，异常信息：%@",exception);
//    };
//
//    //oc调用js
//    JSValue * jsObj = self.jsContext[@"globalObject"];
//
//    jsObj[@"creatJSMethod"] = ^(NSString*paramter){
//        NSLog(@"%@",paramter);
//    };
//
//    jsObj[@"nativeCallJS"] = ^(NSString * paramter){
//        NSLog(@"重写了JS本地方法：%@",paramter);
//    };
//
//
//    JSValue * returnValue = [jsObj invokeMethod:@"nativeCallJS" withArguments:@[@"hello word"]];//调用了js中方法"nativeCallJS",并且传参数@"hello word",这里returnValue是调用之后的返回值，可能为nil
//    NSLog(@"returnValue:%@",returnValue);
//
//
//    __weak typeof(self) weakSelf = self;
//    JSValue * jsCallNative = [JSValue valueWithObject:weakSelf inContext:self.jsContext];
//
//    self.jsContext[@"NativeObject"] = jsCallNative;
//
//    JSValue * callBack = self.jsContext[@"callBack"];
//    [callBack callWithArguments:@[@"hello"]];
//}

- (void)doSomeJsThings{
    self.jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"出现异常，异常信息：%@",exception);
    };
    
    __weak typeof(self)  weakSelf = self;
    self.jsContext[@"jsCallNative"] = ^(NSString * para){
        
        JSValue * method = weakSelf.jsContext[@"nativeCallJS"];
        
        NSString * documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSString * imagePath = [documPath stringByAppendingPathComponent:@"/abcd.png"];
        
        [method callWithArguments:@[imagePath]];
        
    };
    
    
}
   //在本地生成js方法，供js调用
- (void)jsCallNative{
    
    JSValue *currentThis = [JSContext currentThis];
    JSValue *currentCallee = [JSContext currentCallee];
    NSArray *currentParamers = [JSContext currentArguments];
    dispatch_async(dispatch_get_main_queue(), ^{
        /**
         *  js调起OC代码，代码在子线程，更新OC中的UI，需要回到主线程
         */
    });
    NSLog(@"currentThis is %@",[currentThis toString]);
    NSLog(@"currentCallee is %@",[currentCallee toString]);
    NSLog(@"currentParamers is %@",currentParamers);
    
}


- (void)shareString:(NSString *)shareString{//在本地生成js方法，供js调用
    
    JSValue *currentThis = [JSContext currentThis];
    JSValue *currentCallee = [JSContext currentCallee];
    NSArray *currentParamers = [JSContext currentArguments];
    dispatch_async(dispatch_get_main_queue(), ^{
        /**
         *  js调起OC代码，代码在子线程，更新OC中的UI，需要回到主线程
         */
        NSLog(@"js传过来：%@",shareString);
    });
    NSLog(@"JS paramer is %@",shareString);
    NSLog(@"currentThis is %@",[currentThis toString]);
    NSLog(@"currentCallee is %@",[currentCallee toString]);
    NSLog(@"currentParamers is %@",currentParamers);
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
