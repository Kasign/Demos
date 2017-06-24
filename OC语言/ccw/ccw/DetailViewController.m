//
//  DetailViewController.m
//  ccw
//
//  Created by Walg on 2017/5/7.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation DetailViewController

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
    [self switchPage];
}

-(void)switchPage{
    
    [_webView removeFromSuperview];
    [_textView removeFromSuperview];
    
    if (self.object.type.intValue == 0) {
        [self.view addSubview:self.textView];
        [self stringConver];
    }else{
        [self.view addSubview:self.webView];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.object.urlString]];
        [self.webView loadRequest:request];
    }
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight-64)];
        _textView.backgroundColor = [UIColor whiteColor];
        [_textView setEditable:NO];
        [_textView setSelectable:NO];
        [_textView setBounces:NO];
        [_textView setContentMode:UIViewContentModeTop];
        [_textView setTextContainerInset:UIEdgeInsetsMake(0, 0, 30, 0)];
        [_textView setTextColor:[UIColor lightGrayColor]];
        [_textView setShowsVerticalScrollIndicator:NO];
        [_textView setShowsHorizontalScrollIndicator:NO];
        
    }
    return _textView;
}

-(void)stringConver{
    
    NSString *dLabelString = [NSString stringWithFormat:@"%@\n%@",self.object.title,self.object.content];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:dLabelString];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle setLineSpacing:5.0];
    //段落间距
    [paragraphStyle setParagraphSpacing:10.0];
    //第一行头缩进
    [paragraphStyle setFirstLineHeadIndent:30.0];
    //头部缩进
    [paragraphStyle setHeadIndent:15.0];
//    最小行高
    [paragraphStyle setMinimumLineHeight:20.0];
//    最大行高
    [paragraphStyle setMaximumLineHeight:20.0];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [dLabelString length])];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, self.object.title.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(self.object.title.length,dLabelString.length-self.object.title.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(self.object.title.length,dLabelString.length-self.object.title.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(self.object.title.length,dLabelString.length-self.object.title.length)];
    
    
    
    [self.textView setAttributedText:attributedString];
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (![request.URL.absoluteString containsString:self.object.urlString]) {
        [self popBack];
        return NO;
    }
    
    return YES;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
