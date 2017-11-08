//
//  ViewController.m
//  WebView+image
//
//  Created by qiuShan on 2017/10/27.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 180, 40)];
    [leftButton setTitle:@"跳转UIWebView" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(jumpToUIWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 180, 40)];
    [rightButton setTitle:@"跳转WKWebView" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(jumpToWKWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    [self copyImage];
   
}

-(void)copyImage{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString * documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString * imagePath = [documPath stringByAppendingPathComponent:@"/abcd.png"];
    
    if (![fileManager fileExistsAtPath:imagePath]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"abcd" ofType:@"png"];
        

        BOOL success = [fileManager copyItemAtPath:path toPath:imagePath error:nil];
        
        NSLog(@"imag成功：%d",success);
    }
    
    NSString *htmlPath = [documPath stringByAppendingPathComponent:@"/inxex.html"];
    
    
    
    if (![fileManager fileExistsAtPath:htmlPath]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"inxex" ofType:@"html"];
        
        BOOL success = [fileManager copyItemAtPath:path toPath:htmlPath error:nil];
        
        NSLog(@"html成功：%d",success);
        
    }else{
        
        BOOL success = [fileManager removeItemAtPath:htmlPath error:nil];
        
        NSLog(@"移除成功：%d",success);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"inxex" ofType:@"html"];
        
        success = [fileManager copyItemAtPath:path toPath:htmlPath error:nil];
        
        NSLog(@"html成功：%d",success);
    }
    
}

-(void)jumpToUIWebView{
    
    SecondViewController * vc = [[SecondViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)jumpToWKWebView{
    
    ThirdViewController * vc = [[ThirdViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
