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
#import "FourthViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 180, 40)];
    [leftButton setTitle:@"跳转UIWebView" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(jumpToUIWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 180, 40)];
    [rightButton setTitle:@"跳转WKWebView" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(jumpToWKWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIButton * fourthButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 180, 40)];
    [fourthButton setTitle:@"跳转JS-WKWebView" forState:UIControlStateNormal];
    [fourthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fourthButton addTarget:self action:@selector(jumpToFourthWKWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fourthButton];
    
    
    [self copyImage];
    
}

-(void)copyImage
{
    
    //copy image 
    NSString * documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString * imageToPath = [[documPath stringByAppendingString:@"/image/"] stringByAppendingPathComponent:@"abcd.png"];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"abcd" ofType:@"png"];
    
    [self copyItemFromPath:imagePath toPath:imageToPath];
    
    //copy html
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html"];
    
    NSString * htmlToPath = [[documPath stringByAppendingString:@"/html/"] stringByAppendingPathComponent:@"index2.html"];
    [self copyItemFromPath:htmlPath toPath:htmlToPath];
    
    //copy js
    
    NSString * jsPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString * jsToPath = [[documPath stringByAppendingString:@"/html/js"] stringByAppendingPathComponent:@"test.js"];
    [self copyItemFromPath:jsPath toPath:jsToPath];
}

- (void)copyItemFromPath:(NSString *)path  toPath:(NSString *)toPath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString * targetDirect = [toPath stringByDeletingLastPathComponent];
    
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:targetDirect isDirectory:&isDir] && !isDir) {
        NSError * error ;
        BOOL success = [fileManager createDirectoryAtPath:targetDirect withIntermediateDirectories:YES attributes:nil error:&error];
        if (success && !error) {
            NSLog(@"  -----create dir success%@",targetDirect);
        } else {
            NSLog(@"  --fail to create dir error: %@ dir:%@",error,targetDirect);
        }
    }
    
    if ([fileManager fileExistsAtPath:path]) {
        
        BOOL success = [fileManager removeItemAtPath:toPath error:nil];
        NSLog(@" ------remove success  path：%@  success:%d",toPath.lastPathComponent,success);
        success = [fileManager copyItemAtPath:path toPath:toPath error:nil];
        NSLog(@" ----copy success  path：%@ success:%d",toPath.lastPathComponent,success);
    } else {
        NSLog(@" -- path not exist %@",path);
    }
}

-(void)jumpToUIWebView{
    
    SecondViewController * vc = [[SecondViewController alloc] init];
    
    [self pushToVC:vc];
}

-(void)jumpToWKWebView{
    
    ThirdViewController * vc = [[ThirdViewController alloc] init];
    
    [self pushToVC:vc];
}

- (void)jumpToFourthWKWebView
{
    FourthViewController * vc = [[FourthViewController alloc] init];
    
    NSString * documPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString * htmlPath = [[documPath stringByAppendingString:@"/html/"] stringByAppendingPathComponent:@"index2.html"];
    
    vc.htmlPath = htmlPath;
    
    [self pushToVC:vc];
}

- (void)pushToVC:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
