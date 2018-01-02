//
//  ViewController.m
//  UIWebView
//
//  Created by qiuShan on 2017/12/20.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UITextField  *  textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
}

- (void)initSubViews {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, width - 20, 100)];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
    _textField.contentMode = UIViewContentModeTopLeft;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.layer.borderColor = [UIColor redColor].CGColor;
    _textField.layer.borderWidth = 1.f;
    [_textField setFont:[UIFont systemFontOfSize:16]];
    [_textField setTextColor:[UIColor blackColor]];
    _textField.textAlignment = NSTextAlignmentLeft;
    [_textField becomeFirstResponder];
    
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [button setCenter:CGPointMake(width/2.0, CGRectGetMaxY(_textField.frame) + 60)];
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(jumpToWebView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_textField];
    [self.view addSubview:button];
}

- (void)jumpToWebView {
    
    WebViewController * webView  =[[WebViewController alloc] initWithUrlStr:_textField.text];
    
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
